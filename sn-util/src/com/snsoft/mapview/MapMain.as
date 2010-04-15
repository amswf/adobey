package com.snsoft.mapview{
	import com.snsoft.map.WorkSpaceDO;
	import com.snsoft.map.util.MapUtil;
	import com.snsoft.mapview.util.MapViewXMLLoader;
	import com.snsoft.util.HashVector;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class MapMain extends UIComponent{
		
		//XML文件文件根目录
		private var _baseUrl:String = "flash_map";
		
		//XML文件基本名称
		private static const BASE_XML_NAME:String = "ws";
		
		//路径分隔符
		private static const URL_SEPARATOR:String = "/";
		
		//地图文件名数字编号间隔符
		private static const MAP_XML_NAME_SPLIT:String = "_";
		
		//地图存储文件分层路径名 1x / 2x / 3x
		public static const MAP_XML_LAYER_BASE_NAME:String = "x";
		
		//地图存储文件扩展名 ws_1_2.xml
		public static const MAP_XML_BASE_EXT_NAME:String = ".xml";
		
		// ws_1.xml
		private static const DEFAULT_XML_NAME:String = BASE_XML_NAME + MAP_XML_NAME_SPLIT + "1";
	
		private var wsdoCatchHv:HashVector = new HashVector();
		
		private var mapView:MapView = null;
		
		private var mapXmlName:String = DEFAULT_XML_NAME;
		
		private var xmlUrl:String = null;
		
		public function MapMain()
		{
			super();
		}
			
		/**
		 *  
		 * 
		 */				
		override protected function configUI():void{
			this.invalidate(InvalidationType.ALL,true);
			this.invalidate(InvalidationType.SIZE,true);
			super.configUI();
		}
		
		/**
		 * 
		 * 
		 */		
		override protected function draw():void{
			this.drawMapView(mapXmlName);
		}
		
		private function drawMapView(mapXmlName:String):void{
			var wsdo:WorkSpaceDO = wsdoCatchHv.findByName(mapXmlName) as WorkSpaceDO;
			if(wsdo != null){
				this.refreshMapView(wsdo);
			}
			else{
				var nx:String = this.getNxName(mapXmlName);
				xmlUrl = baseUrl + URL_SEPARATOR + nx + URL_SEPARATOR + mapXmlName + MAP_XML_BASE_EXT_NAME;
				var request:URLRequest = new URLRequest(xmlUrl);	
				var loader:URLLoader = new URLLoader();
				loader.load(request);
				loader.addEventListener(Event.COMPLETE,handlerLoadComplete);
				loader.addEventListener(IOErrorEvent.IO_ERROR,handlerLoadIOError);
			}
		}
		
		private function handlerLoadIOError(e:Event):void{
			var loader:URLLoader = e.currentTarget as URLLoader;
			trace("地址错误：",xmlUrl);
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerLoadComplete(e:Event):void{
			var loader:URLLoader = e.currentTarget as URLLoader;
			var xml:XML = new XML(loader.data);
			var wsdo:WorkSpaceDO = MapViewXMLLoader.creatWorkSpaceDO(xml,DEFAULT_XML_NAME);
			this.wsdoCatchHv.put(wsdo.wsName,wsdo);
			this.refreshMapView(wsdo);
		}
		
		/**
		 * 
		 * @param wsdo
		 * 
		 */		
		private function refreshMapView(wsdo:WorkSpaceDO):void{
			if(mapView != null){
				this.removeChild(mapView);
			}
			mapView = new MapView();
			mapView.workSpaceDO = wsdo;
			mapView.addEventListener(MapView.AREA_DOUBLE_CLICK_EVENT,handlerMapAreaDoubleClick);
			this.addChild(mapView);
		}
		
		private function handlerMapAreaDoubleClick(e:Event):void{
			var wsName:String = mapView.doubleClickAreaName;
			if(wsName != null){
				this.drawMapView(wsName);
			}
		}
		
		/**
		 * 
		 * @param xmlName
		 * @return 
		 * 
		 */		
		private function getNxName(xmlName:String):String{
			return getXmlLayerByName(xmlName) + MAP_XML_LAYER_BASE_NAME;
		}
		
		/**
		 * 
		 * @param xmlName
		 * @return 
		 * 
		 */		
		private function getXmlLayerByName(xmlName:String):int{
			var num:int = 0;
			if(xmlName != null && xmlName.length > 0){
				for(var i:int = 0;i<xmlName.length;i++){
					if(xmlName.charAt(i) == MAP_XML_NAME_SPLIT){
						num ++;
					}
				}
			}
			return num;
		}

		public function get baseUrl():String
		{
			return _baseUrl;
		}

		public function set baseUrl(value:String):void
		{
			_baseUrl = value;
		}

	}
}