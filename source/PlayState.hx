package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.util.FlxDirectionFlags;
import flixel.FlxG;
import Std.int;
import openfl.Assets;
import flixel.text.FlxText;
import flixel.system.FlxSound;

typedef BlockGroup = {
	var block: Class<Block>;
	var group: FlxGroup;
};

class PlayState extends FlxState
{
	var walls: FlxGroup;
	var balls: FlxGroup;
	var blocks: FlxGroup;
	var unbreakable_blocks: FlxGroup;
	var player: Player;

	var score_text: FlxText;
	var score: Int;

	var game_over: Bool;
	var you_win: Bool;

	var _block_type: Map<String, BlockGroup>;

	var sound: FlxSound;

	public function new(score: Int) {
		super();
		this.score = score;
	}

	override public function create()
	{
		super.create();

		player = new Player();
		add(player);

		walls = new FlxGroup();

		walls.add(new Wall(0, 0, 10, FlxG.width));// UP
		walls.add(new Wall(0, 0, FlxG.height, 10)); // LEFT
		walls.add(new Wall(FlxG.width - 10, 0, FlxG.height, 10)); // RIGHT

		add(walls);

		balls = new FlxGroup();
		var ball = new Ball();
		balls.add(ball);
		add(balls);

		FlxG.plugins.add(new PowerUpManager());
		var power_up_manager = FlxG.plugins.get(PowerUpManager);
		power_up_manager.enable = false;
		
		var rows = Assets.getText(AssetPaths.map1__txt).split("\n");
		sound = FlxG.sound.load(AssetPaths.impactGeneric_light_000__ogg);

		blocks = new FlxGroup();
		unbreakable_blocks = new FlxGroup();

		_block_type = [
			"o" => {
				block: Breakable,
				group: blocks,
			},
			"x" => {
				block: Unbreakable,
				group: unbreakable_blocks,
			},
			"p" => {
				block: PowerUpBlock,
				group: unbreakable_blocks,
			},
		];

		var i: Int = 0;
		for (row in rows) {
			var j: Int = 0;
			for (type in row.split("")) {
				if (type != ".") {
					var parameters: Array<Dynamic> = [i, j];
					if (type == "p") {
						parameters.push(PowerUpType.SmallAndFast);
					}
					var block_type = _block_type[type].block;
					var block = Type.createInstance(block_type, parameters);
					var group = _block_type[type].group;
					group.add(block);
				}
				j = j + 1;
			}
			i = i + 1;
		}
		add(blocks);
		add(unbreakable_blocks);

		game_over = false;
		you_win = false;

		score_text = new FlxText(0, 0, 0, 'score: ${score}', 6);
		score_text.screenCenter();
		score_text.y = 0;
		add(score_text);

		if (FlxG.sound.music == null) {
			var volume = 0.6;
			FlxG.sound.playMusic(AssetPaths.Tutorials_TurnBasedRPG_assets_music_HaxeFlixel_Tutorial_Game__ogg, volume, true);
		}
	}

	override public function update(elapsed:Float)
	{
		if (you_win) {
			return;
		}

		if (game_over) {
			return;
		}

		super.update(elapsed);

		FlxG.overlap(this, null, collide);

		if (blocks.countLiving() == 0) {
			FlxG.camera.fade(FlxColor.BLACK, 0.7, false,
				function () { FlxG.switchState(new PlayState(score)); });
			you_win = true;
		}

		score_text.text = 'score: ${score}';


		if (balls.countLiving() == 0) {
			FlxG.camera.fade(FlxColor.BLACK, 0.7, false,
				function () { FlxG.switchState(new PlayState(0)); });
			game_over = true;
		}

	}

	public function collide(obj: FlxObject, other: FlxObject) {
		var _player = Collision.detect(Collision.player_id, obj, other);
		var _ball = Collision.detect(Collision.ball_id, obj, other);
		var _wall = Collision.detect(Collision.wall_id, obj, other);
		var _block = Collision.detect(Collision.block_id, obj, other);
		var _unbreakable = Collision.detect(Collision.unbreakable_block_id, obj, other);
		var _power_up = Collision.detect(Collision.power_up_block_id, obj, other);
		
		if (_player != null && _ball != null) {
			_player.immovable = true;
			FlxObject.separate(_player, _ball);
			_player.immovable = false;

			var ball: Ball = cast _ball;
			var player: Player = cast _player;
			ball.collide(player);

			sound.play();

			FlxG.camera.shake(0.008, 0.05);
		}

		if (_wall != null && _ball != null) {
			FlxObject.separate(_ball, _wall);

			var ball: Ball = cast _ball;
			ball.collide();

			FlxG.camera.shake(0.008, 0.05);
		}

		if (_block != null && _ball != null) {
			FlxObject.separate(_ball, _block);

			var ball: Ball = cast _ball;
			ball.collide();

			_block.kill();
			score = score + 1;

			FlxG.camera.shake(0.008, 0.05);
		}

		if (_unbreakable != null && _ball != null) {
			FlxObject.separate(_ball, _unbreakable);

			var ball: Ball = cast _ball;
			ball.collide();

			FlxG.camera.shake(0.008, 0.05);
		}

		if (_power_up != null && _ball != null) {
			FlxObject.separate(_ball, _power_up);

			var power_up_manager = FlxG.plugins.get(PowerUpManager);

			var ball: Ball = cast _ball;
			ball.collide();

			var block: PowerUpBlock = cast _power_up;
			power_up_manager.power_up = block.type;
			power_up_manager.enable = true;
			power_up_manager.power_up_trigger = false;
			block.kill();


			FlxG.camera.shake(0.008, 0.05);
		}

		if (_player != null && _wall != null) {
			FlxObject.separateX(_player, _wall);
		}
	}
}
