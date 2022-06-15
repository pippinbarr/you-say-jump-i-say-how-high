package
{
	
	import org.flixel.*;
	
	public class MenuItem extends FlxGroup
	{
		[Embed(source="assets/fonts/Commodore Pixelized v1.2.ttf", fontName="COMMODORE", fontWeight="Regular", embedAsCFF="false")]
		private var COMMODORE_FONT:Class;
		
		
		private var _thumb:FlxSprite;
		private var _levelTitle:FlxText;
		private var _text:FlxText;
		
		public function MenuItem()
		{
			super();
			
			_text = new FlxText(0,430,FlxG.width,"", true);
			_text.setFormat("COMMODORE",16,0xFF000000,"center");
			
			if (Globals.LEVEL_STATS[Globals.levelNumber].through)
			{
				_thumb = new FlxSprite(0,0,Assets.LEVEL_THUMBS[Globals.levelNumber]);
				_thumb.x = (FlxG.width - _thumb.width)/2;
				_thumb.y = (FlxG.height - _thumb.height)/2 - 30;
				add(_thumb);
				
				_levelTitle = new FlxText(0,_thumb.y + _thumb.height + 10,FlxG.width, Globals.LEVEL_NAMES[Globals.levelNumber], true);
				_levelTitle.setFormat("COMMODORE",32,0xFF000000,"center");
				add(_levelTitle);
				
				_text.text += "\n";
				_text.text += "COINS: " + Globals.LEVEL_STATS[Globals.levelNumber].coins + "\n";
				_text.text += "STAR: " + Globals.LEVEL_STATS[Globals.levelNumber].star + "\n";
				_text.text += "ALL: " + Globals.LEVEL_STATS[Globals.levelNumber].all + "\n\n";
			}
			else
			{
				_thumb = new FlxSprite(0,0,Assets.UNKNOWN_THUMB);
				_thumb.x = (FlxG.width - _thumb.width)/2;
				_thumb.y = (FlxG.height - _thumb.height)/2 - 30;
				add(_thumb);
				
				_levelTitle = new FlxText(0,_thumb.y + _thumb.height + 10,FlxG.width, "LEVEL ???", true);
				_levelTitle.setFormat("COMMODORE",32,0xFF000000,"center");
				add(_levelTitle);
			}
			_text.text += "\n";
			_text.text += "[ PRESS ENTER TO ATTEMPT THIS LEVEL ]" +
				"\n\n [ LEFT AND RIGHT KEYS TO NAVIGATE BETWEEN LEVELS ]";
			
			add(_text);
		}
		
		public override function update():void
		{
			super.update();
		}
		
		public override function destroy():void
		{
			super.destroy();
		}
	}
}