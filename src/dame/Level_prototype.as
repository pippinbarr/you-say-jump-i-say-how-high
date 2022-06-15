//Code generated with DAME. http://www.dambots.com

package com
{
	import org.flixel.*;
	import flash.utils.Dictionary;
	public class Level_prototype extends BaseLevel
	{
		//Embedded media...
		[Embed(source="../../assets/mapCSV_prototype_map.csv", mimeType="application/octet-stream")] public var CSV_map:Class;
		[Embed(source="../../assets/maptiles.png")] public var Img_map:Class;
		[Embed(source="../../assets/mapCSV_prototype_water.csv", mimeType="application/octet-stream")] public var CSV_water:Class;
		[Embed(source="../../assets/maptiles.png")] public var Img_water:Class;
		[Embed(source="../../assets/mapCSV_prototype_objects.csv", mimeType="application/octet-stream")] public var CSV_objects:Class;
		[Embed(source="../../assets/objects.png")] public var Img_objects:Class;
		[Embed(source="../../assets/mapCSV_prototype_spikes.csv", mimeType="application/octet-stream")] public var CSV_spikes:Class;
		[Embed(source="../../assets/maptiles.png")] public var Img_spikes:Class;

		//Tilemaps
		public var layermap:FlxTilemap;
		public var layerwater:FlxTilemap;
		public var layerobjects:FlxTilemap;
		public var layerspikes:FlxTilemap;

		//Properties


		public function Level_prototype(addToStage:Boolean = true, onAddCallback:Function = null, parentObject:Object = null)
		{
			// Generate maps.
			var properties:Array = [];
			var tileProperties:Dictionary = new Dictionary;

			properties = generateProperties( null );
			layermap = addTilemap( CSV_map, Img_map, 0.000, 0.000, 8, 8, 1.000, 1.000, false, 9, 1, properties, onAddCallback );
			properties = generateProperties( null );
			layerwater = addTilemap( CSV_water, Img_water, 0.000, 0.000, 8, 8, 1.000, 1.000, false, 9, 1, properties, onAddCallback );
			properties = generateProperties( null );
			layerobjects = addTilemap( CSV_objects, Img_objects, 0.000, 0.000, 16, 16, 1.000, 1.000, false, 1, 1, properties, onAddCallback );
			properties = generateProperties( null );
			layerspikes = addTilemap( CSV_spikes, Img_spikes, 0.000, 0.000, 8, 8, 1.000, 1.000, false, 1, 1, properties, onAddCallback );

			//Add layers to the master group in correct order.
			masterLayer.add(layermap);
			masterLayer.add(layerwater);
			masterLayer.add(layerobjects);
			masterLayer.add(layerspikes);

			if ( addToStage )
				createObjects(onAddCallback, parentObject);

			boundsMinX = 0;
			boundsMinY = 0;
			boundsMaxX = 1600;
			boundsMaxY = 1200;
			bgColor = 0xffcccccc;
		}

		override public function createObjects(onAddCallback:Function = null, parentObject:Object = null):void
		{
			generateObjectLinks(onAddCallback);
			if ( parentObject != null )
				parentObject.add(masterLayer);
			else
				FlxG.state.add(masterLayer);
		}

		public function generateObjectLinks(onAddCallback:Function = null):void
		{
		}

	}
}
