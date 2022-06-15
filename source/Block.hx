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

class Block extends FlxSprite {
	final BLOCK_INI_X = 10;
	final BLOCK_INI_Y = 10;

	public function new(id: Int, row: Int, column: Int, asset: FlxGraphicAsset, color: FlxColor) {
		super();

		this.ID = id;
		this.loadGraphic(asset, false);
		this.color = color;

		this.x = BLOCK_INI_X + (column * this.width);
		this.y = BLOCK_INI_Y + (row * this.height);
		this.immovable = true;
	}
}

