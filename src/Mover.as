package
{
	
	import org.flixel.*;
	
	public class Mover extends FlxSprite
	{
		
		[Embed(source = "../assets/16x16/objects.png")] 
		public var objectsPNG:Class;

		
		private var _type:uint;
		private const LEFT_RIGHT:uint = 1;
		private const UP_DOWN:uint = 2;
		private const SPEED:uint = 200;
		
		private var lastVelocity:FlxPoint = new FlxPoint(0,0);
		
		public function Mover(X:int, Y:int, type:uint)
		{
			super(X,Y);
			
			this.loadGraphic(objectsPNG,true,false,32,32);
			this.frame = type;
			this._type = type;
			
			if (_type == Globals.LEFT_RIGHT_MOVER_OBJECT)
			{
				velocity.x = SPEED;
			}
			else if (_type == Globals.UP_DOWN_MOVER_OBJECT)
			{
				velocity.y = SPEED;
			}
		}
		
		public override function update():void
		{
			super.update();
			
			if (isTouching(FlxObject.LEFT) || isTouching(FlxObject.RIGHT))
			{
				velocity.x = -lastVelocity.x
			}
			else if (isTouching(FlxObject.CEILING) || isTouching(FlxObject.FLOOR))
			{
				velocity.y = -lastVelocity.y;
			}
			
			lastVelocity.x = velocity.x;
			lastVelocity.y = velocity.y;
		}
		
		public override function destroy():void
		{
			super.destroy();
		}
	}
}