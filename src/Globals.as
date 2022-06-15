package
{
	
	import flash.display.Sprite;
	import flash.ui.Keyboard;
	
	public class Globals
	{
		
		// DEBUG
		public static const MEM_DEBUG:Boolean = false;
		
		public static var CLICK_TO_PLAY:Boolean = true;
		
		// GAME TRACKING
		public static var coinsCollected:uint = 0;
		public static var waterLevel:int = -1;
		public static var levelName:String = "LevelOneLevel";
		public static var levelNumber:int = 0;
		
		// GAME SETUP CONSTANTS
		public static const ZOOM:uint = 1;
		public static const COLLIDE_INDEX:uint = 9;
		
		
		// DEFAULT PHYSICS PARAMETERS
		public static const DEFAULT_GRAVITY:Number = 500;
		public static const DEFAULT_SCALE:Number = 1;
		public static const DEFAULT_MASS:Number = 100;
		public static const DEFAULT_GROUND_SPEED:Number = 500;
		public static const DEFAULT_AIR_SPEED:Number = 500;
		public static const DEFAULT_SWIM_SPEED:Number = 500;
		public static const DEFAULT_JUMP_SPEED:Number = 250;
		
		// GAME PHYSICS PARAMETERS

		public static const WIDTH:Number = 10;
		public static const HEIGHT:Number = 10;
		
		public static var GRAVITY:Number = DEFAULT_GRAVITY;
		
		public static var SCALE:Number = DEFAULT_SCALE;
		public static var SCALED_AREA:Number = (WIDTH * SCALE) * (HEIGHT * SCALE);
		public static var MASS:Number = DEFAULT_MASS;

		public static var DENSITY:Number = MASS / SCALED_AREA;
		
		public static var GROUND_SPEED:Number = DEFAULT_GROUND_SPEED;
		public static var AIR_SPEED:Number = DEFAULT_AIR_SPEED;
		public static var JUMP_SPEED:Number = DEFAULT_SWIM_SPEED;
		public static var SWIM_SPEED:Number = DEFAULT_JUMP_SPEED;

		public static var AIR_CONTROL_FRICTION:Number = AIR_SPEED * 1000;
		public static var GROUND_FRICTION:Number = GROUND_SPEED * 1000;
		public static var WATER_DRAG:Number = SWIM_SPEED * 1000;
		
		public static var WATER_DENSITY:Number = 1.0;
				
		public static const TILE_BREAK_THRESHOLD:uint = 1000;
		public static const GLASS_TILE_BREAK_THRESHOLD:uint = 10;

				
		// TRACKING VARIABLES
		public static var inAir:Boolean = true;
		public static var inWater:Boolean = false;

		// OBJECT VARIABLES
		public static const COIN_OBJECT:uint = 1;
		public static const STAR_OBJECT:uint = 2;
		public static const LEFT_RIGHT_MOVER_OBJECT:uint = 3;
		public static const UP_DOWN_MOVER_OBJECT:uint = 4;
		public static const PLAYER_OBJECT:uint = 5;
		public static const ANTIGRAV_COIN_OBJECT:uint = 6;
		public static const COIN_DENSITY:Number = 1;
		
		// TILE VARIABLES
		public static const TILE_SIZE:uint = 16;
		public static const WATER_TILE:uint = 8;
		public static const SOLID_TILE:uint = 9;
		public static const GLASS_TILE:uint = 10;
		public static const UP_SPIKE_TILE:uint = 11;		
		public static const DOWN_SPIKE_TILE:uint = 12;
		public static const LEFT_SPIKE_TILE:uint = 13;
		public static const RIGHT_SPIKE_TILE:uint = 14;

		// MENU VARIABLES
		public static var LEVEL_NAMES:Array = new Array(
			"THE USUAL", "THE ROAD NOT TAKEN", "UMOPEPISDN", "EASY DOES IT", "FLIPPER",
			"CHUNNEL", "NO WAY OUT",  "SPEED SAVES", "TERROR TUNNEL", "LUCKY DIP", "TREAD SOFTLY",
			"ONE SHOT ONE KILL", "UNLUCKY DIP", "LIFE IN SLOW MOTION", "ANTIGRAV");
		public static var LEVEL_CLASSES:Array = new Array(
			"levels.LevelOneLevel", "levels.TheRoadNotTakenLevel",
			"levels.UmopepisdnLevel", "levels.EasyDoesItLevel", "levels.FlipperLevel", 
			"levels.ChunnelLevel", "levels.NoWayOutLevel", "levels.SpeedSavesLevel", "levels.TerrorTunnelLevel",
			"levels.LuckyDipLevel", "levels.TreadSoftlyLevel", "levels.OneShotOneKillLevel",
			"levels.UnluckyDipLevel", "levels.SlowMotionLevel",
			"levels.AntiGravLevel");
		public static var LEVEL_STATS:Array = new Array(
			new LevelStats(), new LevelStats(), new LevelStats(), new LevelStats(), new LevelStats(),
			new LevelStats(), new LevelStats(), new LevelStats(), new LevelStats(), new LevelStats(),
			new LevelStats(), new LevelStats(), new LevelStats(), new LevelStats(), new LevelStats());			
		
		public function Globals()
		{
		}
	}
}