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
import flixel.system.FlxAssets.FlxGraphicAsset;

class Breakable extends Block {
	public function new(row: Int, column: Int) {
		var color = FlxG.random.color(FlxColor.fromRGBFloat(0.1, 0.1, 0.1, 1));

		super(Collision.block_id, row, column, AssetPaths.block__png, color);
	}
}
