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

class Player extends FlxSprite
{
	var ACCELERATION: Int;

	public function new() {
		super();

		this.makeGraphic(50, 10, FlxColor.WHITE);
		this.y = 8 * (FlxG.height / 10);
		this.x = int((FlxG.width - this.width) / 2);

		this.maxVelocity.x = int(FlxG.width / 2.5);
		this.drag.x = FlxG.width * 5;
		this.ID = Collision.player_id;

		ACCELERATION = int(FlxG.width * 2);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.pressed.LEFT) {
			this.acceleration.x = -ACCELERATION;
		} else if (FlxG.keys.pressed.RIGHT) {
			this.acceleration.x = ACCELERATION;
		} else {
			this.acceleration.x = 0;
		}
	}

	public function setPowerUp(type: PowerUpType) {
	}

}
