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

class PowerUpBlock extends Block {
	public var effect: String;

	public function new(row: Int, column: Int) {
		var color = FlxColor.YELLOW;

		// TODO novo asset para o bloco
		super(Collision.power_up_block_id, row, column, AssetPaths.unbreakable__png, color);
		this.effect = "Small and fast";
	}
}
