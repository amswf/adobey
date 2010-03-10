package com.snsoft.map.file
{
	import com.snsoft.map.MapAreaDO;
	import com.snsoft.map.WorkSpace;
	import com.snsoft.map.util.HashArray;
	import com.snsoft.util.XMLUtil;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;

	public class MapDataFileIO
	{
		public function MapDataFileIO()
		{
		}
		
		public static function save(ws:WorkSpace,filePath:String):void{
			var xml:String = creatXML(ws);
			xml = XMLUtil.formatXML(new XML(xml));
			var file:File = new File(filePath);
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.WRITE);
			
			fs.writeUTFBytes(xml);
			fs.close();
		}
		
		private static function creatXML(ws:WorkSpace):String{
			var madoa:HashArray = ws.manager.mapAreaDOAry as HashArray;
			var image:String = "";
			if(ws.mapImage != null && ws.mapImage.imageUrl != null){
				image = ws.mapImage.imageUrl;
			}
			var xml:String = new String();
			xml = xml.concat("<map>");
			
			xml = xml.concat("<image>");
			xml = xml.concat(image);			
			xml = xml.concat("</image>");
			
			xml = xml.concat("<areas>");
			if(madoa != null ){
				for(var i:int = 0;i<madoa.length;i++){
					var mado:MapAreaDO = madoa.findByIndex(i) as MapAreaDO;
					var name:String = mado.areaName;
					var placeP:Point = mado.areaNamePlace;
					var pha:HashArray = mado.pointArray;
					xml = xml.concat("<area>");
					
					xml = xml.concat("<areaName>");
					xml = xml.concat(name);
					xml = xml.concat("</areaName>");
					
					xml = xml.concat("<areaNamePoint>");
					
					xml = xml.concat("<x>");
					xml = xml.concat(placeP.x);
					xml = xml.concat("</x>");
					
					xml = xml.concat("<y>");
					xml = xml.concat(placeP.y);
					xml = xml.concat("</y>");
					
					xml = xml.concat("</areaNamePoint>");
					
					xml = xml.concat("<areaPoints>");
					if(pha != null){
						for(var j:int = 0;j < pha.length;j++){
							var ap:Point = pha.findByIndex(j) as Point;
							xml = xml.concat("<point>");
							
							xml = xml.concat("<x>");
							xml = xml.concat(ap.x);
							xml = xml.concat("</x>");
							
							xml = xml.concat("<y>");
							xml = xml.concat(ap.y);
							xml = xml.concat("</y>");
							
							xml = xml.concat("</point>");
						}
					}
					
					xml = xml.concat("</areaPoints>");
					
					xml = xml.concat("</area>");
				}
			}
			xml = xml.concat("</areas>");
			xml = xml.concat("</map>");
			return xml;
		}
	}
}