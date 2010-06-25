package com.snsoft.tvc2.media{
	import com.snsoft.tvc2.Business;
	import com.snsoft.tvc2.util.FrameTimer;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	public class Mp3Player extends Business{
		
		//当前播放的声音
		private var sound:Sound;
		
		//当前声音声道
		private var soundChannel:SoundChannel;
		
		//声音列表 Sound 对象
		private var _soundList:Vector.<Sound>;
		
		//当前播放序号
		private var playNum:int;
		
		public function Mp3Player(soundList:Vector.<Sound>,delayTime:Number = 0,timeLength:Number = 0,timeOut:Number = 0){
			super();
			this._soundList = soundList;
			this.delayTime = delayTime;
			this.timeLength = timeLength;
			this.timeOut = timeOut;
			this.playNum = 0;
		}
		
		/**
		 * 播放
		 * @return 
		 * 
		 */
		override protected function play():void{
			playNextMp3();
		}
		
		private function playNextMp3():void{
			trace("Mp3Player.play()");
			if(this.soundList != null ){
				if(this.playNum < this.soundList.length){
					sound = this.soundList[this.playNum];
					soundChannel = sound.play();
					soundChannel.removeEventListener(Event.SOUND_COMPLETE,handlerPlayComplete); 
					soundChannel.addEventListener(Event.SOUND_COMPLETE,handlerPlayComplete); 
				}
				else if(this.playNum >= this.soundList.length){
					this.isPlayCmp = true;
					this.dispatchEventState();
				}
			}
		}
		
		override protected function dispatchEventState():void{
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
			this.playNextMp3();
		}
		
		public function get soundList():Vector.<Sound>{
			return _soundList;
		}
	}
}