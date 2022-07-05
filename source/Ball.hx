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

class Ball extends FlxSprite
{
	var ACCELERATION: Int;
	var particle_emitter: FlxEmitter;

	public function new() {
		super();

		this.makeGraphic(10, 10, FlxColor.RED);
		this.y = int((FlxG.height - this.height) / 2);
		this.x = int((FlxG.width - this.width) / 2);
		this.ID = Collision.ball_id;

		this.velocity.x = -100;
		this.velocity.y = -100;

		this.particle_emitter = new FlxEmitter();
		this.particle_emitter.makeParticles(2, 2, FlxColor.GRAY, 120);
		this.particle_emitter.lifespan.set(0.5);
		this.particle_emitter.alpha.set(1, 1, 0, 0);
	}

	override public function draw() {
		super.draw();
		this.particle_emitter.draw();
	}
	
	public function collide(?player: Player) {
		var left = this.isTouching(FlxDirectionFlags.LEFT);
		var right = this.isTouching(FlxDirectionFlags.RIGHT);
		var up = this.isTouching(FlxDirectionFlags.UP);
		var down = this.isTouching(FlxDirectionFlags.DOWN);


		if (left) {
			this.velocity.x = 100;
			this.particle_emitter.setPosition(this.x, int(this.y + (this.height / 2)));
			this.particle_emitter.launchAngle.set(-45, 45);
		}
		if (right) {
			this.velocity.x = -100;
			this.particle_emitter.setPosition(this.x + this.width, int(this.y + (this.height / 2)));
			this.particle_emitter.launchAngle.set(135, 225);
		}
		if (up) {
			this.velocity.y = 100;
			this.particle_emitter.setPosition(this.x, int(this.y + (this.height / 2)));
			this.particle_emitter.launchAngle.set(45, 135);
		}
		if (down) {
			if (player != null) {
				var player_section = int(player.width / 4);
				var ball_middle = this.x + int(this.width / 2);
				// Always left
				if (ball_middle < (player_section + player.x)) {
					this.velocity.x = -100;
				// Always right
				} else if (ball_middle > (player.x + (3 * player_section))) {
					this.velocity.x = 100;
				}
			}
			this.velocity.y = -100;
			this.particle_emitter.setPosition(this.x, int(this.y + (this.height / 2)));
			this.particle_emitter.launchAngle.set(225, -45);
		}
		this.particle_emitter.start(true, 0, 30);

	}
	
	override public function update(elapsed:Float) {
		super.update(elapsed);
		this.particle_emitter.update(elapsed);

		if (this.y > FlxG.height) {
			this.kill();
		}
	}
}
