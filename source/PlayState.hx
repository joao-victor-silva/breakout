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

typedef BlockGroup = {
	var block: Class<Block>;
	var group: FlxGroup;
};

class PlayState extends FlxState
{
	var walls: FlxGroup;
	var balls: FlxGroup;
	var blocks: FlxGroup;
	var unbreakble_blocks: FlxGroup;

	var score_text: FlxText;
	var score: Int;

	var gameover: Bool;
	var youwin: Bool;

	var _block_type: Map<String, BlockGroup>;

	public function new(score: Int) {
		super();
		this.score = score;
	}

	override public function create()
	{
		super.create();


		var player = new Player();
		add(player);

		walls = new FlxGroup();

		addWall(0, 0, 10, FlxG.width); // UP
		addWall(0, 0, FlxG.height, 10); // LEFT
		addWall(FlxG.width - 10, 0, FlxG.height, 10); // RIGHT

		add(walls);

		balls = new FlxGroup();
		var ball = new Ball();
		balls.add(ball);
		add(balls);
		
		var rows = Assets.getText(AssetPaths.map1__txt).split("\n");

		blocks = new FlxGroup();
		unbreakble_blocks = new FlxGroup();

		_block_type = [
			"o" => {
				block: Breakable,
				group: blocks,
			},
			"x" => {
				block: Unbreakable,
				group: unbreakble_blocks,
			},
		];

		var i: Int = 0;
		for (row in rows) {
			var j: Int = 0;
			for (type in row.split("")) {
				if (type != ".") {
					var block_type = _block_type[type].block;
					var block = Type.createInstance(block_type, [i, j]);
					var group = _block_type[type].group;
					group.add(block);
				}
				j = j + 1;
			}
			i = i + 1;
		}
		add(blocks);
		add(unbreakble_blocks);

		gameover = false;
		youwin = false;

		score_text = new FlxText(0, 0, 0, 'score: ${score}', 6);
		score_text.screenCenter();
		score_text.y = 0;
		add(score_text);
	}

	override public function update(elapsed:Float)
	{
		if (youwin) {
			return;
		}

		if (gameover) {
			return;
		}

		super.update(elapsed);

		FlxG.overlap(this, null, collide);

		if (blocks.countLiving() == 0) {
			FlxG.camera.fade(FlxColor.BLACK, 0.7, false,
				function () { FlxG.switchState(new PlayState(score)); });
			youwin = true;
		}

		score_text.text = 'score: ${score}';


		if (balls.countLiving() == 0) {
			FlxG.camera.fade(FlxColor.BLACK, 0.7, false,
				function () { FlxG.switchState(new PlayState(0)); });
			gameover = true;
		}

	}

	public function collide(obj: FlxObject, other: FlxObject) {
		var _player = Collision.detect(Collision.player_id, obj, other);
		var _ball = Collision.detect(Collision.ball_id, obj, other);
		var _wall = Collision.detect(Collision.wall_id, obj, other);
		var _block = Collision.detect(Collision.block_id, obj, other);
		var _unbreakble = Collision.detect(Collision.unbreakable_block_id, obj, other);
		
		if (_player != null && _ball != null) {
			_player.immovable = true;
			FlxObject.separate(_player, _ball);
			_player.immovable = false;

			var ball: Ball = cast _ball;
			ball.collide();
		}

		if (_wall != null && _ball != null) {
			FlxObject.separate(_ball, _wall);

			var ball: Ball = cast _ball;
			ball.collide();
		}

		if (_block != null && _ball != null) {
			FlxObject.separate(_ball, _block);

			var ball: Ball = cast _ball;
			ball.collide();

			_block.kill();
			score = score + 1;
		}

		if (_unbreakble != null && _ball != null) {
			FlxObject.separate(_ball, _unbreakble);

			var ball: Ball = cast _ball;
			ball.collide();
		}

		if (_player != null && _wall != null) {
			FlxObject.separateX(_player, _wall);
		}
	}
	

	public function addWall(x: Int, y: Int, height: Int, width: Int) {
		var wall = new FlxSprite(x, y);
		wall.makeGraphic(width, height, FlxColor.GRAY);
		wall.immovable = true;
		wall.ID = Collision.wall_id;
		walls.add(wall);
	}

}
