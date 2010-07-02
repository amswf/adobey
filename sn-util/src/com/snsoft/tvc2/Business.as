package com.snsoft.tvc2{
	import com.snsoft.tvc2.util.FrameTimer;
	
	import fl.core.UIComponent;
	
	import flash.events.Event;
	
	public class Business extends UIComponent{
		
		
		//开始播放时间
		protected var delayTime:Number;
		
		//最小播放时长
		protected var timeLength:Number;
		
		//最大播放时长
		protected var timeOut:Number;
		
		//是否全部播完
		protected var isPlayCmp:Boolean;
		
		//是否播放了最小播放时间
		protected var isTimeLen:Boolean;
		
		//是否超时
		protected var isTimeOut:Boolean;
		
		//延时计时
		protected var delayFrameTimer:FrameTimer;
		
		//最小播放计时
		protected var timeLengthFrameTimer:FrameTimer;
		
		//超时计时
		protected var timeOutFrameTimer:FrameTimer;
		
		//是否已经播放
		protected var isPlay:Boolean;
		
		//是否已经完成
		protected var isDispatchEvent:Boolean;
		
		public function Business(){
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,handlerAddedToStage);
		}
		
		/**
		 * 事件
		 * @param e
		 * 
		 */		
		private function handlerAddedToStage(e:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE,handlerAddedToStage);
			initPlay();
			if(this.stage != null){
				delayFrameTimer = new FrameTimer(this.stage.frameRate,this.delayTime,this);
				delayFrameTimer.timer();
				delayFrameTimer.addEventListener(Event.COMPLETE,handlerDelayFrameTimer);
			}
		}
		
		private function handlerDelayFrameTimer(e:Event):void{
			delayFrameTimer.removeEventListener(Event.COMPLETE,handlerDelayFrameTimer);
			trace("handlerDelayFrameTimer",this.timeLength,this.timeOut);
			if(this.timeLength > 0 && this.stage != null){
				timeLengthFrameTimer = new FrameTimer(this.stage.frameRate,this.timeLength,this);
				timeLengthFrameTimer.timer();
				timeLengthFrameTimer.addEventListener(Event.COMPLETE,handlerTimeLength);
			}
			else{
				this.isTimeLen = true;
			}
			
			if(this.timeOut > 0 && this.stage != null){
				timeOutFrameTimer = new FrameTimer(this.stage.frameRate,this.timeOut,this);
				timeOutFrameTimer.timer();
				timeOutFrameTimer.addEventListener(Event.COMPLETE,handlerTimeOut);
			}
			if(!isPlay){
				isPlay = true;
				this.play();
			}
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerTimeLength(e:Event):void{
			trace("handlerTimeLength");
			timeLengthFrameTimer.removeEventListener(Event.COMPLETE,handlerTimeLength);
			this.isTimeLen = true;
			this.dispatchEventState();
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerTimeOut(e:Event):void{
			trace("handlerTimeOut");
			timeOutFrameTimer.removeEventListener(Event.COMPLETE,handlerTimeOut);
			this.isTimeOut = true;
			this.dispatchEventState();
		}
		
		/**
		 * 
		 * 
		 */		
		protected function initPlay():void{
			trace("需要 override Business.initPlay()");
		}
		
		/**
		 * 
		 * 
		 */		
		protected function play():void{
			trace("需要 override Business.play()");
		}
		
		/**
		 * 
		 * 
		 */		
		protected function dispatchEventState():void{
			trace("需要 override Business.dispatchEventState()");
		}
	}
}