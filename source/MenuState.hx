package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.util.FlxDirectionFlags;
import flixel.FlxG;
import Std.int;
import flixel.ui.FlxButton;
import flixel.text.FlxText;

class MenuState extends FlxState
{
	var playButton: FlxButton;
	var title: FlxText;

	override public function create() {
		super.create();

		title = new FlxText(0, 0, 0, "Breakout", 20);
		title.screenCenter();
		add(title);
		
		playButton = new FlxButton(title.x + int(title.width / 2), title.y + title.height + 10, "Play",
				function () { FlxG.switchState(new PlayState()); });
		playButton.x = playButton.x - int(playButton.width / 2);

		add(playButton);
	}
}
