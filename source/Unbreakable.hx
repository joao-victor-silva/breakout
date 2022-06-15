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

class Unbreakable extends Block {
	public function new(row: Int, column: Int) {
		var color = FlxColor.GRAY;

		super(Collision.unbreakable_block_id, row, column, AssetPaths.unbreakable__png, color);
	}
}
