package com.snsoft.mapview{
	import com.snsoft.map.WorkSpaceDO;
	import com.snsoft.map.util.MapUtil;
	import com.snsoft.mapview.util.MapViewDraw;
	import com.snsoft.mapview.util.MapViewXMLLoader;
	import com.snsoft.util.HashVector;
	import com.snsoft.util.complexEvent.CplxMouseDrag;
	import com.snsoft.xmldom.Node;
	import com.snsoft.xmldom.NodeList;
	import com.snsoft.xmldom.XMLDom;
	import com.snsoft.xmldom.XMLFastConfig;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	[Style(name="viewDagSkin", type="Class")]
	
	[Style(name="viewDagLimitSkin", type="Class")]
	
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
		
		private var viewDrag:DisplayObject = null;
		
		private var viewDragLimit:DisplayObject = null;
		
		private var mapView:MapView = null;
		
		private var switchEffectScaleRate:Number = 1;
		
		private var switchEffectTimerRepeatCount:int = 5;
		
		private var switchEffectTimerDelay:int = 10;
		
		private var mapXmlName:String = DEFAULT_XML_NAME;
		
		private var lastMapXmlName:String = DEFAULT_XML_NAME;
		
		private var mapXmlUrl:String = null;
		
		private var configXmlUrl:String = null;
		
		private var mapBackLayer:Sprite = null;
		
		private var newMapMaskLayer:Sprite = null;
		
		private var oldMapMaskLayer:Sprite = null;
		
		public function MapMain()
		{
			super();
		}
		
		/**
		 * 
		 */		
		private static var defaultStyles:Object = {viewDagSkin:"MapViewDrag_skin",viewDagLimitSkin:"MapViewDragLimit_skin"};
		
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public static function getStyleDefinition():Object { 
			return UIComponent.mergeStyles(UIComponent.getStyleDefinition(), defaultStyles);
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
			this.mapBackLayer = new Sprite();
			this.addChild(mapBackLayer);
			
			this.newMapMaskLayer = new Sprite();
			this.addChild(newMapMaskLayer);
			
			var newMapMaskShape:Shape = MapViewDraw.drawRect(new Point(this.width,this.height));
			MapUtil.deleteAllChild(this.newMapMaskLayer);
			this.newMapMaskLayer.addChild(newMapMaskShape);
			
			this.newMapLayer = new Sprite();
			this.addChild(newMapLayer);
			this.newMapLayer.mask = this.newMapMaskLayer;
			
			this.oldMapMaskLayer = new Sprite();
			this.addChild(oldMapMaskLayer);
			
			var oldMapMaskShape:Shape = MapViewDraw.drawRect(new Point(this.width,this.height));
			MapUtil.deleteAllChild(this.oldMapMaskLayer);
			this.oldMapMaskLayer.addChild(oldMapMaskShape);
			
			this.oldMapLayer = new Sprite();
			this.addChild(oldMapLayer);
			this.oldMapLayer.mask = this.oldMapMaskLayer;
			
			this.viewDragLimit = getDisplayObjectInstance(getStyleValue("viewDagLimitSkin"));
			var viewPlace:Point = MapUtil.subSize(this,this.viewDragLimit);
			viewPlace.x = 0;
			MapUtil.setSpritePlace(viewDragLimit,viewPlace);
			this.addChild(this.viewDragLimit);
			
			this.viewDrag = getDisplayObjectInstance(getStyleValue("viewDagSkin"));
			MapUtil.setSpritePlace(viewDrag,viewPlace);
			this.addChild(this.viewDrag);
			
			configXmlUrl = "viewcfg.xml";			
			XMLFastConfig.instance(configXmlUrl,handlerConfigLoadComplete);
		}
		
		private function handlerConfigLoadIOError(e:Event):void{
			trace("地址错误：",configXmlUrl);
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerConfigLoadComplete(e:Event):void{
			
			parseConfig();
			this.drawMapView(this.mapXmlName);
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function parseConfig():void{
			var clickType:String = XMLFastConfig.getConfig("clickType");
			Config.setAreaMouseEventType(clickType);
		}
		
		/**
		 * 
		 * @param mapXmlName
		 * 
		 */		
		private function drawMapView(mapXmlName:String):void{
			this.lastMapXmlName = this.mapXmlName;
			this.mapXmlName = mapXmlName;
			var wsdo:WorkSpaceDO = wsdoCatchHv.findByName(mapXmlName) as WorkSpaceDO;
			if(wsdo != null){
				this.refreshMapView(wsdo);
			}
			else{
				var nx:String = this.getNxName(mapXmlName);
				mapXmlUrl = baseUrl + URL_SEPARATOR + nx + URL_SEPARATOR + mapXmlName + MAP_XML_BASE_EXT_NAME;
				var request:URLRequest = new URLRequest(mapXmlUrl);	
				var loader:URLLoader = new URLLoader();
				loader.load(request);
				loader.addEventListener(Event.COMPLETE,handlerLoadComplete);
				loader.addEventListener(IOErrorEvent.IO_ERROR,handlerLoadIOError);
			}
		}
		
		private function handlerLoadIOError(e:Event):void{
			var loader:URLLoader = e.currentTarget as URLLoader;
			this.mapXmlName = this.lastMapXmlName;
			trace("地址错误：",mapXmlUrl);
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerLoadComplete(e:Event):void{
			var loader:URLLoader = e.currentTarget as URLLoader;
			var xml:XML = new XML(loader.data);
			var wsdo:WorkSpaceDO = MapViewXMLLoader.creatWorkSpaceDO(xml,this.mapXmlName);
			this.wsdoCatchHv.push(wsdo,wsdo.wsName);
			this.refreshMapView(wsdo);
		}
		
		/**
		 * 
		 * @param wsdo
		 * 
		 */		
		private function refreshMapView(wsdo:WorkSpaceDO):void{
			
			var shape:Shape = MapViewDraw.drawRect(new Point(this.width,this.height));
			MapUtil.deleteAllChild(this.mapBackLayer);
			this.mapBackLayer.addChild(shape);
			shape.alpha = 0.2;
			if(Config.AREA_MOUSE_EVENT_TYPE_DOUBLE_CLICK == Config.areaMouseEventType){
				this.mapBackLayer.doubleClickEnabled = true;
				this.mapBackLayer.addEventListener(MouseEvent.DOUBLE_CLICK,handlerMapBackDoubleClick);
			}
			
			if(this.mapView != null){
				newMapLayer.removeChild(this.mapView);
				this.oldMapView = this.mapView;
				this.oldMapLayer.addChild(this.oldMapView);
				
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
			this.mapView = new MapView();
			this.mapView.workSpaceDO = wsdo;
			this.mapView.drawNow();
			
			this.mapView.addEventListener(MapView.AREA_DOUBLE_CLICK_EVENT,handlerMapAreaDoubleClick);
			newMapLayer.addChild(this.mapView);	
			
			var sma:CplxMouseDrag = new CplxMouseDrag();
			var mapViewRect:Rectangle = this.mapView.backMaskRec;
			var vdlp:Point = MapUtil.getSpriteSize(this.viewDragLimit);
			var dragAlterRect:Rectangle = new Rectangle(vdlp.x,vdlp.y,-vdlp.x,-vdlp.y);
			
			MapUtil.setSpriteSize(mapView,mapViewRect.bottomRight);
			sma.addEvents(this.mapView,this.mapBackLayer,this.viewDrag,this.viewDragLimit,mapViewRect);
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
			
			var mxn:String = this.getParentWsName(this.mapXmlName);
			if(mxn != null){
				switchEffectScaleRate = 0.9;
				this.drawMapView(mxn);
				
			}
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerMapAreaDoubleClick(e:Event):void{
			if(mapView.doubleClickAreaView != null && mapView.doubleClickAreaView.mapAreaDO != null){
				var wsName:String = mapView.doubleClickAreaView.mapAreaDO.areaId;
				if(wsName != null){
					switchEffectScaleRate = 1.1;
					this.drawMapView(wsName);
				}
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
				var lastIndex:int = xmlName.lastIndexOf(MAP_XML_NAME_SPLIT);
				var pXMLName:String = xmlName.substring(0,lastIndex);
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