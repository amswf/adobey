package com.snsoft.tvc2{
	import com.snsoft.tvc2.dataObject.BizDO;
	import com.snsoft.tvc2.dataObject.MarketMainDO;
	import com.snsoft.tvc2.dataObject.TimeLineDO;
	import com.snsoft.util.HashVector;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class TimeLine extends UIComponent{
		
		private var timeLineDO:TimeLineDO = new TimeLineDO();
		
		private var bizIndex:int = 0;
		
		private var marketMainDO:MarketMainDO;
		
		private var forwardBiz:Biz;
		
		private var currentBiz:Biz;
		
		private var switchAddTimer:Timer;
		
		private var switchRemoveTimer:Timer;
		
		private var switchTimerDelay:int = 20;
		
		private var switchTimerRepeatCount:int = 10;
		
		private var switchTimerCmp:Boolean = false;
		
		private var bizCmp:Boolean = false;
		
		private var switchMoveLenth:Number = 100;
		
		private var isStop:Boolean = false;
		
		public function TimeLine(timeLineDO:TimeLineDO,marketMainDO:MarketMainDO){
			super();
			
			this.timeLineDO = timeLineDO;
			this.marketMainDO = marketMainDO;
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
			play();
			trace("TimeLine.play()");
		}
		
		public function pausePlay():void{
			if(isStop){
				isStop = false;
			}
			else {
				isStop = true;
				var timer:Timer = new Timer(20,0);
				timer.addEventListener(TimerEvent.TIMER,handlerPauseTimer);
				timer.start();
			}
		}
		
		private function handlerPauseTimer(e:Event):void{
			if(!isStop){
				var timer:Timer = e.currentTarget as Timer;
				timer.removeEventListener(TimerEvent.TIMER,handlerPauseTimer);
				playNextBiz();	
			}
		}
		
		private function play():void{
			var bizHv:HashVector = this.timeLineDO.bizDOHv;
			if(bizHv != null && bizIndex < bizHv.length){
				var bizDO:BizDO = bizHv.findByIndex(bizIndex) as BizDO;
				if(bizDO != null){
					currentBiz = new Biz(bizDO,marketMainDO);
					currentBiz.alpha = 0;
					currentBiz.x = currentBiz.x + switchMoveLenth;
					currentBiz.addEventListener(Event.COMPLETE,handlerBizComplete);
					this.addChild(currentBiz);
					currentBiz.drawNow();
					
					switchAddTimer = new Timer(switchTimerDelay,switchTimerRepeatCount);
					switchTimerCmp = false;
					switchAddTimer.addEventListener(TimerEvent.TIMER,handlerSwitchAddTimer);
					switchAddTimer.addEventListener(TimerEvent.TIMER_COMPLETE,handlerSwitchAddTimerCmp);
					switchAddTimer.start();
				}
			}
			else {
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function handlerSwitchAddTimer(e:Event):void{
			var palpha:Number = 1 / switchTimerRepeatCount;
			
			var px:Number = switchMoveLenth / switchTimerRepeatCount;
			
			currentBiz.alpha += palpha;
			currentBiz.x -= px;
		}
		
		private function handlerSwitchAddTimerCmp(e:Event):void{
			switchTimerCmp = true;
			playNextBiz();
		}
		
		private function handlerBizComplete(e:Event):void{
			bizCmp = true;
			playNextBiz();
		}
		
		private function playNextBiz():void{
			if(bizCmp && switchTimerCmp && !isStop){
				var bizHv:HashVector = this.timeLineDO.bizDOHv;
				if(bizHv != null && bizIndex < bizHv.length -1){
					bizCmp = false;
					switchTimerCmp = false;
					forwardBiz = currentBiz;
					switchRemoveTimer = new Timer(switchTimerDelay,switchTimerRepeatCount);
					switchRemoveTimer.addEventListener(TimerEvent.TIMER,handlerSwitchRemoveTimer);
					switchRemoveTimer.addEventListener(TimerEvent.TIMER_COMPLETE,handlerSwitchRemoveTimerCmp);
					switchRemoveTimer.start();
				}
				bizIndex ++;
				play();
			}
		}
		
		private function handlerSwitchRemoveTimer(e:Event):void{
			var palpha:Number = 1 / switchTimerRepeatCount;
			var px:Number = switchMoveLenth / switchTimerRepeatCount;
			if(forwardBiz != null){
				forwardBiz.alpha -= palpha;
				forwardBiz.x -= px;
			} 
		}
		
		private function handlerSwitchRemoveTimerCmp(e:Event):void{
			switchRemoveTimer.removeEventListener(TimerEvent.TIMER,handlerSwitchRemoveTimerCmp);
			switchRemoveTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,handlerSwitchRemoveTimer);
			this.removeChild(forwardBiz);
		}
		
	}
}