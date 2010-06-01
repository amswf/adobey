package com.snsoft.tvc2.media{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class MediaPlayer extends EventDispatcher{
		
		//事件类型 播放前延时
		public static const DELAY_COMPLETE:String = "DELAY_COMPLETE";
		
		//最小或至少播放时间
		public static const SHORTEST_TIME:String = "SHORTEST_TIME";
		
		//最大或超时播放时间
		public static const TIME_OUT:String = "TIME_OUT";
		
		//帧时间 ，播放一帧需要的时间
		private var frameTime:Number;
		
		//延时帧计数
		private var delayFrameCount:int;
		
		//延时时间
		private var delayCtrTime:Number;
		
		public function MediaPlayer(frameTime:Number,target:IEventDispatcher)
		{
			this.frameTime = frameTime;
			super(target);
		}
		
		/**
		 * 延时操作 
		 * 
		 */		
		private function delay(time:Number):void{
			if(this.stage != null){
				this.time = time;
				this.delayFrameCount = 0;
				frameTime = 1 / this.stage.frameRate;
				this.removeEventListener(Event.ENTER_FRAME,handlerDelay);
				this.addEventListener(Event.ENTER_FRAME,handlerDelay);
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
				this.removeEventListener(Event.ENTER_FRAME,handlerDelay);
				this.dispatchEvent(new Event(DELAY_COMPLETE));
			}
		}
		
	}
}