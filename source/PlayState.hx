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

class PlayState extends FlxState
{
	var player: FlxSprite;
	var walls: FlxGroup;
	var blocks: FlxGroup;
	var unbreakble_blocks: FlxGroup;
	var ball: FlxSprite;
	var acceleration: Int;
	final player_id: Int = 1000;
	final ball_id: Int = 2000;
	final wall_id: Int = 2001;
	final block_id: Int = 2002;
	final unbreakable_block_id: Int = 2003;

	var gameover: Bool;
	var youwin: Bool;

	override public function create()
	{
		super.create();

		acceleration = int(FlxG.width * 2);

		player = new FlxSprite();
		player.makeGraphic(50, 10, FlxColor.WHITE);
		player.y = 8 * (FlxG.height / 10);
		player.x = int((FlxG.width - player.width) / 2);

		player.maxVelocity.x = int(FlxG.width / 2.5);
		player.drag.x = FlxG.width * 5;
		player.ID = player_id;

		add(player);

		walls = new FlxGroup();
		
		var wallUp = new FlxSprite();
		wallUp.makeGraphic(FlxG.width, 10, FlxColor.GRAY);
		wallUp.immovable = true;
		wallUp.ID = wall_id;
		walls.add(wallUp);

		var wallLeft = new FlxSprite();
		wallLeft.makeGraphic(10, FlxG.height, FlxColor.GRAY);
		wallLeft.immovable = true;
		wallLeft.ID = wall_id;
		walls.add(wallLeft);

		var wallRight = new FlxSprite();
		wallRight.makeGraphic(10, FlxG.height, FlxColor.GRAY);
		wallRight.x = FlxG.width - 10;
		wallRight.immovable = true;
		wallRight.ID = wall_id;
		walls.add(wallRight);

		add(walls);

		ball = new FlxSprite();
		ball.makeGraphic(10, 10, FlxColor.RED);
		ball.y = int((FlxG.height - ball.height) / 2);
		ball.x = int((FlxG.width - ball.width) / 2);
		ball.ID = ball_id;

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
						block.ID = block_id;
						block.x = wallLeft.width + (j * block.width);
						block.y = wallUp.height + (i * block.height);
						blocks.add(block);
					} else {
						block.loadGraphic(AssetPaths.unbreakable__png, false);
						block.color = FlxColor.GRAY;
						block.immovable = true;
						block.ID = unbreakable_block_id;
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

		if (FlxG.keys.pressed.LEFT) {
			player.acceleration.x = -acceleration;
		} else if (FlxG.keys.pressed.RIGHT) {
			player.acceleration.x = acceleration;
		} else {
			player.acceleration.x = 0;
		}

		FlxG.overlap(this, null, ballCollide);

		if (blocks.countLiving() == 0) {
			FlxG.camera.fade(FlxColor.BLACK, 0.7, false);
			youwin = true;
		}

		if (ball.y > FlxG.height) {
			FlxG.camera.fade(FlxColor.BLACK, 0.7, false,
				function () { FlxG.switchState(new PlayState()); });
			gameover = true;
		}

	}

	public function ballCollide(obj: FlxObject, other: FlxObject) {
		var _player = detect(player_id, obj, other);
		var _ball = detect(ball_id, obj, other);
		var _wall = detect(wall_id, obj, other);
		var _block = detect(block_id, obj, other);
		var _unbreakble = detect(unbreakable_block_id, obj, other);
		
		if (_player != null && _ball != null) {
			player.immovable = true;
			FlxObject.separate(_player, _ball);
			player.immovable = false;

			handleBallCollision(_ball);
		}

		if (_wall != null && _ball != null) {
			FlxObject.separate(_ball, _wall);

			handleBallCollision(_ball);
		}

		if (_block != null && _ball != null) {
			FlxObject.separate(_ball, _block);

			handleBallCollision(_ball);

			_block.kill();
		}

		if (_unbreakble != null && _ball != null) {
			FlxObject.separate(_ball, _unbreakble);

			handleBallCollision(_ball);
		}

		if (_player != null && _wall != null) {
			FlxObject.separateX(_player, _wall);
		}
	}

	public function detect(id: Int, obj1: FlxObject, obj2: FlxObject) : FlxObject {
		if (obj1.ID == id) {
			return obj1;
		}

		if (obj2.ID == id) {
			return obj2;
		}

		return null;
	}

	public function handleBallCollision(_ball: FlxObject) {
		var left = _ball.isTouching(FlxDirectionFlags.LEFT);
		var right = _ball.isTouching(FlxDirectionFlags.RIGHT);
		var up = _ball.isTouching(FlxDirectionFlags.UP);
		var down = _ball.isTouching(FlxDirectionFlags.DOWN);

		if (left) {
			_ball.velocity.x = 100;
		}
		if (right) {
			_ball.velocity.x = -100;
		}
		if (up) {
			_ball.velocity.y = 100;
		}
		if (down) {
			_ball.velocity.y = -100;
		}
	}
}
