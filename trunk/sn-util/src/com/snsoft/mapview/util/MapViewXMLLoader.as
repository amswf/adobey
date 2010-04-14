package com.snsoft.mapview.util{
	import com.snsoft.map.MapAreaDO;
	import com.snsoft.map.MapPointsManager;
	import com.snsoft.map.WorkSpaceDO;
	import com.snsoft.util.HashVector;
	
	import flash.geom.Point;

	public class MapViewXMLLoader{
		
		public function MapViewXMLLoader(){
		
		}
		
		public static function creatWorkSpaceDO(xml:XML,wsName:String):WorkSpaceDO{
			var wsdo:WorkSpaceDO = new WorkSpaceDO();
			//<map> 
			var map:XML = xml;
			
			//<image>
			var image:XML = map.elements("image")[0];
			var mapImage:String = image.text();
			wsdo.image = mapImage;
			wsdo.wsName = wsName;
			
			//工作区地图块数据对象列表
			var madoha:HashVector = new HashVector();
			//<areas>
			var areas:XMLList = map.elements("areas").children();
			if (areas != null) {
				for (var i:int = 0; i<areas.length(); i++) {
					
					//<area>
					var area:XML = areas[i];
					if (area != null) {
						//地图块数据对象
						var mado:MapAreaDO = new MapAreaDO();
						
						//<areaId>
						var areaId:XML = area.elements("areaId")[0];
						var mapAreaId:String = areaId.text();
						mado.areaId = mapAreaId;
						
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
						var pha:HashVector = new HashVector();
						//<areaPoints>
						var areaPoints:XML = area.elements("areaPoints")[0];
						if (areaPoints != null) {
							var areaPointsChilds:XMLList = areaPoints.children();
							for (var j:int = 0; j<areaPointsChilds.length(); j++) {
								var areaPoint:XML = areaPointsChilds[j];
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
	}
}