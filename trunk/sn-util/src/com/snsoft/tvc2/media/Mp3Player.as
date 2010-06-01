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
		
		private var playNum:int;
		
		private var delayTime:Number;
		
		public function Mp3Player(soundList:Vector.<Sound>,delayTime:Number){
			this._soundList = soundList;
			this.delayTime = delayTime;
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
					soundChannel.addEventListener(Event.SOUND_COMPLETE,handlerPlayComplete); 
				}
				else if(playNum >= this.soundList.length){
					this.dispatchEvent(new Event(Event.COMPLETE));
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
			var delayFrameTimer:FrameTimer = new FrameTimer(this.stage.frameRate,this.delayTime,this);
			delayFrameTimer.timer();
			delayFrameTimer.addEventListener(Event.COMPLETE,handlerDelayFrameTimer);
		}
		
		private function handlerDelayFrameTimer(e:Event):void{
			this.play(this.playNum);
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