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

class Collision {
	public static final player_id: Int = 1000;
	public static final ball_id: Int = 2000;
	public static final wall_id: Int = 2001;
	public static final block_id: Int = 2002;
	public static final unbreakable_block_id: Int = 2003;

	static public function detect(id: Int, obj1: FlxObject, obj2: FlxObject) : FlxObject {
		if (obj1.ID == id) {
			return obj1;
		}

		if (obj2.ID == id) {
			return obj2;
		}

		return null;
	}

	static public function handleBallCollision(_ball: FlxObject) {
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
