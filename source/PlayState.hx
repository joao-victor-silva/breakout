package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.util.FlxDirectionFlags;
import flixel.FlxG;
import Std.int;

class PlayState extends FlxState
{
	var player: FlxSprite;
	var walls: FlxGroup;
	var ball: FlxSprite;
	var acceleration: Int;
	final player_id: Int = 1000;
	final ball_id: Int = 2000;
	final wall_id: Int = 2001;

	override public function create()
	{
		super.create();

		acceleration = int(FlxG.width / 3);

		player = new FlxSprite();
		player.makeGraphic(50, 10, FlxColor.WHITE);
		player.y = 8 * (FlxG.height / 10);
		player.x = int((FlxG.width - player.width) / 2);

		player.maxVelocity.x = int(FlxG.width / 2.5);
		player.drag.x = 2000;
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
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.pressed.LEFT) {
			player.acceleration.x = -acceleration;
		} else if (FlxG.keys.pressed.RIGHT) {
			player.acceleration.x = acceleration;
		} else {
			player.acceleration.x = 0;
		}

		FlxG.overlap(this, null, ballCollide);

	}

	public function ballCollide(obj: FlxObject, other: FlxObject) {
		var _player = detect(player_id, obj, other);
		var _ball = detect(ball_id, obj, other);
		var _wall = detect(wall_id, obj, other);
		
		if (_player != null && _ball != null) {
			FlxObject.separateY(_player, _ball);
			_ball.velocity.y = -100;
			player.y = 8 * (FlxG.height / 10);
			player.velocity.y = 0;
		}

		if (_wall != null && _ball != null) {
			FlxObject.separate(_ball, _wall);
			FlxG.log.notice(_ball.touching);

			var left = _ball.isTouching(FlxDirectionFlags.LEFT);
			var right = _ball.isTouching(FlxDirectionFlags.RIGHT);
			var up = _ball.isTouching(FlxDirectionFlags.UP);
			var down = _ball.isTouching(FlxDirectionFlags.DOWN);

			if (left && !right) {
				_ball.velocity.x = 100;
			}
			if (right && !left) {
				_ball.velocity.x = -100;
			}
			if (up && !down) {
				_ball.velocity.y = 100;
			}
			if (down && !up) {
				_ball.velocity.y = -100;
			}
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
}
