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

class Ball extends FlxSprite
{
	var ACCELERATION: Int;

	public function new() {
		super();

		this.makeGraphic(10, 10, FlxColor.RED);
		this.y = int((FlxG.height - this.height) / 2);
		this.x = int((FlxG.width - this.width) / 2);
		this.ID = Collision.ball_id;

		this.velocity.x = -100;
		this.velocity.y = -100;
	}
	
	public function collide() {
		var left = this.isTouching(FlxDirectionFlags.LEFT);
		var right = this.isTouching(FlxDirectionFlags.RIGHT);
		var up = this.isTouching(FlxDirectionFlags.UP);
		var down = this.isTouching(FlxDirectionFlags.DOWN);

		if (left) {
			this.velocity.x = 100;
		}
		if (right) {
			this.velocity.x = -100;
		}
		if (up) {
			this.velocity.y = 100;
		}
		if (down) {
			this.velocity.y = -100;
		}
	}
	
	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (this.y > FlxG.height) {
			this.kill();
		}
	}
}
