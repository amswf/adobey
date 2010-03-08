package com.snsoft.map.file
{
	import com.snsoft.map.MapAreaDO;
	import com.snsoft.map.WorkSpace;
	import com.snsoft.map.util.HashArray;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;

	public class MapDataFileIO
	{
		public function MapDataFileIO()
		{
		}
		
		public static function save(ws:WorkSpace):void{
			var madoa:HashArray = ws.manager.mapAreaDOAry as HashArray;
			var xml:String = new String();
			xml.concat("<map>");
			xml.concat("</map>");
			if(madoa != null ){
				for(var i:int = 0;i<madoa.length;i++){
					var mado:MapAreaDO = madoa.findByIndex(i) as MapAreaDO;
					var name:String = mado.areaName;
					var placeP:Point = mado.areaNamePlace;
					var pha:HashArray = mado.pointArray;
					
				}
			}
			var file:File = new File("d:/a.xml");
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.WRITE);
			fs.writeUTFBytes("你好");
			fs.writeUTFBytes("你好");
			fs.close();
		}
	}
}