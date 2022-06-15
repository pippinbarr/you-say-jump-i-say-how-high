package
{
	
	import org.flixel.*;
	
	public class SaveState
	{
		
		private static var _save:FlxSave;
		private static var _loaded:Boolean = false;
		
		private static var tempLevelNumber:uint = 0;
		private static var tempLevelStats:Array = new Array(new LevelStats(), new LevelStats(), new LevelStats(), new LevelStats(), new LevelStats(),
			new LevelStats(), new LevelStats(), new LevelStats(), new LevelStats(), new LevelStats(),
			new LevelStats(), new LevelStats(), new LevelStats(), new LevelStats(), new LevelStats());
		
		
		public function SaveState()
		{
		}
		
		public static function load():void {
			
			_save = new FlxSave();
			_loaded = _save.bind("YouSayJumpSaveData");
						
			if (_loaded && _save.data.levelNumber == null) _save.data.levelNumber = 0;
			if (_loaded && _save.data.levelStats == null) _save.data.levelStats = new Array(new LevelStats(), new LevelStats(), new LevelStats(), new LevelStats(), new LevelStats(),
				new LevelStats(), new LevelStats(), new LevelStats(), new LevelStats(), new LevelStats(),
				new LevelStats(), new LevelStats(), new LevelStats(), new LevelStats(), new LevelStats());
						
		}
		
		public static function flush():void {
			if (_loaded) _save.flush();
		}
		
		public static function erase():void {
			if (_loaded) _save.erase();
		}
		
		public static function set levelNumber(value:uint):void {
			if (_loaded)
			{
				_save.data.levelNumber = value;
			}
			else
			{
				tempLevelNumber = value;
			}
		}
		
		public static function get levelNumber():uint {
			if (_loaded)
			{
				return _save.data.levelNumber;
			}
			else
			{
				return tempLevelNumber;
			}
		}
		
		public static function set levelStats(value:Array):void {
			if (_loaded)
			{
				_save.data.levelStats = value;
			}
			else
			{
				tempLevelStats = value;
			}
		}
		
		public static function get levelStats():Array {
			if (_loaded)
			{
				return _save.data.levelStats;
			}
			else
			{
				return tempLevelStats;
			}
		}
	}
}