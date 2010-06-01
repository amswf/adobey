package com.snsoft.tvc2.media{
	import com.snsoft.tvc2.util.FrameTimer;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	public class Mp3Player extends Sprite{
		
		//当前播放的声音
		private var sound:Sound;
		
		//当前声音声道
		private var soundChannel:SoundChannel;
		
		//声音列表 Sound 对象
		private var _soundList:Vector.<Sound>;
		
		//当前播放序号
		private var playNum:int;
		
		//开始播放时间
		private var delayTime:Number;
		
		//最小播放时长
		private var timeLength:Number;
		
		//最大播放时长
		private var timeOut:Number;
		
		//是否全部播完
		private var isPlayCmp:Boolean;
		
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
		
		public function Mp3Player(soundList:Vector.<Sound>,delayTime:Number = 0,timeLength:Number = 0,timeOut:Number = 0){
			this._soundList = soundList;
			this.delayTime = delayTime;
			this.timeLength = timeLength;
			this.timeOut = timeOut;
			this.playNum = 0;
			this.addEventListener(Event.ADDED_TO_STAGE,handlerAddedToStage);
			super();
		}
		
		/**
		 * 播放
		 * @return 
		 * 
		 */
		private function play(playNum:int):void{
			if(this.soundList != null ){
				if(playNum < this.soundList.length){
					sound = this.soundList[playNum];
					soundChannel = sound.play();
					soundChannel.removeEventListener(Event.SOUND_COMPLETE,handlerPlayComplete); 
					soundChannel.addEventListener(Event.SOUND_COMPLETE,handlerPlayComplete); 
				}
				else if(playNum >= this.soundList.length){
					this.isPlayCmp = true;
					this.dispatchEventState();
				}
			}
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
			this.play(this.playNum);
		}
		
		private function handlerTimeLength(e:Event):void{
			timeLengthFrameTimer.removeEventListener(Event.COMPLETE,handlerTimeLength);
			this.isTimeLen = true;
			this.dispatchEventState();
		}
		
		private function handlerTimeOut(e:Event):void{
			timeOutFrameTimer.removeEventListener(Event.COMPLETE,handlerTimeOut);
			this.isTimeOut = true;
			this.dispatchEventState();
		}
		
		private function dispatchEventState():void{
			var sign:Boolean = false;
			if(this.isPlayCmp && this.isTimeLen){
				sign = true;
			}
			else if(this.isTimeOut){
				sign = true;
			}
			
			if(sign){
				soundChannel.stop();
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		/**
		 * 事件
		 * @param e
		 * 
		 */		
		private function handlerPlayComplete(e:Event):void{
			soundChannel.removeEventListener(Event.SOUND_COMPLETE,handlerPlayComplete);
			this.playNum ++;
			this.play(this.playNum);
		}
		
		public function get soundList():Vector.<Sound>{
			return _soundList;
		}
	}
}