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
import flixel.effects.particles.FlxEmitter;
import flixel.FlxBasic;

class PowerUpManager extends FlxBasic
{
	// public function new() {
	// }

	public var power_up: PowerUpType;
	public var power_up_trigger: Bool = false;
	public var enable: Bool = false;
	var playerDeltaX: Float;

	// override function update(elapsed: Float) {
	// }

	public function setPowerUpPlayer(player: Player) {
		if (this.enable) {
			switch (power_up) {
				case SmallAndFast:
					player.scale.set(0.5, 1);
					player.updateHitbox();
					player.maxVelocity.x = FlxG.width;
				default:
					this.playerDeltaX = player.x - player.last.x;
					return;
			}
		}
	}
	
	public function setPowerUpBall(ball: Ball) {
		if (this.enable) {
			switch (power_up) {
				case Magnetic:
					if (this.power_up_trigger) {
						ball.velocity.x = 0;
						ball.velocity.y = 0;
						ball.x = ball.x + this.playerDeltaX;
					}
				default:
					return;
			}
		}
	}

}
