package
{
	import org.flixel.FlxSound;

	public class Assets
	{
		
		[Embed(source="assets/16x16/thumbs/theUsual.png")]
		public static const THEUSUAL_THUMB:Class;
		
		[Embed(source="assets/16x16/thumbs/chunnel.png")]
		public static const CHUNNEL_THUMB:Class;

		[Embed(source="assets/16x16/thumbs/antiGrav.png")]
		public static const ANTIGRAV_THUMB:Class;

		[Embed(source="assets/16x16/thumbs/easyDoesIt.png")]
		public static const EASYDOESIT_THUMB:Class;

		[Embed(source="assets/16x16/thumbs/flipper.png")]
		public static const FLIPPER_THUMB:Class;

		[Embed(source="assets/16x16/thumbs/lifeInSlowMotion.png")]
		public static const LIFEINSLOWMOTION_THUMB:Class;

		[Embed(source="assets/16x16/thumbs/luckyDip.png")]
		public static const LUCKYDIP_THUMB:Class;

		[Embed(source="assets/16x16/thumbs/noWayOut.png")]
		public static const NOWAYOUT_THUMB:Class;

		[Embed(source="assets/16x16/thumbs/oneShotOneKill.png")]
		public static const ONESHOTONEKILL_THUMB:Class;

		[Embed(source="assets/16x16/thumbs/speedSaves.png")]
		public static const SPEEDSAVES_THUMB:Class;

		[Embed(source="assets/16x16/thumbs/terrorTunnel.png")]
		public static const TERRORTUNNEL_THUMB:Class;

		[Embed(source="assets/16x16/thumbs/theRoadNotTaken.png")]
		public static const THEROADNOTTAKEN_THUMB:Class;

		[Embed(source="assets/16x16/thumbs/treadSoftly.png")]
		public static const TREADSOFTLY_THUMB:Class;

		[Embed(source="assets/16x16/thumbs/umopepisdn.png")]
		public static const UMOPEPISDN_THUMB:Class;

		[Embed(source="assets/16x16/thumbs/unluckyDip.png")]
		public static const UNLUCKYDIP_THUMB:Class;
		
		[Embed(source="assets/16x16/thumbs/unknown.png")]
		public static const UNKNOWN_THUMB:Class;

		public static const LEVEL_THUMBS:Array = new Array(
			THEUSUAL_THUMB, THEROADNOTTAKEN_THUMB, UMOPEPISDN_THUMB, EASYDOESIT_THUMB,
			FLIPPER_THUMB, CHUNNEL_THUMB, NOWAYOUT_THUMB, SPEEDSAVES_THUMB, Assets.TERRORTUNNEL_THUMB,
			Assets.LUCKYDIP_THUMB, Assets.TREADSOFTLY_THUMB, Assets.ONESHOTONEKILL_THUMB,
			Assets.UNLUCKYDIP_THUMB, Assets.LIFEINSLOWMOTION_THUMB, Assets.ANTIGRAV_THUMB);
		
		
		[Embed(source="assets/sounds/changelevel.mp3")]
		public static var CHANGELEVEL_SOUND:Class;
		
		[Embed(source="assets/sounds/coin.mp3")]
		public static var COIN_SOUND:Class;		

		[Embed(source="assets/sounds/explode.mp3")]
		public static var EXPLODE_SOUND:Class;
		
		[Embed(source="assets/sounds/hurt.mp3")]
		public static var HURT_SOUND:Class;
		
		[Embed(source="assets/sounds/jump.mp3")]
		public static var JUMP_SOUND:Class;
		
		[Embed(source="assets/sounds/levelwin.mp3")]
		public static var LEVELWIN_SOUND:Class;
		
		[Embed(source="assets/sounds/select.mp3")]
		public static var SELECT_SOUND:Class;
		
		[Embed(source="assets/sounds/star.mp3")]
		public static var STAR_SOUND:Class;
		
		[Embed(source="assets/sounds/tilebreak.mp3")]
		public static var TILEBREAK_SOUND:Class;
		
		[Embed(source="assets/sounds/water.mp3")]
		public static var WATER_SOUND:Class;
		
		public static var _changeLevelSound:FlxSound = null;
		public static var _levelSelectSound:FlxSound = null;
		
		public static var _coinSound:FlxSound = null;
		public static var _explodeSound:FlxSound = null;
		public static var _hurtSound:FlxSound = null;
		public static var _jumpSound:FlxSound = null;
		public static var _levelWinSound:FlxSound = null;
		public static var _starSound:FlxSound = null;
		public static var _tileBreakSound:FlxSound = null;
		public static var _waterSound:FlxSound = null;
		
		public function Assets()
		{
		}
	}
}