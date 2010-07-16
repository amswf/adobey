package com.snsoft.tvc2.util{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * 帧率计时器 
	 * @author Administrator
	 * 
	 */	
	public class FrameTimer extends EventDispatcher{
		
		//帧时间 ，播放一帧需要的时间
		private var frameTime:Number;
		
		//延时帧计数
		private var delayFrameCount:int;
		
		//延时时间
		private var delayCtrTime:Number;
		
		//计时控制的 sprite
		private var timerSprite:Sprite;
		
		public function FrameTimer(frameRate:Number,delayCtrTime:Number,timerSprite:Sprite,target:IEventDispatcher = null)
		{
			
			this.delayCtrTime = delayCtrTime;
			this.frameTime = 1000 / frameRate;
			this.timerSprite = timerSprite;
			super(target);
		}
		
		/**
		 * 延时操作 
		 * 
		 */		
		public function timer():void{
			if(this.timerSprite != null){
				this.timerSprite.removeEventListener(Event.ENTER_FRAME,handlerDelay);
				this.timerSprite.addEventListener(Event.ENTER_FRAME,handlerDelay);
			}
		}
		
		/**
		 * 事件 
		 * @param e
		 * 
		 */		
		private function handlerDelay(e:Event):void{
			var t:Number = this.delayFrameCount * this.frameTime;
			if(t < delayCtrTime){
				this.delayFrameCount ++;
			}
			else{
				if(this.timerSprite != null){
					this.timerSprite.removeEventListener(Event.ENTER_FRAME,handlerDelay);
					this.dispatchEvent(new Event(Event.COMPLETE));
				}
			}
		}
		
	}
}