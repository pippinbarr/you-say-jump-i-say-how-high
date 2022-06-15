package
{
	
	import flash.events.*;
	import flash.ui.Keyboard;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.system.FlxTile;
	
	import levels.*;
	
	
	public class Prototype extends FlxState
	{
		
		// Images for explosions (of player and tiles)
		[Embed(source="../assets/particle.png")]
		private var ParticleClass:Class;
		[Embed(source="../assets/glassparticle.png")]
		private var GlassParticleClass:Class;
		
		// The player and the level!
		private var _player:Player;
		private var _level:Level;
		
		// A place to remember the last velocity the player was moving at
		// which we need to calculate certain physics events since flixel
		// often sets the players actual velocity to 0 before we can
		// get to it.
		private var _lastPlayerVelocity:FlxPoint = new FlxPoint(0,0);
		
		public function Prototype()
		{
			super();
		}
		
		
		// create
		//
		// Initialises the various components of the game and adds them to the scene.
		
		public override function create():void
		{
			super.create();
			
			// I should probably have a more creative background at some point
			FlxG.bgColor = 0xFFFFFFFF;
			
			// Construct the two key components
			_level = new PrototypeLevel();
			_player = new Player(_level.getStart().x, _level.getStart().y);
			
			// Create the control handler care of photonstorm
			if (FlxG.getPlugin(FlxControl) == null) {
				FlxG.addPlugin(new FlxControl);
			}
			FlxControl.create(_player, FlxControlHandler.MOVEMENT_ACCELERATES, FlxControlHandler.STOPPING_DECELERATES, 1, true, false);
			
			// Default to "standard" controls since we'll try to begin every level
			// with the player standing on something (unless we maybe sometimes start
			// with them about to fall and thus needing zero gravity)
			setStandardPlayerControls();	
			
			// Add the components to the scene
			add(_player);
			add(_level);
			
			// Set up flixel's understanding of the scope of the world and what the
			// camera should cover
			FlxG.worldBounds = new FlxRect(0, 0, _level.getWidth(), _level.getHeight());
			
			// Listen for keyboard events (currently this is just for resetting levels etc.)
			FlxG.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);	
			
			// Check whether the player has started with some of the level "inside" it
			// and kill them off immediately - not allow a scale that does that.
			if (_player.overlaps(_level.map))
			{
				killPlayer();
			}
		}
		
		
	
		
		
		// update
		//
		// Does the things we need done each frame. Mostly that means working out the various
		// collisions of importance
		
		public override function update():void
		{	
			super.update();
			
			// Apply gravity to the coins
			// It occurs to me I could just do this in create?
			_level.coins.setAll("acceleration",new FlxPoint(0,Globals.GRAVITY));
			
			// THIS IS WHAT IT LOOKS LIKE WHEN WORLDS COLLIDE!
			
			// - Player with the map (so that physics works)
			FlxG.collide(_player,_level.map, collision);
			
			// - Player with the coins (so that they can pick up)
			FlxG.collide(_player,_level.coins, coinTouch);
			
			// - Coins with the map (so that physics works)
			FlxG.collide(_level.coins,_level.map);
			
			// - Movers with the map (so that they bounce)
			FlxG.collide(_level.movers, _level.map);
			
			// - Player with the movers (so that they die)
			FlxG.overlap(_player,_level.movers,moverTouch);
			
			// - Player with the spikes (so that they die)
			FlxG.overlap(_player,_level.spikes,spikeTouch);
			
			// Now check what kind of physics we need to apply based on whether
			// the player is in the water, in the air, or on the ground
			if (_player.overlaps(_level.water))
			{

				// THE PLAYER IS IN THE WATER

				if (!Globals.inWater)
				{
					// One time kill of velocity due to hitting the surface
					_player.velocity.y /= 5;
					_player.velocity.x /= 5;
				}
				Globals.inAir = false;
				Globals.inWater = true;
				waterPhysics();
			}
			else
			{
				if ((Globals.GRAVITY > 0 && _player.isTouching(FlxObject.FLOOR) && Globals.inAir && !Globals.inWater) ||
					(Globals.GRAVITY < 0 && _player.isTouching(FlxObject.CEILING) && Globals.inAir && !Globals.inWater))
				{

					// THE PLAYER IS ON THE GROUND
					
					Globals.inAir = false;
					Globals.inWater = false;
					this.setStandardPlayerControls();
				}
				if ((Globals.GRAVITY > 0 && !_player.isTouching(FlxObject.FLOOR)) ||
					(Globals.GRAVITY < 0 && !_player.isTouching(FlxObject.CEILING)))
				{

					// THE PLAYER IS IN THE AIR
					
					Globals.inAir = true;
					Globals.inWater = false;
					this.setAirPlayerControls();
				}
			}
			
			// Remember the player's velocity for the next frame when we might want
			// to use it in a calculation of momentum
			_lastPlayerVelocity.x = _player.velocity.x;
			_lastPlayerVelocity.y = _player.velocity.y;
			
			// Check if they've won!
			checkLevelCompleteCondition();
		}
		
		
		// checkLevelCompleteCondition
		//
		// Checks whether the player made it to the far right of the screen and reacts
		
		private function checkLevelCompleteCondition():void
		{
			trace(_player.x + "," + _player.y);
			if (_player.x > _level.map.width &&
				_player.y > 0 &&
				_player.y < _level.map.height)
			{
				trace("Winner winner.");
			}
		}
		
		
		// coinTouch
		//
		// Handles the player touching a coin
		
		private function coinTouch(object1:FlxObject, object2:FlxObject):void
		{
			// Remove the coin from the level
			_level.coins.remove(object2 as FlxSprite);
			
			// Increment the coins counter
			Globals.coinsCollected++;
			
			// Possibly play a sound
			
			// Possibly make some kind of big deal about all coins collected
		}
		
		
		// spikeTouch
		//
		// Handles the player touching a spike (= death!)
		
		private function spikeTouch(object1:FlxObject, object2:FlxObject):void
		{
			// Just kill the player
			killPlayer();
			
			// Possibly flicker the mover
		}
		
		
		// moverTouch
		//
		// Handles the player touching a mover (= death!)
		
		private function moverTouch(object1:FlxObject, object2:FlxObject):void
		{
			// Just kill the player
			killPlayer();
			
			// Possibly flicker the mover
		}
		
		
		// collision
		//
		// Handles collisions between the player and map elements
		
		private function collision(object1:FlxObject, object2:FlxObject):void
		{
			
			// Work out which tiles the player is overlapping
			var playerTileLeftIndex:uint = _player.x / Globals.TILE_SIZE;
			var playerTileRightIndex:uint = (_player.x + _player.width) / Globals.TILE_SIZE;
			var playerTileTopIndex:uint = _player.y / Globals.TILE_SIZE;
			var playerTileBottomIndex:uint = (_player.y + _player.height) / Globals.TILE_SIZE;
						
			var i:int;
						
			// HIT A TILE BELOW
			if (_player.isTouching(FlxObject.FLOOR))
			{
				// Run through every tile the the bottom of the player may be touching
				for (i = playerTileLeftIndex; i <= playerTileRightIndex; i++)
				{
					if (tileWillBreak(this._lastPlayerVelocity.y + (_player.acceleration.y * Globals.MASS/1000),_level.map.getTile(i, playerTileBottomIndex)))
					{
						explodeTile(i, playerTileBottomIndex,_level.map.getTile(i, playerTileBottomIndex));
					}
				}
				// Lower the player's velocity as a result of the impact
				_player.velocity.y = _lastPlayerVelocity.y / 4;
			}
			
			// HIT A TILE ABOVE
			if (_player.isTouching(FlxObject.CEILING))
			{
				for (i = playerTileLeftIndex; i <= playerTileRightIndex; i++)
				{
					if (tileWillBreak(this._lastPlayerVelocity.y - (_player.acceleration.y * Globals.MASS/1000),_level.map.getTile(i, playerTileTopIndex-1)))
					{
						explodeTile(i, playerTileTopIndex-1,_level.map.getTile(i, playerTileTopIndex-1));
					}
				}
				_player.velocity.y = _lastPlayerVelocity.y / 4;
			}
			
			// HIT A TILE TO THE LEFT
			if (_player.isTouching(FlxObject.LEFT))
			{
				for (i = playerTileTopIndex; i <= playerTileBottomIndex; i++)
				{
					if (tileWillBreak(_lastPlayerVelocity.x,_level.map.getTile(playerTileLeftIndex-1, i)))
					{
						explodeTile(playerTileLeftIndex-1, i,_level.map.getTile(playerTileLeftIndex-1, i));
					}
				}
				_player.velocity.x = _lastPlayerVelocity.x / 4;
			}
			
			// HIT A TILE TO THE RIGHT
			if (_player.isTouching(FlxObject.RIGHT))
			{
				for (i = playerTileTopIndex; i <= playerTileBottomIndex; i++)
				{
					if (tileWillBreak(_lastPlayerVelocity.x,_level.map.getTile(playerTileRightIndex, i)))
					{
						explodeTile(playerTileRightIndex, i,_level.map.getTile(playerTileRightIndex, i));
					}
				}
				_player.velocity.x = _lastPlayerVelocity.x / 4;
			}
			
		}
		
		
		// tileWillBreak
		//
		// Based on the velocity it was hit and its type, returns whether
		// the tile will be shattered
		
		private function tileWillBreak(velocity:Number,tileType:uint):Boolean
		{
			if (tileType == Globals.SOLID_TILE)
			{
				return (Math.abs(velocity * Globals.MASS)) >= Globals.TILE_BREAK_THRESHOLD
			}
			if (tileType == Globals.GLASS_TILE)
			{
				return (Math.abs(velocity * Globals.MASS)) >= Globals.GLASS_TILE_BREAK_THRESHOLD
			}
			else return false;
		}
		
		
		// explodeTile
		//
		// Takes a tile location and blows it up
		// by removing it from the stage and using an emitter
		
		private function explodeTile(X:int,Y:int,type:int):void
		{
			_level.map.setTile(X, Y, 7, true);
			
			var emitter:FlxEmitter = new FlxEmitter(X * Globals.TILE_SIZE + Globals.TILE_SIZE / 2,
													Y * Globals.TILE_SIZE + Globals.TILE_SIZE / 2); //x and y of the emitter
			if (type == 9) emitter.makeParticles(ParticleClass,16,0);
			else if (type == 10) emitter.makeParticles(GlassParticleClass,16,0);
			emitter.minParticleSpeed = new FlxPoint(-200,-200);
			emitter.maxParticleSpeed = new FlxPoint(200,200);
			emitter.particleDrag = new FlxPoint(0,0);

			add(emitter);
			emitter.start(true,1);
		}
		
		
		// killPlayer
		//
		// Removes the player, puts an emitter there for the explosion
		// and calls kill() on the player
		
		private function killPlayer():void
		{
			var emitter:FlxEmitter = new FlxEmitter(_player.x + _player.width/2,
				_player.y + _player.height/2); //x and y of the emitter
			emitter.makeParticles(ParticleClass,64,0);
			emitter.minParticleSpeed = new FlxPoint(-200,-200);
			emitter.maxParticleSpeed = new FlxPoint(200,200);
			emitter.particleDrag = new FlxPoint(0,0);
			
			add(emitter);
			emitter.start(true,1);	
			
			remove(_player);
			_player.kill();
			
			// Or could leave them there and flicker or something ala VVVVVV
		}
		
		
		// waterPhysics
		//
		// Basically just checks how much of the player is submerged in the water
		// and then tells the water controller
		
		private function waterPhysics():void
		{			
			// Establish the tile that the player's feet overlap with
			var playerBottomY:int = _player.y + _player.height;
			var playerBottomWaterTile:uint = _level.water.getTile(_player.x / Globals.TILE_SIZE,playerBottomY / Globals.TILE_SIZE);
			var playerTopWaterTile:uint = _level.water.getTile(_player.x / Globals.TILE_SIZE,_player.y / Globals.TILE_SIZE);
						
			var waterEffect:Number;
			
			if (playerBottomWaterTile == Globals.WATER_TILE && playerTopWaterTile == Globals.WATER_TILE)
			{
				// Completely submerged
				waterEffect = 1.0;
			}
			else
			{
				// Partially submerged, so work out how much
				var playerBottomTileIndex:uint = (_player.y + _player.height) / Globals.TILE_SIZE;
				var playerTopTileIndex:uint = _player.y / Globals.TILE_SIZE;
				var playerSideTileIndex:uint = (_player.x / Globals.TILE_SIZE);
				
				var overlapAmount:Number = 0;
				for (var i:int = playerBottomTileIndex - 1; i > playerTopTileIndex ; i--)
				{
					if (_level.water.getTile(playerSideTileIndex, i) == Globals.WATER_TILE)
					{
						overlapAmount += Globals.TILE_SIZE;
					}
					else
					{
						break;
					}
				}
				
				overlapAmount += (_player.y + _player.height) - (playerBottomTileIndex * Globals.TILE_SIZE);
				waterEffect = overlapAmount / _player.height;
				
			}
									
			this.setWaterPlayerControls(waterEffect);
			
		}

		
		// setStandardPlayerControls
		//
		// Actually means "ground", and sets the values for the controller so that the player
		// moves based on being on the ground
		
		private function setStandardPlayerControls():void
		{
			FlxControl.player1.setCursorControl(false, false, true, true);
			if (Globals.GRAVITY >= 0)
				FlxControl.player1.setJumpButton("SPACE", FlxControlHandler.KEYMODE_PRESSED, Globals.JUMP_SPEED, FlxObject.FLOOR, 250, 200);
			else if (Globals.GRAVITY < 0)
				FlxControl.player1.setJumpButton("SPACE", FlxControlHandler.KEYMODE_PRESSED, Globals.JUMP_SPEED, FlxObject.CEILING, 250, 200);	
			FlxControl.player1.setMovementSpeed(Globals.GROUND_SPEED * 100, 0, Globals.GROUND_SPEED, Globals.JUMP_SPEED, Globals.GROUND_FRICTION, 0);
			FlxControl.player1.setGravity(0, Globals.GRAVITY);
		}
		
		
		// setWaterPlayerControls
		//
		// Sets the controller's values for movement in water
		// Also applies a counter-force against the player of gravity
		// and of drag
		
		private function setWaterPlayerControls(waterEffect:Number):void
		{
			var waterSpeed:Number = (waterEffect * Globals.SWIM_SPEED) + ((1 - waterEffect) * Globals.SWIM_SPEED);
			var waterDrag:Number = (waterEffect * Globals.WATER_DRAG) + ((1 - waterEffect) * Globals.AIR_CONTROL_FRICTION);
			
			FlxControl.player1.setCursorControl(true, true, true, true);
			FlxControl.player1.setJumpButton("SPACE", FlxControlHandler.KEYMODE_PRESSED, 0, FlxObject.NONE, 250, 200);
			FlxControl.player1.setMovementSpeed(Globals.SWIM_SPEED * 100, Globals.SWIM_SPEED * 100, waterSpeed, waterSpeed, waterDrag, waterDrag);

			// Apply buoyancy counter force to gravity
			var gravity:Number = Globals.GRAVITY;
			gravity += (waterEffect * -Globals.GRAVITY) / (Globals.DENSITY); // NOTE: BAD BEHAVIOUR FOR VERY LOW DENSITY (SKIPPING)
			FlxControl.player1.setGravity(0, gravity);
			
			
			var drag:Number = 2;
			if (_player.velocity.y > 0) 
			{
				if (_player.velocity.y - drag >= 0)
					_player.velocity.y -= drag;
				else _player.velocity.y = 0;
			}
			else if (_player.velocity.y < 0)
			{
				if (_player.velocity.y + drag <= 0)
					_player.velocity.y += drag;
				else _player.velocity.y = 0;
			}			
		}
		
		
		// setAirPlayerControls
		//
		// Set the controller's values to make the player behave in the air
		
		private function setAirPlayerControls():void
		{
			FlxControl.player1.setCursorControl(false, false, true, true);
			FlxControl.player1.setJumpButton("SPACE", FlxControlHandler.KEYMODE_PRESSED, Globals.JUMP_SPEED, FlxObject.FLOOR, 250, 200);
			FlxControl.player1.setMovementSpeed(Globals.AIR_SPEED * 100, 0, Globals.AIR_SPEED, Globals.JUMP_SPEED, Globals.AIR_CONTROL_FRICTION, 0);
			FlxControl.player1.setGravity(0, Globals.GRAVITY);
		}
		
		
		// onKeyUp
		//
		// Handle key presses! No way!
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.W)
			{
				setWaterPlayerControls(1);
			}
			else if (e.keyCode == Keyboard.S)
			{
				setStandardPlayerControls();
			}
			else if (e.keyCode == Keyboard.A)
			{
				setAirPlayerControls();
			}
		}
		
		
		// destroy
		//
		// Free up le memory
		
		public override function destroy():void
		{
			_player.destroy();
			_level.destroy();
			
			super.destroy();
		}
	}
}