package com.snsoft.mapview{
	import com.snsoft.map.WorkSpaceDO;
	import com.snsoft.map.util.MapUtil;
	import com.snsoft.mapview.util.MapViewDraw;
	import com.snsoft.mapview.util.MapViewXMLLoader;
	import com.snsoft.util.HashVector;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
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
		
		private var oldMapView:MapView = null;
		
		private var oldMapLayer:Sprite = null;
		
		private var newMapLayer:Sprite = null;
		
		private var mapView:MapView = null;
		
		private var switchEffectScaleRate:Number = 1;
		
		private var switchEffectTimerRepeatCount:int = 10;
		
		private var switchEffectTimerDelay:int = 10;
		
		private var mapXmlName:String = DEFAULT_XML_NAME;
		
		private var xmlUrl:String = null;
		
		private var mapBackLayer:Sprite = null;
		
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
			mapBackLayer = new Sprite();
			this.addChild(mapBackLayer);
			newMapLayer = new Sprite();
			this.addChild(newMapLayer);
			oldMapLayer = new Sprite();
			this.addChild(oldMapLayer);
			
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
			var wsdo:WorkSpaceDO = MapViewXMLLoader.creatWorkSpaceDO(xml,mapXmlName);
			this.wsdoCatchHv.put(wsdo.wsName,wsdo);
			this.refreshMapView(wsdo);
		}
		
		/**
		 * 
		 * @param wsdo
		 * 
		 */		
		private function refreshMapView(wsdo:WorkSpaceDO):void{
			
			var shape:Shape = MapViewDraw.drawRect(new Point(stage.stageWidth,stage.stageHeight));
			MapUtil.deleteAllChild(mapBackLayer);
			mapBackLayer.addChild(shape);
			shape.alpha = 0.2;
			mapBackLayer.doubleClickEnabled = true;
			mapBackLayer.addEventListener(MouseEvent.DOUBLE_CLICK,handlerMapBackDoubleClick);
			
			if(mapView != null){
				newMapLayer.removeChild(mapView);
				oldMapView = mapView;
				oldMapLayer.addChild(oldMapView);
				switchEffect();
			}
			mapView = new MapView();
			mapView.workSpaceDO = wsdo;
			mapView.addEventListener(MapView.AREA_DOUBLE_CLICK_EVENT,handlerMapAreaDoubleClick);
			newMapLayer.addChild(mapView);
		}
		
		/**
		 * 
		 * @param dobj
		 * 
		 */		
		private function switchEffect():void{
			var backSacleRate:Number = 1 / switchEffectScaleRate;
			backSacleRate = Math.pow(backSacleRate,switchEffectTimerRepeatCount);
			
			newMapLayer.alpha = backSacleRate;
			newMapLayer.scaleX = backSacleRate;
			newMapLayer.scaleY = backSacleRate;
			
			oldMapLayer.alpha = 1;
			oldMapLayer.scaleX = 1;
			oldMapLayer.scaleY = 1;
			
			var timer:Timer = new Timer(switchEffectTimerDelay,switchEffectTimerRepeatCount);
			timer.addEventListener(TimerEvent.TIMER,handlerTimerSwitchEffect);
			timer.start();
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerTimerSwitchEffect(e:Event):void{
			var timer:Timer = e.currentTarget as Timer;
			oldMapLayer.alpha /= switchEffectScaleRate;
			oldMapLayer.scaleX *= switchEffectScaleRate;
			oldMapLayer.scaleY *= switchEffectScaleRate;
			
			newMapLayer.alpha *= switchEffectScaleRate;
			newMapLayer.scaleX *= switchEffectScaleRate;
			newMapLayer.scaleY *= switchEffectScaleRate;
			
			if(timer.currentCount == switchEffectTimerRepeatCount){
				MapUtil.deleteAllChild(oldMapLayer);
				oldMapLayer.alpha = 1;
				oldMapLayer.scaleX = 1;
				oldMapLayer.scaleY = 1;
			}
		}
		
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerMapBackDoubleClick(e:Event):void{
			
			var mxn:String = this.getParentWsName(mapXmlName);
			if(mxn != null){
				switchEffectScaleRate = 0.9;
				mapXmlName = mxn;
				this.drawMapView(mapXmlName);
				
			}
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerMapAreaDoubleClick(e:Event):void{
			var wsName:String = mapView.doubleClickAreaName;
			if(wsName != null){
				switchEffectScaleRate = 1.1;
				mapXmlName = wsName;
				this.drawMapView(mapXmlName);
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
		private function getParentWsName(xmlName:String):String{
			var layer:int = getXmlLayerByName(xmlName);
			if(layer > 1){
				var lastIndex:int = mapXmlName.lastIndexOf(MAP_XML_NAME_SPLIT);
				var pXMLName:String = mapXmlName.substring(0,lastIndex);
				return pXMLName;
			}
			return null;
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