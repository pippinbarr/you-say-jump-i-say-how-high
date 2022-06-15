package levels
{
	
	import org.flixel.FlxPoint;
	
	public class FlipperLevel extends Level
	{
		
		[Embed(source = "../../assets/csv/mapCSV_flipper_map.csv", mimeType = "application/octet-stream")] 
		private var _MapCSV:Class;
		[Embed(source = "../../assets/csv/mapCSV_flipper_spikes.csv", mimeType = "application/octet-stream")] 
		private var _SpikesCSV:Class;
		[Embed(source = "../../assets/csv/mapCSV_flipper_water.csv", mimeType = "application/octet-stream")] 
		private var _WaterCSV:Class;
		[Embed(source = "../../assets/csv/mapCSV_flipper_objects.csv", mimeType = "application/octet-stream")] 
		private var _ObjectsCSV:Class;
		
		public function FlipperLevel()
		{
			mapCSV = _MapCSV;
			spikesCSV = _SpikesCSV;
			waterCSV = _WaterCSV;
			objectsCSV = _ObjectsCSV;
						
			super();
		}
	}
}