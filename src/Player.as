package
{
		
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{
		
		[Embed(source = '../assets/16x16/player.png')] 
		private const PLAYER_PNG:Class;
				
		public function Player(X:Number, Y:Number)
		{
			super(X,Y);
			
			trace("Created avatar at " + X + "," + Y);
			
			// Set up the sprite
			this.loadGraphic(PLAYER_PNG,true,true,32,64);
			//this.makeGraphic(16,32,0xFF0000FF);
			this.facing = FlxObject.RIGHT;
			if (Globals.GRAVITY < 0)
			{
				this.frame = 1;
			}
			else
			{
				this.frame = 0;
			}
			y -= this.height;
						
			this.scale = new FlxPoint(Globals.SCALE, Globals.SCALE);

			
			x = (x + width/2) - ((width * scale.x)/2);
			y = (y + height) - (height * scale.y);
			
			// Tweak the bounding box based on the scale
			width *= scale.x; height *= scale.y;
			offset.x = -(width/2 - width/scale.x/2); 
			offset.y = -(height/2 - height/scale.y/2);
			
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