package com.snsoft.tvc2.map{
	import com.snsoft.map.WorkSpaceDO;
	import com.snsoft.mapview.util.MapViewXMLLoader;
	import com.snsoft.tvc2.Business;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	
	[Style(name="myTextFormat", type="Class")]
	
	public class PriceMapArea extends Business{

		private var mapView:MapView;
		
		public function PriceMapArea(mapView:MapView,delayTime:Number = 0,timeLength:Number = 0,timeOut:Number = 0){
			super();
			this.mapView = mapView;
			this.delayTime = delayTime;
			this.timeLength = timeLength;
			this.timeOut = timeOut;
		}
		
		public static const TEXT_FORMAT:String = "myTextFormat";
		
		/**
		 * 
		 */		
		private static var defaultStyles:Object = {
			myTextFormat:new TextFormat("宋体",18,0x000000)
		};
		
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
			this.width = 400;
			this.height = 300;
			super.configUI();	
		}
		
		override protected function draw():void {
			
		}
		
		/**
		 * 
		 * 
		 */		
		override protected function play():void {
			trace("drawMapView");
			this.addChild(mapView);
			mapView.setMapAreaColor("北京",0xff0000);
			mapView.setMapAreaColor("河北",0x00ff00);
			mapView.setMapAreaColor("天津",0xff0000);
			mapView.setMapAreaColor("山东",0x0000ff);
		} 
		
		/**
		 * 
		 * 
		 */		
		override protected function dispatchEventState():void{
			var sign:Boolean = false;
			if(this.isPlayCmp && this.isTimeLen){
				sign = true;
			}
			else if(this.isTimeOut){
				sign = true;
			}
			
			if(sign){
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
	}
}