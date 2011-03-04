package com.snsoft.mapviewpro.swb{
	import com.snsoft.mapview.Config;
	import com.snsoft.mapview.dataObj.WorkSpaceDO;
	import com.snsoft.mapview.util.MapViewDraw;
	import com.snsoft.mapview.util.MapViewXMLLoader;
	import com.snsoft.util.HashVector;
	import com.snsoft.util.PointUtil;
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.xmldom.XMLFastConfig;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	[Style(name="viewDagSkin", type="Class")]
	
	[Style(name="viewDagLimitSkin", type="Class")]
	
	/**
	 * 科技进村3的主页flash，把原来的换成地图点击进入，当前对应龙口项目。 
	 * @author Administrator
	 * 
	 */	
	public class MapMainSWB extends UIComponent{
		
		public static var WINDOW:String;
		
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
		
		private var oldMapView:MapViewSWB = null;
		
		
		private var mapView:MapViewSWB = null;
		
		private var switchEffectScaleRate:Number = 1;
		
		private var switchEffectTimerRepeatCount:int = 5;
		
		private var switchEffectTimerDelay:int = 10;
		
		private var mapXmlName:String = DEFAULT_XML_NAME;
		
		private var lastMapXmlName:String = DEFAULT_XML_NAME;
		
		private var mapXmlUrl:String = null;
		
		private var configXmlUrl:String = null;
		
		private var mapViewLayer:MovieClip;
		
		private var waitTimer:Timer;
		
		private var back:MovieClip;
		
		
		public function MapMainSWB()
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
			
			back = SkinsUtil.createSkinByName("CplxMouseMoveLimit");
			this.addChild(back);
			
			mapViewLayer = new MovieClip();
			this.addChild(mapViewLayer);
			
			waitTimer = new Timer(20,1);
			waitTimer.addEventListener(TimerEvent.TIMER_COMPLETE,handlerTimerCmp);
			
			configXmlUrl = "viewcfg.xml";			
			XMLFastConfig.instance(configXmlUrl,handlerConfigLoadComplete);
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
		
		/**
		 * 
		 * @param wsdo
		 * 
		 */		
		private function refreshMapView(wsdo:WorkSpaceDO):void{
			
			var shape:Shape = MapViewDraw.drawRect(new Point(this.width,this.height));
			PointUtil.deleteAllChild(this.mapViewLayer);
			if(this.mapView != null){
				this.removeChild(this.mapView);
			}
			this.mapView = new MapViewSWB();
			this.mapView.workSpaceDO = wsdo;
			this.mapView.drawNow();
			this.mapViewLayer.addChild(this.mapView);	
			

			setMapViewLayerScale();
			this.addEventListener(MouseEvent.MOUSE_MOVE,handlerStageMouseMove);
			this.addEventListener(MouseEvent.MOUSE_OVER,handlerMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT,handlerMouseOut);
			
			stage.addEventListener(Event.ENTER_FRAME,handlerStageEnterframe);
			stage.addEventListener(Event.RESIZE,handlerStageResize);
		}
		
		private function handlerStageEnterframe(e:Event):void{
			stage.removeEventListener(Event.ENTER_FRAME,handlerStageEnterframe);
			setBackSize();
		}
		
		private function handlerStageResize(e:Event):void{
			setBackSize();
		}
		
		private function setBackSize():void{
			back.width = stage.stageWidth;
			back.height = stage.stageHeight;
		}
		
		
		private function handlerTimerCmp(e:Event):void{
			mapView.x = 0;
			mapView.y = 0;
			setMapViewLayerScale();
		}
		
		
		
		private function handlerMouseOut(e:Event):void{
			waitTimer.stop();
			waitTimer.start();
		}
		
		
		private function handlerMouseOver(e:Event):void{
			waitTimer.stop();
			setMapViewLayerScale(1);
		}
		
		
		private function setMapViewLayerScale(scale:Number = NaN):void{
			if(isNaN(scale)){
				var scaleX:Number = stage.stageWidth /mapViewLayer.width; 
				var scaleY:Number = stage.stageHeight /mapViewLayer.height; 
				scale = scaleX < scaleY? scaleX : scaleY;
				if(scale > 1){
					scale = 1;
				}
			}
			mapViewLayer.scaleX = scale;
			mapViewLayer.scaleY = scale;
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
			var window:String = XMLFastConfig.getConfig("window");
			if(window != null && window.length > 0){
				WINDOW = window;
			}
			else{
				WINDOW = "_self";
			}
			
		}
		
		
		private function handlerStageMouseMove(e:Event):void{
			
			var scaleX:Number = mapViewLayer.width / stage.stageWidth; 
			var scaleY:Number =  mapViewLayer.height / stage.stageHeight; 
			mapView.x = - mouseX * scaleX + 100;
			mapView.y = - mouseY * scaleY + 100;
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