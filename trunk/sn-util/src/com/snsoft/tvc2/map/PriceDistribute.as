package com.snsoft.tvc2.map{
	import com.snsoft.tvc2.Business;
	import com.snsoft.tvc2.dataObject.DataDO;
	import com.snsoft.tvc2.dataObject.ListDO;
	import com.snsoft.tvc2.dataObject.MarketCoordDO;
	import com.snsoft.tvc2.dataObject.MarketCoordsDO;
	import com.snsoft.tvc2.dataObject.MarketMainDO;
	import com.snsoft.tvc2.dataObject.MarketMap;
	import com.snsoft.tvc2.dataObject.TextPointDO;
	import com.snsoft.util.ColorTransformUtil;
	import com.snsoft.util.HashVector;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	public class PriceDistribute extends Business{
		
		//点列表的列表
		private var _dataDO:DataDO;
		
		private var marketMainDO:MarketMainDO;
		
		private var marketMap:MarketMap;
		
		private var MAP_NAME:String = "china";
		
		private var listSmallCount:int = 0;
		
		private var listDOV:Vector.<ListDO>;
		
		private var marketCoordsDO:MarketCoordsDO;
		
		private var listSmallTimer:Timer;
		
		private var currentListMC:Sprite;
		
		public function PriceDistribute(dataDO:DataDO,marketMainDO:MarketMainDO,marketMap:MarketMap,delayTime:Number = 0,timeLength:Number = 0,timeOut:Number = 0)	{
			super();
			this.dataDO = dataDO;
			this.marketMainDO = marketMainDO;
			this.marketMap = marketMap;
			this.delayTime = delayTime;
			this.timeLength = timeLength;
			this.timeOut = timeOut;
		}
		
		public static const BIG_POINT_DEFAULT_SKIN:String = "big_point_default_skin";
		
		public static const SMALL_POINT_DEFAULT_SKIN:String = "small_point_default_skin";
		
		public static const TEXT_FORMAT:String = "myTextFormat";
		
		/**
		 * 
		 */		
		private static var defaultStyles:Object = {
			big_point_default_skin:"BigPoint_default_skin",
			small_point_default_skin:"SmallPoint_default_skin",
			myTextFormat:new TextFormat("宋体",13,0x000000)
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
		
		override protected function draw():void {
			
		}
		
		override protected function play():void {
			var marketCoordsDOHV:HashVector = marketMainDO.marketCoordsDOHV;
			this.marketCoordsDO = marketCoordsDOHV.findByName(MAP_NAME) as MarketCoordsDO;
			this.listDOV = dataDO.data;
			this.listSmallCount = 0;
			playSmallPoint();
		}
		
		private function playSmallPoint():void{
			var index:int = this.listSmallCount;
			this.listSmallCount ++;
			if(index < listDOV.length){
				var listDO:ListDO = listDOV[index];
				var color:uint = 0x000000;
				if(index == 0){
					color = 0x000000;
				}
				if(index == 1){
					color = 0x009900;
				}
				if(index == 2){
					color = 0x990000; 
				}
				
				var listMC:Sprite = new Sprite();
				ColorTransformUtil.setColor(listMC,color);
				
				var tpdov:Vector.<TextPointDO> = listDO.listHv;
				for(var jj:int = 0;jj<tpdov.length;jj++){
					var tpdo:TextPointDO = tpdov[jj];
					var name:String = tpdo.name;
					var marketCoordDO:MarketCoordDO = marketCoordsDO.getRealCoordMarketCoordDO(name);
					var spdobj:MovieClip = getDisplayObjectInstance(getStyleValue(SMALL_POINT_DEFAULT_SKIN)) as MovieClip;
					spdobj.x = (marketCoordDO.x - this.marketMap.x) * this.marketMap.s;
					spdobj.y = (marketCoordDO.y - this.marketMap.y) * this.marketMap.s;
					listMC.addChild(spdobj);
				}
				currentListMC = listMC;
				this.addChild(listMC);
				var timer:Timer = new Timer(2000,1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE,handlerListSmallStartTimerCMP);
				timer.start();
			}
		}
		
		private function handlerListSmallStartTimerCMP(e:Event):void{
			trace(handlerListSmallStartTimerCMP);
			listSmallTimer = new Timer(200,7);
			listSmallTimer.start();
			listSmallTimer.addEventListener(TimerEvent.TIMER,handlerListSmallTimer);
			listSmallTimer.addEventListener(TimerEvent.TIMER_COMPLETE,handlerListSmallTimerCMP);
		}
		
		private function handlerListSmallTimer(e:Event):void{
			var timer:Timer = e.currentTarget as Timer;
			var state:int = timer.currentCount % 2;
			if(state == 0){
				currentListMC.visible = false;
			}
			else{
				currentListMC.visible = true;
			}
		}
		
		private function handlerListSmallTimerCMP(e:Event):void{
			var timer:Timer = new Timer(5000,1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,handlerListSmallEndTimerCMP);
			timer.start();
		}
		
		private function handlerListSmallEndTimerCMP(e:Event):void{
			playSmallPoint();
		}
		
		public function get dataDO():DataDO
		{
			return _dataDO;
		}
		
		public function set dataDO(value:DataDO):void
		{
			_dataDO = value;
		}
		
	}
}