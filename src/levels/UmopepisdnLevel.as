package levels
{
	
	import org.flixel.FlxPoint;
	
	public class UmopepisdnLevel extends Level
	{
		
		[Embed(source = "../../assets/csv/mapCSV_umopepisdn_map.csv", mimeType = "application/octet-stream")] 
		private var _MapCSV:Class;
		[Embed(source = "../../assets/csv/mapCSV_umopepisdn_spikes.csv", mimeType = "application/octet-stream")] 
		private var _SpikesCSV:Class;
		[Embed(source = "../../assets/csv/mapCSV_umopepisdn_water.csv", mimeType = "application/octet-stream")] 
		private var _WaterCSV:Class;
		[Embed(source = "../../assets/csv/mapCSV_umopepisdn_objects.csv", mimeType = "application/octet-stream")] 
		private var _ObjectsCSV:Class;
		
		public function UmopepisdnLevel()
		{
			mapCSV = _MapCSV;
			spikesCSV = _SpikesCSV;
			waterCSV = _WaterCSV;
			objectsCSV = _ObjectsCSV;
						
			super();
		}
	}
}