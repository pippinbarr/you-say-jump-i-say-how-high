package
{
	
	import org.flixel.*;
	
	import flash.display.Sprite;
	
	[SWF(width = "800", height = "640", backgroundColor = "#FFFFFF")]
	[Frame(factoryClass="YouSayJumpPreloader")]
	
	public class YouSayJumpISayHowHigh extends FlxGame
	{
		
		public function YouSayJumpISayHowHigh() 
		{	
			super(800,640,MenuState,Globals.ZOOM);
			
			// Debugging
			this.forceDebugger = true;	
			this.useSoundHotKeys = false;
		}
	}
}