package levels
{
	
	import org.flixel.FlxPoint;
	
	public class EasyDoesItLevel extends Level
	{
		
		[Embed(source = "../../assets/csv/mapCSV_easydoesit_map.csv", mimeType = "application/octet-stream")] 
		private var _MapCSV:Class;
		[Embed(source = "../../assets/csv/mapCSV_easydoesit_spikes.csv", mimeType = "application/octet-stream")] 
		private var _SpikesCSV:Class;
		[Embed(source = "../../assets/csv/mapCSV_easydoesit_water.csv", mimeType = "application/octet-stream")] 
		private var _WaterCSV:Class;
		[Embed(source = "../../assets/csv/mapCSV_easydoesit_objects.csv", mimeType = "application/octet-stream")] 
		private var _ObjectsCSV:Class;
		
		public function EasyDoesItLevel()
		{
			mapCSV = _MapCSV;
			spikesCSV = _SpikesCSV;
			waterCSV = _WaterCSV;
			objectsCSV = _ObjectsCSV;
						
			super();
		}
	}
}