package com.snsoft.map.file{
	import com.snsoft.map.MapAreaDO;
	import com.snsoft.map.MapPointsManager;
	import com.snsoft.map.WorkSpace;
	import com.snsoft.map.WorkSpaceDO;
	import com.snsoft.map.util.HashArray;
	import com.snsoft.util.XMLUtil;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class MapDataFileIO {
		public function MapDataFileIO() {
		}
		
		public static function open(dir:String):void {
			var req:URLRequest = new URLRequest(dir);
			var loader:URLLoader = new URLLoader();
			loader.load(req);
			//loader.addEventListener(Event.COMPLETE,handlerLoaderXML);
			
			/*文件加载方式
			var file:File = new File(dir);
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.READ);
			
			trace(new XML(fs.readUTFBytes(fs.bytesAvailable)));
			*/
		}
		
		
		private static function creatWorkSpaceDO(map:XML):WorkSpaceDO {
			//工作区数据对象
			var wsdo:WorkSpaceDO = new WorkSpaceDO();
			//<map> 
			//map
			
			//<image>
			var image:XML = map.elements("image")[0];
			var mapImage:String = image.text();
			wsdo.image = mapImage;
			
			//工作区地图块数据对象列表
			var madoha:HashArray = new HashArray
			//<areas>
			var areas:XMLList = map.elements("areas").children();
			if (areas != null) {
				for (var i:int = 0; i<areas.length(); i++) {
					
					//<area>
					var area:XML = areas[i];
					if (area != null) {
						//地图块数据对象
						var mado:MapAreaDO = new MapAreaDO();
						
						//<areaName>
						var areaName:XML = area.elements("areaName")[0];
						var mapAreaName:String = areaName.text();
						mado.areaName = mapAreaName;
						
						//<areaNamePoint>
						var areaNamePoint:XML = area.elements("areaNamePoint")[0];
						if (areaNamePoint != null) {
							var apx:XML = areaNamePoint.elements("x")[0];
							var apy:XML = areaNamePoint.elements("y")[0];
							var mapap:Point = new Point();
							if (apx != null && apy != null) {
								if (apx.text() != null && apy.text() != null) {
									mapap = new Point(Number(apx.text()),Number(apy.text()));
								}
							}
							mado.areaNamePlace = mapap;
						}
						
						//地图块的点列
						var pha:HashArray = new HashArray();
						//<areaPoints>
						var areaPoints:XML = area.elements("areaPoints")[0];
						if (areaPoints != null) {
							var areaPointsChilds:XMLList = areaPoints.children();
							for (var j:int = 0; j<areaPointsChilds.length(); j++) {
								var areaPoint:XML = areaPointsChilds[i];
								if (areaPoint != null) {
									var px:XML = areaPoint.elements("x")[0];
									var py:XML = areaPoint.elements("y")[0];
									var p:Point = new Point();
									if (px != null && py != null) {
										if (px.text() != null && py.text() != null) {
											p = new Point(Number(px.text()),Number(py.text()));
											var name:String = MapPointsManager.createPointHashName(p);
											pha.put(name,p);
										}
									}
								}
							}
						}
						mado.pointArray = pha;
						var haName:String = MapPointsManager.creatHashArrayHashName(pha);
						madoha.put(haName,mado);
					}
				}
			}
			wsdo.mapAreaDOHashArray = madoha;
			return wsdo;
		}
		
		
		public static function save(ws:WorkSpace,filePath:String):void {
			var xml:String = creatXML(ws);
			xml = XMLUtil.formatXML(new XML(xml));
			var file:File = new File(filePath);
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.WRITE);
			
			fs.writeUTFBytes(xml);
			fs.close();
		}
		
		private static function creatXML(ws:WorkSpace):String {
			var madoa:HashArray = ws.manager.mapAreaDOAry as HashArray;
			var image:String = "";
			if (ws.mapImage != null && ws.mapImage.imageUrl != null) {
				image = ws.mapImage.imageUrl;
			}
			var xml:String = new String();
			xml = xml.concat("<map>");
			
			xml = xml.concat("<image>");
			xml = xml.concat(image);
			xml = xml.concat("</image>");
			
			xml = xml.concat("<areas>");
			if (madoa != null) {
				for (var i:int = 0; i<madoa.length; i++) {
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
					if (pha != null) {
						for (var j:int = 0; j < pha.length; j++) {
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