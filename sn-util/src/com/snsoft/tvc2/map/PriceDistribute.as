package com.snsoft.tvc2.map{
	import com.snsoft.tvc2.Business;
	import com.snsoft.tvc2.dataObject.DataDO;
	import com.snsoft.tvc2.dataObject.ListDO;
	import com.snsoft.tvc2.dataObject.MarketCoordDO;
	import com.snsoft.tvc2.dataObject.MarketCoordsDO;
	import com.snsoft.tvc2.dataObject.MarketMainDO;
	import com.snsoft.tvc2.dataObject.MarketMap;
	import com.snsoft.tvc2.dataObject.TextPointDO;
	import com.snsoft.tvc2.text.EffectText;
	import com.snsoft.util.ColorTransformUtil;
	import com.snsoft.util.HashVector;
	import com.snsoft.util.TextFieldUtil;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	public class PriceDistribute extends Business{
		
		//点列表的列表
		private var _dataDO:DataDO;
		
		private var marketMainDO:MarketMainDO;
		
		private var marketMap:MarketMap;
		
		private var MAP_NAME:String = "china";
		
		private var listSmallCount:int = 0;
		
		private var broadcastListCount:int = 0;
		
		private var broadcastCount:int = 0;
		
		private var broadcastNum:int = 0;
		
		private var listDOV:Vector.<ListDO>;
		
		private var broadcastListDOV:Vector.<ListDO>;
		
		private var marketCoordsDO:MarketCoordsDO;
		
		private var listSmallTimer:Timer;
		
		private var currentListMC:Sprite;
		
		private var currentBroadcastListMC:Sprite;
		
		private var mapView:MapView;
		
		private var cutLine:Sprite;
		
		public function PriceDistribute(dataDO:DataDO,marketMainDO:MarketMainDO,marketMap:MarketMap,mapView:MapView,delayTime:Number = 0,timeLength:Number = 0,timeOut:Number = 0)	{
			super();
			this.dataDO = dataDO;
			this.marketMainDO = marketMainDO;
			this.marketMap = marketMap;
			this.mapView = mapView;
			this.delayTime = delayTime;
			this.timeLength = timeLength;
			this.timeOut = timeOut;
		}
		
		public static const BIG_POINT_DEFAULT_SKIN:String = "big_point_default_skin";
		
		public static const SMALL_POINT_DEFAULT_SKIN:String = "small_point_default_skin";
		
		public static const PRICEBACK_DEFAULT_SKIN:String = "priceback_default_skin";
		
		public static const PRICEPOINTER_DEFAULT_SKIN:String = "pricepointer_default_skin";
		
		public static const TEXT_FORMAT:String = "myTextFormat";
		
		/**
		 * 
		 */		
		private static var defaultStyles:Object = {
			big_point_default_skin:"BigPoint_default_skin",
			small_point_default_skin:"SmallPoint_default_skin",
			priceback_default_skin:"PriceBack_default_skin",
			pricepointer_default_skin:"PricePointer_default_skin",
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
			
			this.addChild(mapView);
			mapView.width = 490;
			mapView.height = 410;
			var marketCoordsDOHV:HashVector = marketMainDO.marketCoordsDOHV;
			this.marketCoordsDO = marketCoordsDOHV.findByName(MAP_NAME) as MarketCoordsDO;
			this.listDOV = dataDO.data;
			this.broadcastListDOV = dataDO.broadcast;
			this.listSmallCount = 0;
			this.broadcastListCount = 0;
			
			cutLine = new Sprite();
			var rect:Rectangle = this.mapView.getRect(this);
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
				
				
				var cutLineMC:MovieClip = getDisplayObjectInstance(getStyleValue(SMALL_POINT_DEFAULT_SKIN)) as MovieClip;
				cutLineMC.y = - cutLineMC.height - cutLine.height;
				cutLineMC.x = cutLineMC.width / 2;
				ColorTransformUtil.setColor(cutLineMC,color);

				var name:String = listDO.name;
				var tft:TextFormat = getStyleValue(TEXT_FORMAT) as TextFormat;
				tft.color = color;
				var tfd:TextField = EffectText.creatShadowTextField(name,tft);
				tfd.x = cutLineMC.x + cutLineMC.width ;
				tfd.y = cutLineMC.y - tfd.height / 2;
				tfd.selectable = false;
				
				cutLine.addChild(cutLineMC);
				cutLine.addChild(tfd);
			}
			
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
			else {
				playBigPoint();
			}
		}
		
		private function handlerListSmallStartTimerCMP(e:Event):void{
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
		
		private function playBigPoint():void{
			var index:int = this.broadcastListCount;
			
			if(index < broadcastListDOV.length){
				var listDO:ListDO = broadcastListDOV[index];
				var color:uint = 0x000000;
				if(index == 0){
					color = 0x000000;
				}
				if(index == 1){
					color = 0x990000; 
				}
				
				var listMC:Sprite = new Sprite();
				var priceMC:Sprite = new Sprite();
				
				ColorTransformUtil.setColor(listMC,color);
				var tpdov:Vector.<TextPointDO> = listDO.listHv;
				var jj:int = broadcastCount;
				broadcastCount ++;
				broadcastNum ++;
				if(broadcastCount >= tpdov.length){
					broadcastCount = 0;
					this.broadcastListCount ++;
				}
				var tpdo:TextPointDO = tpdov[jj];
				var name:String = tpdo.name;
				var marketCoordDO:MarketCoordDO = marketCoordsDO.getRealCoordMarketCoordDO(name);
				var ppdobj:MovieClip = getDisplayObjectInstance(getStyleValue(PRICEPOINTER_DEFAULT_SKIN)) as MovieClip;
				var bpdobj:MovieClip = getDisplayObjectInstance(getStyleValue(BIG_POINT_DEFAULT_SKIN)) as MovieClip;
				var pbdobj:MovieClip = getDisplayObjectInstance(getStyleValue(PRICEBACK_DEFAULT_SKIN)) as MovieClip;
				
				var rect:Rectangle = this.mapView.getRect(this);

				pbdobj.width = 100;
				pbdobj.height = 50;
				
				priceMC.x = rect.x + rect.width;
				priceMC.y = cutLine.y -cutLine.height - broadcastNum * (pbdobj.height + 10);
				priceMC.addChild(pbdobj);
				
				bpdobj.x = (marketCoordDO.x - this.marketMap.x) * this.marketMap.s;
				bpdobj.y = (marketCoordDO.y - this.marketMap.y) * this.marketMap.s;
				
				ppdobj.x = bpdobj.x;
				ppdobj.y = bpdobj.y;
				ppdobj.height = pbdobj.height;
				ppdobj.width = this.lineLength(new Point(bpdobj.x,bpdobj.y),new Point(priceMC.x,priceMC.y + pbdobj.height / 2));
				ppdobj.rotation = this.lineRate(new Point(bpdobj.x,bpdobj.y),new Point(priceMC.x,priceMC.y + pbdobj.height / 2));
				ColorTransformUtil.setColor(ppdobj,color);
				this.addChild(ppdobj);
				
				var tft:TextFormat = getStyleValue(TEXT_FORMAT) as TextFormat;
				var marketName:TextField = EffectText.creatShadowTextField(marketCoordDO.text,tft);
				marketName.x = 4;
				marketName.y = 4;
				var marketPrice:TextField = EffectText.creatShadowTextField(tpdo.value,tft);
				marketPrice.x = marketName.x;
				marketPrice.y = marketName.y + marketName.height;
				priceMC.addChild(marketName);
				priceMC.addChild(marketPrice);
				this.addChild(priceMC);
				listMC.addChild(bpdobj);
				currentBroadcastListMC = listMC;
				this.addChild(listMC);
				var timer:Timer = new Timer(2000,1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE,handlerListBigStartTimerCMP);
				timer.start();
			}
			else{
				this.isPlayCmp = true;
				dispatchEventState();
			}
		}
		
		private function handlerListBigStartTimerCMP(e:Event):void{
			listSmallTimer = new Timer(200,7);
			listSmallTimer.start();
			listSmallTimer.addEventListener(TimerEvent.TIMER,handlerListBigTimer);
			listSmallTimer.addEventListener(TimerEvent.TIMER_COMPLETE,handlerListBigTimerCMP);
		}
		
		private function handlerListBigTimer(e:Event):void{
			var timer:Timer = e.currentTarget as Timer;
			var state:int = timer.currentCount % 2;
			if(state == 0){
				currentBroadcastListMC.visible = false;
			}
			else{
				currentBroadcastListMC.visible = true;
			}
		}
		
		private function handlerListBigTimerCMP(e:Event):void{
			var timer:Timer = new Timer(5000,1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,handlerListBigEndTimerCMP);
			timer.start();
		}
		
		private function handlerListBigEndTimerCMP(e:Event):void{
			playBigPoint();
		}
		
		/**
		 * 计算线长 
		 * @param p1
		 * @param p2
		 * @return 
		 * 
		 */		
		private function lineLength(p1:Point,p2:Point):Number{
			return Math.sqrt(Math.pow((p1.x - p2.x),2) + Math.pow((p1.y - p2.y),2));
		}
		
		/**
		 * 计算旋转角度 
		 * @param p1
		 * @param p2
		 * @return 
		 * 
		 */		
		private function lineRate(p1:Point,p2:Point):Number{
			var rate:Number = 0;
			
			if(p2.x - p1.x == 0){
				rate = p2.y - p1.y > 0 ? 90 : -90;
			}
			else {
				rate = Math.atan((p2.y - p1.y) / (p2.x - p1.x)) * 180 / Math.PI;
			}
			return rate;
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