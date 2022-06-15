package levels
{
	
	import org.flixel.FlxPoint;
	
	public class PrototypeLevel extends Level
	{
		
		[Embed(source = "../../assets/csv/mapCSV_prototype_map.csv", mimeType = "application/octet-stream")] 
		public var prototypeMapCSV:Class;
		[Embed(source = "../../assets/csv/mapCSV_prototype_spikes.csv", mimeType = "application/octet-stream")] 
		public var prototypeSpikesCSV:Class;
		[Embed(source = "../../assets/csv/mapCSV_prototype_water.csv", mimeType = "application/octet-stream")] 
		public var prototypeWaterCSV:Class;
		[Embed(source = "../../assets/csv/mapCSV_prototype_objects.csv", mimeType = "application/octet-stream")] 
		public var prototypeObjectsCSV:Class;
				
		public function PrototypeLevel()
		{
			mapCSV = prototypeMapCSV;
			spikesCSV = prototypeSpikesCSV;
			waterCSV = prototypeWaterCSV;
			objectsCSV = prototypeObjectsCSV;
			
			super();
		}
	}
}