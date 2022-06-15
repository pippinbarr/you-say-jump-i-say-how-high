package
{
	
	import flash.events.*;
	import flash.system.*;
	import flash.text.AntiAliasType;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;
	
	import levels.*;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.system.FlxTile;
	
	
	
	public class PlayState extends FlxState
	{
		// Including levels for definitions
		private var levelOneLevel:LevelOneLevel;
		private var antiGrav:AntiGravLevel;
		private var chunnel:ChunnelLevel;
		private var easyDoesIt:EasyDoesItLevel;
		private var flipper:FlipperLevel;
		private var luckyDip:LuckyDipLevel;
		private var noWayOut:NoWayOutLevel;
		private var oneShot:OneShotOneKillLevel;
		private var slowMotion:SlowMotionLevel;
		private var speedSaves:SpeedSavesLevel;
		private var terrorTunnel:TerrorTunnelLevel;
		private var theRoad:TheRoadNotTakenLevel;
		private var treadSoftly:TreadSoftlyLevel;
		private var umopepisdn:UmopepisdnLevel;
		private var unluckyDip:UnluckyDipLevel;
		
		
		// Images for explosions (of player and tiles)
		[Embed(source="../assets/particle.png")]
		private var ParticleClass:Class;
		[Embed(source="../assets/glassparticle.png")]
		private var GlassParticleClass:Class;
		[Embed(source="../assets/16x16/glow.png")]
		private var GLOW_PNG:Class;
		
		// The UI
		private var _ui:UI;
		
		private var _optionsMenuBG:FlxSprite;
		private var _optionsMenuString:String = "(R)ETRY LEVEL\n\n(M)AIN MENU";
		private var _optionsMenuText:FlxText;
		private var _optionsMenuActive:Boolean = false;
		
		private var _instructionsText:FlxText;
		private var _instructionsBG:FlxSprite;
		
		private var _glow:FlxSprite;
		
		// The player and the level!
		private var _player:Player;
		private var _showPlayer:Player;
		private var _level:Level;
		private var _showLevel:Level;
		private var _emitters:FlxGroup;
		
		// A place to remember the last velocity the player was moving at
		// which we need to calculate certain physics events since flixel
		// often sets the players actual velocity to 0 before we can
		// get to it.
		private var _lastPlayerVelocity:FlxPoint = new FlxPoint(0,0);
		private var _lastPlayerPosition:FlxPoint = new FlxPoint(0,0);
		
		
		private var antiGravCoinsCollected:uint = 0;
		private var normalCoinsCollected:uint = 0;
		private var starCollected:Boolean = false;
		
		private const MENU_DELAY:uint = 1;
				
		private var _levelComplete:Boolean = false;
		private var _killingPlayer:Boolean = false;
		public function PlayState()
		{
			super();
		}
		
		
		// create
		//
		// Initialises the various components of the game and adds them to the scene.
		
		public override function create():void
		{
			super.create();		
			
			trace("In create, Globals.levelNumber is " + Globals.levelNumber);
			
			
			setupSounds();
			
			//FlxG.stage.focus = null;
			
			// I should probably have a more creative background at some point
			FlxG.bgColor = Helpers.getRandomColor();

			_glow = new FlxSprite(FlxG.width - 24,0,GLOW_PNG);			
			add(_glow);
			
			// Construct the two key components
			var levelClass:Class = Class(getDefinitionByName(Globals.levelName));
			
			_showLevel = new levelClass();
			_showPlayer = new Player(_showLevel.getStart().x, _showLevel.getStart().y);
			_emitters = new FlxGroup(10);			
			
			// Add the components to the scene
			add(_showPlayer);
			add(_showLevel);
			add(_emitters);
			
			// Set up flixel's understanding of the scope of the world and what the
			// camera should cover
			FlxG.worldBounds = new FlxRect(0, 0, _showLevel.getWidth(), _showLevel.getHeight());
			
			_optionsMenuBG = new FlxSprite();
			_optionsMenuBG.makeGraphic(FlxG.width,300,0xCCFFFFFF);
			_optionsMenuBG.x = 0;
			_optionsMenuBG.y = (FlxG.height - _optionsMenuBG.height)/2;
			_optionsMenuBG.visible = false;
			add(_optionsMenuBG);
			
			_optionsMenuText = new FlxText(0,FlxG.height/2 - 48,FlxG.width,_optionsMenuString,true);
			_optionsMenuText.setFormat("COMMODORE",32,0xFF000000,"center");
			_optionsMenuText.visible = false;
			_optionsMenuActive = false;
			add(_optionsMenuText);
			
			_instructionsBG = new FlxSprite(0,608);
			_instructionsBG.makeGraphic(FlxG.width,32,0xFF000000);
			add(_instructionsBG);
			_instructionsText = new FlxText(0,614,FlxG.width,"ARROWS to move, SPACE to jump, R to restart, M for main menu",true);
			_instructionsText.setFormat("COMMODORE",16,0xFFFFFFFF,"center");
			add(_instructionsText);
			
			_ui = new UI();
			_ui.activate();
			
			_showPlayer.active = false;
			
		}
		
		
		private function setupSounds():void
		{
			if (Assets._coinSound == null)
			{
				Assets._coinSound = new FlxSound();
				Assets._coinSound.loadEmbedded(Assets.COIN_SOUND);
			}
			if (Assets._explodeSound == null)
			{
				Assets._explodeSound = new FlxSound();
				Assets._explodeSound.loadEmbedded(Assets.EXPLODE_SOUND);
			}
			if (Assets._hurtSound == null)
			{
				Assets._hurtSound = new FlxSound();
				Assets._hurtSound.loadEmbedded(Assets.HURT_SOUND);
			}
			if (Assets._levelWinSound == null)
			{
				Assets._levelWinSound = new FlxSound();
				Assets._levelWinSound.loadEmbedded(Assets.LEVELWIN_SOUND);
			}
			if (Assets._starSound == null)
			{
				Assets._starSound = new FlxSound();
				Assets._starSound.loadEmbedded(Assets.STAR_SOUND);
			}
			if (Assets._jumpSound == null)
			{
				Assets._jumpSound = new FlxSound();
				Assets._jumpSound.loadEmbedded(Assets.JUMP_SOUND);
			}
			if (Assets._tileBreakSound == null)
			{
				Assets._tileBreakSound = new FlxSound();
				Assets._tileBreakSound.loadEmbedded(Assets.TILEBREAK_SOUND);
			}
			if (Assets._waterSound == null)
			{
				Assets._waterSound = new FlxSound();
				Assets._waterSound.loadEmbedded(Assets.WATER_SOUND);
			}
		}
		
		
		public function startLevel():void
		{
			
			remove(_showLevel);
			//_level.destroy();
			//_level = null;
			var levelClass:Class = Class(getDefinitionByName(Globals.levelName));			
			_level = new levelClass();
			
			// Remove and re-add the player
			remove(_showPlayer);
			//_player.destroy();
			_player = new Player(_level.getStart().x, _level.getStart().y);
			_lastPlayerPosition.x = _player.x; 
			_lastPlayerPosition.y = _player.y;
			
			add(_player);
			add(_level);
			
			// Create the control handler care of photonstorm
			if (FlxG.getPlugin(FlxControl) == null) {
				FlxG.addPlugin(new FlxControl);
			}
			FlxControl.create(_player, FlxControlHandler.MOVEMENT_ACCELERATES, FlxControlHandler.STOPPING_DECELERATES, 1, true, false);
			
			// Default to "standard" controls since we'll try to begin every level
			// with the player standing on something (unless we maybe sometimes start
			// with them about to fall and thus needing zero gravity)
			setStandardPlayerControls();
			
			// Listen for keyboard events (currently this is just for resetting levels etc.)
			FlxG.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);	
			
			// Check whether the player has started with some of the level "inside" it
			// and kill them off immediately - not allow a scale that does that.
			if (_player.overlaps(_level.map))
			{
				_player.flicker(0.5);
				var timer:FlxTimer = new FlxTimer();
				timer.start(0.5,1,killPlayer);
			}
			else
			{
				_player.active = true;
			}
			
			FlxG.paused = false;
		}
		
		
		
		
		// update
		//
		// Does the things we need done each frame. Mostly that means working out the various
		// collisions of importance
		
		public override function update():void
		{			
			
			if (Globals.MEM_DEBUG)
			{
				trace("*** Top of update");
				traceMemory();
			}
			
			if (FlxG.paused)
			{
				return;
			}
			
			super.update();
			
			if (Globals.MEM_DEBUG)
			{
				trace("*** Post super.update()");
				traceMemory();
			}
			
//			trace("==== IN UPDATE ====");
//			trace("_player.acceleration.y = " + _player.acceleration.y);
//			trace("_lastPlayerVelocity.y = " + _lastPlayerVelocity.y);
//			trace("_player.velocity.y = " + _player.velocity.y);
//			trace("===================");

			// THIS IS WHAT IT LOOKS LIKE WHEN WORLDS COLLIDE!
			
			
			// - Player with the map (so that physics works)
			FlxG.collide(_player,_level.map, collision);
			
			// - Player with the coins (so that they can pick up)
			FlxG.overlap(_player,_level.coins,coinTouch);
			
			// - Player with the star (so that they can pick up)
			FlxG.overlap(_player,_level.star, starTouch);
			
			// - Coins with the map (so that physics works)
			FlxG.collide(_level.coins,_level.map);
			
			FlxG.collide(_level.star,_level.map);
			
			// - Movers with the map (so that they bounce)
			FlxG.collide(_level.movers, _level.map);
			
			if (!_killingPlayer)
			{
				// - Player with the movers (so that they die)
				FlxG.overlap(_player,_level.movers,moverTouch);
				
				// - Player with the spikes (so that they die)
				FlxG.overlap(_player,_level.spikes,spikeTouch);
			}
			
			if (Globals.MEM_DEBUG)
			{
				trace("*** Post main collisions and overlaps");
				traceMemory();
			}
			
			// Now check what kind of physics we need to apply based on whether
			// the player is in the water, in the air, or on the ground
			if (_player.overlaps(_level.water))
			{
				// THE PLAYER IS IN THE WATER
				if (!Globals.inWater)
				{
					
					Assets._waterSound.play();
					
					// One time kill of velocity due to hitting the surface
					_player.velocity.y /= 5;
					_player.velocity.x /= 5;
					
					// And show a splash!
					var emitter:FlxEmitter = new FlxEmitter(_player.x + _player.width,
						_player.y + _player.height); //x and y of the emitter
					
					emitter.makeParticles(GlassParticleClass,16,0);
					emitter.setXSpeed(-200,200);
					emitter.setYSpeed(0,-200);
					emitter.particleDrag = new FlxPoint(0,0);
					
					_emitters.add(emitter);
					emitter.start(true,1);
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
			
			if (Globals.MEM_DEBUG)
			{
				trace("*** Post setting controls");
				traceMemory();
			}
			
			// Remember the player's velocity for the next frame when we might want
			// to use it in a calculation of momentum
			_lastPlayerVelocity.x = _player.velocity.x;
			_lastPlayerVelocity.y = _player.velocity.y;
			_lastPlayerPosition.x = _player.x;
			_lastPlayerPosition.y = _player.y;
			
			
			// Check if they've won!
			if (!_levelComplete) checkLevelCompleteCondition();
		}
	
		
		// checkLevelCompleteCondition
		//
		// Checks whether the player made it to the far right of the screen and reacts
		
		private function checkLevelCompleteCondition():void
		{
			if (_player.x > _level.map.width &&
				_player.y + _player.height > 0 &&
				_player.y < _level.map.height &&
				(_ui == null || !FlxG.stage.contains(_ui)))
			{
				
				Assets._levelWinSound.play();
				
				FlxControl.stop();
				_player.active = false;
				
				Globals.LEVEL_STATS[Globals.levelNumber].through = true;
				if (antiGravCoinsCollected + normalCoinsCollected >= 10)
				{
					Globals.LEVEL_STATS[Globals.levelNumber].coins = "YES";
				}
				if (this.starCollected)
				{
					Globals.LEVEL_STATS[Globals.levelNumber].star = "YES";
				}
				if (antiGravCoinsCollected + normalCoinsCollected >= 10 &&
					starCollected)
				{
					Globals.LEVEL_STATS[Globals.levelNumber].all = "YES";
				}
				
				_levelComplete = true;
				
				this._optionsMenuText.text = "(N)EXT LEVEL\n\n" + _optionsMenuText.text;
				this._optionsMenuText.y -=32;
				
				SaveState.levelNumber = Globals.levelNumber;
				SaveState.levelStats = Globals.LEVEL_STATS;
				
				var timer:FlxTimer = new FlxTimer;
				timer.start(MENU_DELAY,1,endLevel);
			}
		}
		
		
		private function preLevel():void
		{
			_ui = new UI();
			FlxG.stage.addChild(_ui);
			_ui.activate();
			FlxControl.stop();
		}
		
		
		// coinTouch
		//
		// Handles the player touching a coin
		
		private function coinTouch(object1:FlxObject, object2:FlxObject):void
		{
			Assets._coinSound.play();
			
			trace("coinTouch()");
			trace("object2 as Coin has type " + (object2 as Coin).type);
			var coinObject:Coin = object2 as Coin;
			if (coinObject.type == Globals.ANTIGRAV_COIN_OBJECT)
			{
				antiGravCoinsCollected++;
			}
			else if (coinObject.type == Globals.COIN_OBJECT)
			{
				normalCoinsCollected++;
			}
			// Remove the coin from the level
			_level.coins.remove(object2 as Coin);
			
			// Don't want player to lose velocity
			//_player.velocity = _lastPlayerVelocity;
			
			// Possibly play a sound
			
			// Possibly make some kind of big deal about all coins collected
		}
		
		
		private function starTouch(object1:FlxObject, object2:FlxObject):void
		{
			Assets._starSound.play();
			
			starCollected = true;
			
			var starObject:FlxSprite = object2 as FlxSprite;
			_level.star.remove(starObject);
			//_level.remove(object2 as FlxSprite);
			// Plus got the star
			
			// Plus we don't want the player to lose velocity
			//_player.velocity = _lastPlayerVelocity;
			
		}
		
		// spikeTouch
		//
		// Handles the player touching a spike (= death!)
		
		private function spikeTouch(object1:FlxObject, object2:FlxObject):void
		{
			Assets._hurtSound.play();
			
			_player.active = false;
			// Just kill the player
			var timer:FlxTimer = new FlxTimer();
			_player.flicker(0.5);
			object2.flicker(0.5);
			_killingPlayer = true;
			FlxControl.stop();
			_player.active = false;
			timer.start(0.5,1,killPlayer);
		}
		
		
		// moverTouch
		//
		// Handles the player touching a mover (= death!)
		
		private function moverTouch(object1:FlxObject, object2:FlxObject):void
		{
			
			Assets._hurtSound.play();
			_player.active = false;
			
			// Just kill the player
			var timer:FlxTimer = new FlxTimer();
			_player.flicker(0.5);
			object2.flicker(0.5);
			_killingPlayer = true;
			_player.active = false;
			FlxControl.stop();
			timer.start(0.5,1,killPlayer);
		}
		
		
		// collision
		//
		// Handles collisions between the player and map elements
		
		private function collision(object1:FlxObject, object2:FlxObject):void
		{
			// Work out which tiles the player is overlapping
			var playerTileLeftIndex:uint = (_player.x) / Globals.TILE_SIZE;
			var playerTileRightIndex:uint = (_player.x + _player.width - 1) / Globals.TILE_SIZE;
			var playerTileTopIndex:uint = (_player.y + 1) / Globals.TILE_SIZE;
			var playerTileBottomIndex:uint = (_player.y + _player.height - 1) / Globals.TILE_SIZE;
			
			var i:int;
			var explodedATile:Boolean = false;
			
			// HIT A TILE BELOW
			if (_player.isTouching(FlxObject.FLOOR))
			{
				
//				trace("==== HIT FLOOR ===");
//				trace("_player.acceleration.y = " + _player.acceleration.y);
//				trace("_lastPlayerVelocity.y = " + _lastPlayerVelocity.y);
//				trace("_player.velocity.y = " + _player.velocity.y);
//				trace("====================");

				// Run through every tile the the bottom of the player may be touching
				for (i = playerTileLeftIndex; i <= playerTileRightIndex; i++)
				{
					if (tileWillBreak(((_lastPlayerVelocity.y) * Globals.MASS/1000),_level.map.getTile(i, playerTileBottomIndex + 1)) ||
						tileWillBreak(((_player.velocity.y) * Globals.MASS/1000),_level.map.getTile(i, playerTileBottomIndex + 1)))
					{
						explodeTile(i, playerTileBottomIndex + 1,_level.map.getTile(i, playerTileBottomIndex + 1));
						explodedATile = true;
					}
				}
				if (explodedATile) _player.velocity.y = _lastPlayerVelocity.y * 0.75;
				explodedATile = false;
				
			}
			
			// HIT A TILE ABOVE
			if (_player.isTouching(FlxObject.CEILING))
			{
//				trace("==== HIT CEILING ===");
//				trace("_player.acceleration.y = " + _player.acceleration.y);
//				trace("_lastPlayerVelocity.y = " + _lastPlayerVelocity.y);
//				trace("_player.velocity.y = " + _player.velocity.y);
//				trace("====================");

				for (i = playerTileLeftIndex; i <= playerTileRightIndex; i++)
				{
					if (tileWillBreak(((_lastPlayerVelocity.y) * (Globals.MASS/1000)),_level.map.getTile(i, playerTileTopIndex - 1)) ||
						tileWillBreak(((_player.velocity.y) * (Globals.MASS/1000)),_level.map.getTile(i, playerTileTopIndex - 1)))
					{
						explodeTile(i, playerTileTopIndex-1,_level.map.getTile(i, playerTileTopIndex-1));
						explodedATile = true;
					}
				}
				if (explodedATile) _player.velocity.y = _lastPlayerVelocity.y * 0.75;
				explodedATile = false;
				
			}
			
			// HIT A TILE TO THE LEFT
			if (_player.isTouching(FlxObject.LEFT))
			{
//				trace("==== HIT LEFT ===");
//				trace("_player.acceleration.x = " + _player.acceleration.x);
//				trace("_lastPlayerVelocity.x = " + _lastPlayerVelocity.x);
//				trace("_player.velocity.x = " + _player.velocity.x);
//				trace("====================");
				for (i = playerTileTopIndex; i <= playerTileBottomIndex; i++)
				{
					if ((_player.acceleration.x < 0 || _lastPlayerVelocity.x < 0) &&
						tileWillBreak(((_player.acceleration.x / 100) * (Globals.MASS/1000)),_level.map.getTile(playerTileLeftIndex-1, i)))
					{
						explodeTile(playerTileLeftIndex-1, i,_level.map.getTile(playerTileLeftIndex-1, i));
						explodedATile = true;
					}
				}
				if (explodedATile) _player.velocity.x = _lastPlayerVelocity.x * 0.75;
				explodedATile = false;
				
			}
			
			// HIT A TILE TO THE RIGHT
			if (_player.isTouching(FlxObject.RIGHT))
			{
//				trace("==== HIT RIGHT ===");
//				trace("_player.acceleration.x = " + _player.acceleration.x);
//				trace("_lastPlayerVelocity.x = " + _lastPlayerVelocity.x);
//				trace("_player.velocity.x = " + _player.velocity.x);
//				trace("====================");

				for (i = playerTileTopIndex; i <= playerTileBottomIndex; i++)
				{
					if (_player.acceleration.x > 0 &&
						tileWillBreak(((_player.acceleration.x / 100) * Globals.MASS/1000),_level.map.getTile(playerTileRightIndex + 1, i)))
					{
						explodeTile(playerTileRightIndex + 1, i,_level.map.getTile(playerTileRightIndex + 1, i));
						explodedATile = true;
					}
				}
				if (explodedATile) _player.velocity.x = _lastPlayerVelocity.x * 0.75;
				explodedATile = false;
			}
			
		}
		
		
		
		
		// tileWillBreak
		//
		// Based on the velocity it was hit and its type, returns whether
		// the tile will be shattered
		
		private function tileWillBreak(force:Number,tileType:uint):Boolean
		{
			if (tileType == Globals.SOLID_TILE)
			{
				return (Math.abs(force) >= Globals.TILE_BREAK_THRESHOLD);
			}
			else if (tileType == Globals.GLASS_TILE)
			{
				return (Math.abs(force) >= Globals.GLASS_TILE_BREAK_THRESHOLD);
			}
			else return false;
		}
		
		
		// explodeTile
		//
		// Takes a tile location and blows it up
		// by removing it from the stage and using an emitter
		
		private function explodeTile(X:int,Y:int,type:int):void
		{
			Assets._tileBreakSound.play();
			
			_level.map.setTile(X, Y, 7, true);
			
			var emitter:FlxEmitter = _emitters.recycle(FlxEmitter) as FlxEmitter;
			emitter.x = X * Globals.TILE_SIZE + Globals.TILE_SIZE/2;
			emitter.y = Y * Globals.TILE_SIZE + Globals.TILE_SIZE / 2;
//			var emitter:FlxEmitter = new FlxEmitter(X * Globals.TILE_SIZE + Globals.TILE_SIZE / 2,
//				Y * Globals.TILE_SIZE + Globals.TILE_SIZE / 2); //x and y of the emitter
			if (type == 9) emitter.makeParticles(ParticleClass,16,0);
			else if (type == 10) emitter.makeParticles(GlassParticleClass,16,0);
			emitter.minParticleSpeed = new FlxPoint(-200,-200);
			emitter.maxParticleSpeed = new FlxPoint(200,200);
			emitter.particleDrag = new FlxPoint(0,0);
			
			_emitters.add(emitter);
			emitter.start(true,1);
		}
		
		
		// killPlayer
		//
		// Removes the player, puts an emitter there for the explosion
		// and calls kill() on the player
		
		private function killPlayer(timer:FlxTimer = null):void
		{
			Assets._explodeSound.play();
			
			if (timer != null) timer.destroy();
			var emitter:FlxEmitter = _emitters.recycle(FlxEmitter) as FlxEmitter;
			emitter.x = _player.x + _player.width/2;
			emitter.y = _player.y + _player.height/2;
//			var emitter:FlxEmitter = new FlxEmitter(_player.x + _player.width/2,
//				_player.y + _player.height/2); //x and y of the emitter
			emitter.makeParticles(ParticleClass,64,0);
			emitter.minParticleSpeed = new FlxPoint(-200,-200);
			emitter.maxParticleSpeed = new FlxPoint(200,200);
			emitter.particleDrag = new FlxPoint(0,0);
			_emitters.add(emitter);
			emitter.start(true,1);	
			
			remove(_player);
			_player.kill();
			
			var timer:FlxTimer = new FlxTimer();
			timer.start(MENU_DELAY,1,endLevel);
			
			// Or could leave them there and flicker or something ala VVVVVV
		}
		
		private function endLevel(timer:FlxTimer):void
		{			
			if (timer != null)
			{
				timer.destroy();
			}
			
			Assets._changeLevelSound.play();
			_optionsMenuBG.visible = true;
			_optionsMenuText.visible = true;
			_optionsMenuActive = true;
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
			trace("Setting GROUND CONTROLS");
			
			FlxControl.player1.setCursorControl(false, false, true, true);
			if (Globals.GRAVITY >= 0)
				FlxControl.player1.setJumpButton("SPACE", FlxControlHandler.KEYMODE_PRESSED, Globals.JUMP_SPEED, FlxObject.FLOOR, 250, 50);
			else if (Globals.GRAVITY < 0)
				FlxControl.player1.setJumpButton("SPACE", FlxControlHandler.KEYMODE_PRESSED, Globals.JUMP_SPEED, FlxObject.CEILING, 250, 50);	
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
			trace("Setting WATER CONTROLS");

			
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
			trace("Setting AIR CONTROLS");
			
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
			if (e.keyCode == Keyboard.N && _optionsMenuActive && _levelComplete)
			{
				trace("Globals.levelNumber is " + Globals.levelNumber);
				Globals.levelNumber++;
				if (Globals.levelNumber >= Globals.LEVEL_CLASSES.length)
				{
					Globals.levelNumber = 0;
				}
				Globals.levelName = Globals.LEVEL_CLASSES[Globals.levelNumber];
				trace("After increment it is " + Globals.levelNumber);
				FlxG.switchState(new PlayState);
			}
			else if (e.keyCode == Keyboard.R)
			{
				FlxG.switchState(new PlayState);
			}
			else if (e.keyCode == Keyboard.M)
			{
				FlxG.switchState(new MenuState);	
			}			
		}
		
		
		private static function traceMemory():void {
			trace("PlayState: memory usage: " + (System.totalMemory / 1024 / 1024) + " MB");
		}

		
		
		// destroy
		//
		// Free up le memory
		
		public override function destroy():void
		{
			
			if (Globals.MEM_DEBUG)
			{
				trace("*** Top of destroy");
				traceMemory();
			}
			
			super.destroy();
			
			if (FlxG.stage.contains(_ui))
			{
				FlxG.stage.removeChild(_ui);
			}
			
			_player.destroy();
			_showPlayer.destroy();
			_level.destroy();
			_showLevel.destroy();
			_emitters.destroy();
			_optionsMenuText.destroy();
			_optionsMenuBG.destroy();
			_instructionsText.destroy();
			_instructionsBG.destroy();
			
			_lastPlayerVelocity = null;
			_lastPlayerPosition = null;
			
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);	
			
			FlxG.stage.focus = null;
			
			if (Globals.MEM_DEBUG)
			{
				trace("*** Bottom of destroy");
				traceMemory();
			}
		}
	}
}