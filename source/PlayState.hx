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

class PlayState extends FlxState
{
	var walls: FlxGroup;
	var blocks: FlxGroup;
	var unbreakble_blocks: FlxGroup;
	var ball: FlxSprite;

	var score_text: FlxText;
	var score: Int;

	var gameover: Bool;
	var youwin: Bool;

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
		
		var wallUp = new FlxSprite();
		wallUp.makeGraphic(FlxG.width, 10, FlxColor.GRAY);
		wallUp.immovable = true;
		wallUp.ID = Collision.wall_id;
		walls.add(wallUp);

		var wallLeft = new FlxSprite();
		wallLeft.makeGraphic(10, FlxG.height, FlxColor.GRAY);
		wallLeft.immovable = true;
		wallLeft.ID = Collision.wall_id;
		walls.add(wallLeft);

		var wallRight = new FlxSprite();
		wallRight.makeGraphic(10, FlxG.height, FlxColor.GRAY);
		wallRight.x = FlxG.width - 10;
		wallRight.immovable = true;
		wallRight.ID = Collision.wall_id;
		walls.add(wallRight);

		add(walls);

		ball = new FlxSprite();
		ball.makeGraphic(10, 10, FlxColor.RED);
		ball.y = int((FlxG.height - ball.height) / 2);
		ball.x = int((FlxG.width - ball.width) / 2);
		ball.ID = Collision.ball_id;

		ball.velocity.x = -100;
		ball.velocity.y = -100;

		add(ball);
		
		var rows = Assets.getText(AssetPaths.map1__txt).split("\n");

		blocks = new FlxGroup();
		unbreakble_blocks = new FlxGroup();
		var i: Int = 0;
		for (row in rows) {
			var j: Int = 0;
			for (block_type in row.split("")) {
				if (block_type != ".") {
					var block = new FlxSprite();
					if (block_type == "o") {
						block.loadGraphic(AssetPaths.block__png, false);
						block.color = FlxG.random.color(FlxColor.fromRGBFloat(0.1, 0.1, 0.1, 1));
						block.ID = Collision.block_id;
						block.x = wallLeft.width + (j * block.width);
						block.y = wallUp.height + (i * block.height);
						blocks.add(block);
					} else {
						block.loadGraphic(AssetPaths.unbreakable__png, false);
						block.color = FlxColor.GRAY;
						block.immovable = true;
						block.ID = Collision.unbreakable_block_id;
						block.x = wallLeft.width + (j * block.width);
						block.y = wallUp.height + (i * block.height);
						unbreakble_blocks.add(block);
					}
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



		FlxG.overlap(this, null, ballCollide);

		if (blocks.countLiving() == 0) {
			FlxG.camera.fade(FlxColor.BLACK, 0.7, false,
				function () { FlxG.switchState(new PlayState(score)); });
			youwin = true;
		}

		score_text.text = 'score: ${score}';

		if (ball.y > FlxG.height) {
			FlxG.camera.fade(FlxColor.BLACK, 0.7, false,
				function () { FlxG.switchState(new PlayState(0)); });
			gameover = true;
		}

	}

	public function ballCollide(obj: FlxObject, other: FlxObject) {
		var _player = Collision.detect(Collision.player_id, obj, other);
		var _ball = Collision.detect(Collision.ball_id, obj, other);
		var _wall = Collision.detect(Collision.wall_id, obj, other);
		var _block = Collision.detect(Collision.block_id, obj, other);
		var _unbreakble = Collision.detect(Collision.unbreakable_block_id, obj, other);
		
		if (_player != null && _ball != null) {
			_player.immovable = true;
			FlxObject.separate(_player, _ball);
			_player.immovable = false;

			Collision.handleBallCollision(_ball);
		}

		if (_wall != null && _ball != null) {
			FlxObject.separate(_ball, _wall);

			Collision.handleBallCollision(_ball);
		}

		if (_block != null && _ball != null) {
			FlxObject.separate(_ball, _block);

			Collision.handleBallCollision(_ball);

			_block.kill();
			score = score + 1;
		}

		if (_unbreakble != null && _ball != null) {
			FlxObject.separate(_ball, _unbreakble);

			Collision.handleBallCollision(_ball);
		}

		if (_player != null && _wall != null) {
			FlxObject.separateX(_player, _wall);
		}
	}

}
