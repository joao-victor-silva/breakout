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

class Wall extends FlxSprite {
	public function new(x: Int, y: Int, height: Int, width: Int) {
		super(x, y);
		this.makeGraphic(width, height, FlxColor.GRAY);
		this.immovable = true;
		this.ID = Collision.wall_id;
	}
}
