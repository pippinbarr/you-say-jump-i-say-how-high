package levels
{
	
	import org.flixel.*;

	
	public class Level extends FlxGroup
	{
		
		public var mapCSV:Class;
		public var spikesCSV:Class;
		public var waterCSV:Class;
		public var objectsCSV:Class;
		
		[Embed(source = "../../assets/16x16/maptiles.png")] 
		public var mapTilesPNG:Class;
		[Embed(source = "../../assets/16x16/objects-clean.png")] 
		public var objectsPNG:Class;
		
		
		public var map:FlxTilemap;
		public var spikes:FlxGroup;
		public var water:FlxTilemap;
		public var coins:FlxGroup;	
		public var movers:FlxGroup;
		public var star:FlxGroup;
		
		private var _totalCoins:uint = 0;
		
		private var _width:uint;
		private var _height:uint;
		private var _waterLevel:uint;
		
		protected var _start:FlxPoint;
		
		
		public function Level()
		{
			super();
			
			map = new FlxTilemap();
			map.loadMap(new mapCSV, mapTilesPNG, Globals.TILE_SIZE, Globals.TILE_SIZE, 0, 0, 1, Globals.COLLIDE_INDEX);
			
			water = new FlxTilemap();
			water.loadMap(new waterCSV, mapTilesPNG, Globals.TILE_SIZE, Globals.TILE_SIZE, 0, 0, 1, Globals.COLLIDE_INDEX-1);
			
			
			//Globals.waterLevel = map.heightInTiles * Globals.TILE_SIZE;
			for (var i:uint = 0; i < water.totalTiles; i++)
			{
				if (water.getTileByIndex(i) == Globals.WATER_TILE)
				{
					Globals.waterLevel = (i / water.widthInTiles) * Globals.TILE_SIZE;
					break;
				}
			}
			
			_width = map.width; 
			_height = map.height;
			
			parseSpikes();
			
			parseObjects();
			
			add(map);
			add(spikes);
			add(water);
						
		}
		
		
		private function parseSpikes():void
		{
			var spikeMap:FlxTilemap = new FlxTilemap();
			spikeMap.loadMap(new spikesCSV, mapTilesPNG, 16, 16);
			
			spikes = new FlxGroup();
			
			var type:uint = 0;
			var spikeSprite:FlxSprite;
			for (var y:uint = 0; y < spikeMap.heightInTiles; y++) 
			{
				for (var x:uint = 0; x < spikeMap.widthInTiles; x++) 
				{
					type = spikeMap.getTile(x,y);
					if (type != 0) 
					{
						spikeSprite = new FlxSprite(x * 16, y * 16);
						spikeSprite.loadGraphic(mapTilesPNG,true,false,16,16);
						spikeSprite.frame = type;
						spikes.add(spikeSprite);
					}
				}
			}			
		}
		
		private function parseObjects():void 
		{
			
			var objectMap:FlxTilemap = new FlxTilemap();
			objectMap.loadMap(new objectsCSV, objectsPNG, 32, 32);
			
			coins = new FlxGroup();
			movers = new FlxGroup();
			star = new FlxGroup();
			
			var type:uint = 0;
			for (var y:uint = 0; y < objectMap.heightInTiles; y++) 
			{
				for (var x:uint = 0; x < objectMap.widthInTiles; x++) 
				{
					type = objectMap.getTile(x,y);
					if (type == Globals.COIN_OBJECT ||
						type == Globals.ANTIGRAV_COIN_OBJECT) 
					{
						coins.add(new Coin(x * 32, y * 32,type));
						_totalCoins++;
					}
					else if (type == Globals.STAR_OBJECT)
					{
						var starSprite:FlxSprite = new FlxSprite();
						starSprite.loadGraphic(objectsPNG,true,false,32,32);
						starSprite.x = x * 32; starSprite.y = y * 32;
						starSprite.frame = Globals.STAR_OBJECT;
						starSprite.acceleration.y = Globals.GRAVITY;
						star.add(starSprite);
					}
					else if (type == Globals.LEFT_RIGHT_MOVER_OBJECT ||
							 type == Globals.UP_DOWN_MOVER_OBJECT)
					{
						movers.add(new Mover(x * 32, y * 32, type));
					}
					else if (type == Globals.PLAYER_OBJECT)
					{
						trace("Found player object at tile " + x + "," + y);
						_start = new FlxPoint(x * 32, (y * 32) + 32);
					}
				}
			}
			
			add(coins);
			add(star);
			add(movers);
		}
		
		
		public override function update():void
		{
			super.update();
		}
		
		
		public function getWidth():uint 
		{	
			return _width;	
		}
		
		public function getHeight():uint 
		{
			return _height;	
		}
		
		public function getStart():FlxPoint
		{
			return _start;
		}

		
		public override function destroy():void
		{	
			super.destroy();
			
//			map.destroy();
//			water.destroy();
//			spikes.destroy();
//			coins.destroy();
//			movers.destroy();
//			star.destroy();
		}
	}
}