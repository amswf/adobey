package com.snsoft.tvc2.media{
	import com.snsoft.tvc2.util.FrameTimer;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class TextPlayer extends Sprite{
		
		//声音列表 Sound 对象
		private var textField:TextField;
		
		//显示文字
		private var text:String;
		
		//文字格式
		private var textFormat:TextFormat;
		
		//开始播放时间
		private var delayTime:Number;
		
		//最小播放时长
		private var timeLength:Number;
		
		//最大播放时长
		private var timeOut:Number;
		
		//是否播放了最小播放时间
		private var isTimeLen:Boolean;
		
		//是否超时
		private var isTimeOut:Boolean;
		
		//延时计时
		private var delayFrameTimer:FrameTimer;
		
		//最小播放计时
		private var timeLengthFrameTimer:FrameTimer;
		
		//超时计时
		private var timeOutFrameTimer:FrameTimer;
		
		
		public function TextPlayer(text:String,textFormat:TextFormat,delayTime:Number = 0,timeLength:Number = 0,timeOut:Number = 0){
			this.text = text;
			this.textFormat = textFormat;
			this.delayTime = delayTime;
			this.timeLength = timeLength;
			this.timeOut = timeOut;
			this.addEventListener(Event.ADDED_TO_STAGE,handlerAddedToStage);
			super();
		}
		
		private function play():void{
			this.textField = new TextField();
			if(this.textFormat != null){
				this.textField.setTextFormat(this.textFormat);
			}
			this.textField.text = this.text;
			this.addChild(this.textField);
			
		}
		
		/**
		 * 事件
		 * @param e
		 * 
		 */		
		private function handlerAddedToStage(e:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE,handlerAddedToStage);
			delayFrameTimer = new FrameTimer(this.stage.frameRate,this.delayTime,this);
			delayFrameTimer.timer();
			delayFrameTimer.addEventListener(Event.COMPLETE,handlerDelayFrameTimer);
		}
		
		private function handlerDelayFrameTimer(e:Event):void{
			delayFrameTimer.removeEventListener(Event.COMPLETE,handlerDelayFrameTimer);
			
			if(this.timeLength > 0){
				timeLengthFrameTimer = new FrameTimer(this.stage.frameRate,this.timeLength,this);
				timeLengthFrameTimer.timer();
				timeLengthFrameTimer.addEventListener(Event.COMPLETE,handlerTimeLength);
			}
			else{
				this.isTimeLen = true;
			}
			
			if(this.timeOut > 0){
				timeOutFrameTimer = new FrameTimer(this.stage.frameRate,this.timeOut,this);
				timeOutFrameTimer.timer();
				timeOutFrameTimer.addEventListener(Event.COMPLETE,handlerTimeOut);
			}
			this.play();
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerTimeLength(e:Event):void{
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
			timeOutFrameTimer.removeEventListener(Event.COMPLETE,handlerTimeOut);
			this.isTimeOut = true;
			this.dispatchEventState();
		}
		
		/**
		 * 
		 * 
		 */		
		private function dispatchEventState():void{
			var sign:Boolean = false;
			if(this.isTimeLen){
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