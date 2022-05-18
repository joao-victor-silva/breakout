package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import Std.int;

class PlayState extends FlxState
{
	var player: FlxSprite;
	var acceleration: Int;

	override public function create()
	{
		super.create();

		acceleration = int(FlxG.width / 3);

		player = new FlxSprite();
		player.makeGraphic(50, 10, FlxColor.WHITE);
		player.y = 8 * (FlxG.height / 10);

		player.maxVelocity.x = int(FlxG.width / 2.5);
		player.drag.x = 2000;

		add(player);
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

		// Screen boundaries
		if (player.x < 0) {
			player.x = 0;
		}
		if (player.x + player.width > FlxG.width) {
			player.x = FlxG.width - player.width;
		}
	}
}
