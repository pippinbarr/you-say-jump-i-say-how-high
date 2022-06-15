package
{
	
	import org.flixel.*;
	
	public class Coin extends FlxSprite
	{
		[Embed(source = "../assets/16x16/objects.png")] 
		public var objectsPNG:Class;
		[Embed(source="../assets/glassparticle.png")]
		private var GlassParticleClass:Class;

				
		private var lastVelocity:FlxPoint = new FlxPoint(0,0);
		private var inWater:Boolean = false;
		
		public var type:uint;
		
		public function Coin(X:int, Y:int, Type:uint)
		{
			super(X,Y);
			
			type = Type;
			
			this.loadGraphic(objectsPNG,true,false,32,32);
			this.frame = type;
			
			if (this.type == Globals.ANTIGRAV_COIN_OBJECT)
			{
				this.acceleration.y = 0;
			}
			else
			{
				this.acceleration.y = Globals.GRAVITY;
			}
		}
		
		public override function update():void
		{

			
			if (Globals.waterLevel > 0 && this.y + this.height >= Globals.waterLevel)
			{
				// THE COIN IS IN THE WATER
				if (!inWater)
				{
					inWater = true;
					
					// One time kill of velocity due to hitting the surface
					this.velocity.y /= 5;
					this.velocity.x /= 5;
					
					// And show a splash!
					//var emitter:FlxEmitter = new FlxEmitter(X * Globals.TILE_SIZE + Globals.TILE_SIZE / 2,
					//	Y * Globals.TILE_SIZE + Globals.TILE_SIZE / 2); //x and y of the emitter
					
					var emitter:FlxEmitter = new FlxEmitter(this.x + this.width,
						this.y + this.height); //x and y of the emitter
					
					emitter.makeParticles(GlassParticleClass,16,0);
					emitter.setXSpeed(-200,200);
					emitter.setYSpeed(0,-200);
					emitter.particleDrag = new FlxPoint(0,0);
					
					FlxG.state.add(emitter);
					emitter.start(true,1);
				}
				Globals.inAir = false;
				Globals.inWater = true;
				
				// Establish the tile that the coin's feet overlap with
				var coinBottomY:int = this.y + this.height;
				
				var waterEffect:Number;

				if (this.y >= Globals.waterLevel)
				{
					waterEffect = 1.0;
				}
				else
				{
					var amountSubmerged:Number = this.y + this.height - Globals.waterLevel;
					waterEffect = amountSubmerged / this.height;
				}
				
				// Apply buoyancy counter force to gravity
				var gravity:Number = Globals.GRAVITY;
				gravity += (waterEffect * -Globals.GRAVITY) / (Globals.COIN_DENSITY); // NOTE: BAD BEHAVIOUR FOR VERY LOW DENSITY (SKIPPING)
				this.acceleration.y = gravity;				
				
				var drag:Number = 4;
				if (this.velocity.y > 0) 
				{
					if (this.velocity.y - drag >= 0)
						this.velocity.y -= drag;
					else this.velocity.y = 0;
				}
				else if (this.velocity.y < 0)
				{
					if (this.velocity.y + drag <= 0)
						this.velocity.y += drag;
					else this.velocity.y = 0;
				}	
			}

				
				
			super.update();
		}
		
		public override function destroy():void
		{
			super.destroy();
		}
	}
}