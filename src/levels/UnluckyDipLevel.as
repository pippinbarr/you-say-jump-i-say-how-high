package levels
{
	
	import org.flixel.FlxPoint;
	
	public class UnluckyDipLevel extends Level
	{
		[Embed(source = "../../assets/csv/mapCSV_unluckydip_map.csv", mimeType = "application/octet-stream")] 
		private var _MapCSV:Class;
		[Embed(source = "../../assets/csv/mapCSV_unluckydip_spikes.csv", mimeType = "application/octet-stream")] 
		private var _SpikesCSV:Class;
		[Embed(source = "../../assets/csv/mapCSV_unluckydip_water.csv", mimeType = "application/octet-stream")] 
		private var _WaterCSV:Class;
		[Embed(source = "../../assets/csv/mapCSV_unluckydip_objects.csv", mimeType = "application/octet-stream")] 
		private var _ObjectsCSV:Class;
		
		public function UnluckyDipLevel()
		{
			mapCSV = _MapCSV;
			spikesCSV = _SpikesCSV;
			waterCSV = _WaterCSV;
			objectsCSV = _ObjectsCSV;
						
			super();
		}
	}
}