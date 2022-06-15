package
{
	import flash.events.*;
	import flash.system.*;
	import flash.ui.Keyboard;
	
	import org.flixel.*;
	
	public class MenuState extends FlxState
	{
		[Embed(source="assets/fonts/Commodore Pixelized v1.2.ttf", fontName="COMMODORE", fontWeight="Regular", embedAsCFF="false")]
		private var COMMODORE_FONT:Class;
		
		[Embed(source="assets/16x16/title.png")]
		public static var TITLE_PNG:Class;
				
		
		private var _titleSprite:FlxSprite;
		private var _titleText:FlxText;
		
		private var _levelUI:MenuItem;
				
		public function MenuState()
		{
		}
		
		
		public override function create():void
		{
			FlxG.volume = 0.2;
			FlxG.mute = false;
			
			if (Globals.MEM_DEBUG)
			{
				trace("*** Top of create");
				traceMemory();
			}
			super.create();
			
			SaveState.load();
			Globals.levelNumber = SaveState.levelNumber;
			Globals.LEVEL_STATS = SaveState.levelStats;
			
			FlxG.bgColor = 0xFFFFFFFF;
			
			if (Assets._changeLevelSound == null)
			{
				Assets._changeLevelSound = new FlxSound();
				Assets._changeLevelSound.loadEmbedded(Assets.CHANGELEVEL_SOUND);
				trace("Created changeLevelSound");


			}
			if (Assets._levelSelectSound == null)
			{
				Assets._levelSelectSound = new FlxSound();
				Assets._levelSelectSound.loadEmbedded(Assets.SELECT_SOUND);
			}
			
			_titleText = new FlxText(0,0,FlxG.width,"YOU SAY JUMP\nI SAY HOW HIGH",true);
			_titleText.setFormat("COMMODORE",64,0xFF000000,"center");
			add(_titleText);
			
			addMenuItem(Globals.levelNumber);
			
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
		
			
			if (Globals.MEM_DEBUG)
			{
				trace("*** Bottom of create");
				traceMemory();
			}
		}
		

		
		private function addMenuItem(levelNumber:uint):void
		{
			_levelUI = new MenuItem();
			add(_levelUI);
		}
		
		public override function update():void
		{
			super.update();
		}
		
		
		private function onKeyDown(e:KeyboardEvent):void
		{			
			if (e.keyCode == Keyboard.RIGHT)
			{
				if (Globals.levelNumber + 1 < Globals.LEVEL_CLASSES.length)
				{
					if (Globals.LEVEL_STATS[Globals.levelNumber].through)
					{
						trace("Played changeLevelSound");
						Assets._changeLevelSound.play();
						Globals.levelNumber++;
						SaveState.levelNumber = Globals.levelNumber;
						remove(_levelUI);
						_levelUI.destroy();
						_levelUI = new MenuItem();
						add(_levelUI);
					}
				}
			}
			else if (e.keyCode == Keyboard.LEFT)
			{
				if (Globals.levelNumber - 1 >= 0)
				{				
					trace("Played changeLevelSound");
					Assets._changeLevelSound.play();
					Globals.levelNumber--;
					remove(_levelUI);
					_levelUI.destroy();
					_levelUI = new MenuItem();
					SaveState.levelNumber = Globals.levelNumber;
					add(_levelUI);
				}
			}
			else if (e.keyCode == Keyboard.ENTER)
			{
				Globals.levelName = Globals.LEVEL_CLASSES[Globals.levelNumber];
				Assets._levelSelectSound.play();
				FlxG.switchState(new PlayState);
			}			
		}
		
		
		private static function traceMemory():void {
			trace("MenuState: memory usage: " + (System.totalMemory / 1024 / 1024) + " MB");
		}

		
		
		public override function destroy():void
		{
			if (Globals.MEM_DEBUG)
			{
				trace("*** Top of destroy");
				traceMemory();
			}
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);

			super.destroy();
			
			if (Globals.MEM_DEBUG)
			{
				trace("*** Bottom of destroy");
				traceMemory();
			}
		}
	}
}