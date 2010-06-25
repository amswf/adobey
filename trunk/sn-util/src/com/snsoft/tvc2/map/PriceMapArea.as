package com.snsoft.tvc2.map{
	import com.snsoft.map.WorkSpaceDO;
	import com.snsoft.mapview.util.MapViewXMLLoader;
	import com.snsoft.tvc2.Business;
	import com.snsoft.tvc2.dataObject.DataDO;
	import com.snsoft.tvc2.dataObject.ListDO;
	import com.snsoft.tvc2.dataObject.TextPointDO;
	import com.snsoft.tvc2.text.EffectText;
	import com.snsoft.tvc2.util.StringUtil;
	import com.snsoft.util.ColorTransformUtil;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	[Style(name="cutline_default_skin", type="Class")]
	
	[Style(name="myTextFormat", type="Class")]
	
	public class PriceMapArea extends Business{
		
		private var mapView:MapView;
		
		private var dataDO:DataDO;
		
		private var listDOV:Vector.<ListDO>;
		
		private var listCount:int = 0;
		
		public function PriceMapArea(dataDO:DataDO,mapView:MapView,delayTime:Number = 0,timeLength:Number = 0,timeOut:Number = 0){
			super();
			this.dataDO = dataDO;
			this.mapView = mapView;
			this.delayTime = delayTime;
			this.timeLength = timeLength;
			this.timeOut = timeOut;
		}
		
		public static const CUTLINE_DEFAULT_SKIN:String = "cutline_default_skin";
		
		public static const TEXT_FORMAT:String = "myTextFormat";
		
		/**
		 * 
		 */		
		private static var defaultStyles:Object = {
			cutline_default_skin:"Cutline_default_skin",
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
			this.listDOV = dataDO.data;
			this.listCount = 0;
			var cutLine:Sprite = new Sprite();
			var rect:Rectangle = mapView.getRect(this);
			cutLine.x = rect.x + rect.width;
			cutLine.y = rect.y + rect.height;
			this.addChild(cutLine);
			
			for(var i:int = 0;i< listDOV.length;i++){
				var color:uint = 0x000000;
				if(i == 0){
					color = 0x000099;
				}
				else if(i == 1){
					color = 0x999900;
				}
				else if(i == 2){
					color = 0x009900; 
				}
				else if(i == 3){
					color = 0x990000; 
				}
				var listDO:ListDO = listDOV[i];
				
				
				var cutLineMC:MovieClip = getDisplayObjectInstance(getStyleValue(CUTLINE_DEFAULT_SKIN)) as MovieClip;
				cutLineMC.y = - cutLineMC.height - cutLine.height;
				ColorTransformUtil.setColor(cutLineMC,color);
				cutLine.addChild(cutLineMC);
				var name:String = listDO.name;
				var tft:TextFormat = getStyleValue(TEXT_FORMAT) as TextFormat;
				tft.color = color;
				var tfd:TextField = EffectText.creatShadowTextField(name,tft);
				tfd.y = - tfd.height - cutLine.height;
				cutLine.addChild(tfd);
			}
			playAreaView();
			
		} 
		
		private function playAreaView():void{
			if(listDOV != null && listCount >= 0 && listCount < listDOV.length){
				var index:int = listCount;
				setAreaColor(index,1);
				var timer:Timer = new Timer(2000,1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE,handlerTimer);
				timer.start();
			}
			else{
				this.isPlayCmp = true;
				dispatchEventState();
			}
		}
		
		private function setAreaColor(index:int,alpha:Number):void{
			var listDO:ListDO = listDOV[index];
			var tpdoHv:Vector.<TextPointDO> = listDO.listHv;
			var color:uint = 0x000000;
			if(index == 0){
				color = 0x000099;
			}
			else if(index == 1){
				color = 0x999900;
			}
			else if(index == 2){
				color = 0x009900; 
			}
			else if(index == 3){
				color = 0x990000; 
			}
			
			for(var i:int =0;i<tpdoHv.length;i++){
				var tpdo:TextPointDO = tpdoHv[i];
				if(tpdo != null){
					var name:String = tpdo.name;
					if(StringUtil.isEffective(name)){
						mapView.setMapAreaColor(name,color,alpha);
					}
				}
			}
		}
		
		private function handlerTimer(e:Event):void{
			var timer:Timer = new Timer(200,7);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER,handlerListSmallTimer);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,handlerListSmallTimerCMP);
		}
		
		private function handlerListSmallTimer(e:Event):void{
			var timer:Timer = e.currentTarget as Timer;
			var state:int = timer.currentCount % 2;
			if(state == 0){
				setAreaColor(listCount,0);
			}
			else{
				setAreaColor(listCount,1);
			}
		}
		
		private function handlerListSmallTimerCMP(e:Event):void{
			var timer:Timer = new Timer(5000,1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,handlerListBigEndTimerCMP);
			timer.start();
		}
		
		private function handlerListBigEndTimerCMP(e:Event):void{
			listCount ++;
			playAreaView();
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