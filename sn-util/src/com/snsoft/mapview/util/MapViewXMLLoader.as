package com.snsoft.mapview.util{
	import com.snsoft.map.MapAreaDO;
	import com.snsoft.map.MapPointsManager;
	import com.snsoft.map.WorkSpaceDO;
	import com.snsoft.util.HashVector;
	import com.snsoft.xmldom.Node;
	import com.snsoft.xmldom.NodeList;
	import com.snsoft.xmldom.XMLDom;
	
	import flash.geom.Point;
	
	public class MapViewXMLLoader{
		
		public function MapViewXMLLoader(){
			
		}
		
		public static function creatWorkSpaceDO(xml:XML,wsName:String):WorkSpaceDO{
			var wsdo:WorkSpaceDO = new WorkSpaceDO();
			//<map> 
			var map:XML = xml;
			
			var xmldom:XMLDom = new XMLDom(map);
			var mapNode:Node = xmldom.parse();
			
			//<image>
			var mapImage:String = mapNode.getAttributeByName("image");
			wsdo.image = mapImage;
			wsdo.wsName = wsName;
			
			//工作区地图块数据对象列表
			var madoha:HashVector = new HashVector  ;
			//<areas>
			var areasNode:Node = mapNode.getNodeListFirstNode("areas");
			var areaList:NodeList = areasNode.getNodeList("area");
			if (areaList != null) {
				for (var i:int = 0; i<areaList.length(); i++) {
					
					//<area>
					var areaNode:Node = areaList.getNode(i);
					if (areaNode != null) {
						//地图块数据对象
						var mado:MapAreaDO = new MapAreaDO();
						
						//<areaId>
						mado.areaId = areaNode.getAttributeByName("areaId");
						
						//<areaName> 
						mado.areaName = areaNode.getAttributeByName("areaName");
						
						//<areaCode>
						mado.areaCode = areaNode.getAttributeByName("areaCode");
						
						//<areaUrl>
						mado.areaUrl = areaNode.getAttributeByName("areaUrl");
						
						//<areaNamePoint>
						var areaNamePointNode:Node = areaNode.getNodeListFirstNode("areaNamePoint");
						if (areaNamePointNode != null) {
							var apx:String = areaNamePointNode.getAttributeByName("x");
							var apy:String = areaNamePointNode.getAttributeByName("y");
							var mapap:Point = new Point();
							if (apx != null && apy != null) {
								mapap = new Point(Number(apx),Number(apy));
							}
							mado.areaNamePlace = mapap;
						}
						
						//地图块的点列
						var pha:HashVector = new HashVector();
						//<areaPoints>			
						var areaPointsNode:Node = areaNode.getNodeListFirstNode("areaPoints");
						if (areaPointsNode != null) {
							var areaPointList:NodeList = areaPointsNode.getNodeList("point");
							for (var j:int = 0; j<areaPointList.length(); j++) {
								var areaPointNode:Node = areaPointList.getNode(j);
								if (areaPointNode != null) {
									var px:String = areaPointNode.getAttributeByName("x");
									var py:String = areaPointNode.getAttributeByName("y");
									var p:Point = new Point();
									if (px != null && py != null) {
										p = new Point(Number(px),Number(py));
										var name:String = MapPointsManager.createPointHashName(p);
										pha.push(p,name);
										
									}
								}
							}
						}
						mado.pointArray = pha;
						var haName:String = MapPointsManager.creatHashArrayHashName(pha);
						madoha.push(mado,haName);
					}
				}
			}
			wsdo.mapAreaDOHashArray = madoha;
			return wsdo;
		}
	}
}