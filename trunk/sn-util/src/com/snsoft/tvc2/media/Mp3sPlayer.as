package com.snsoft.tvc2.media{
	import com.snsoft.tvc2.Business;
	import com.snsoft.tvc2.dataObject.SoundDO;
	import com.snsoft.tvc2.dataObject.SoundsDO;
	
	import flash.events.Event;
	
	public class Mp3sPlayer extends Business{
		
		private var soundsDO:SoundsDO;
		
		//当前播放序号
		private var playNum:int;
		
		public function Mp3sPlayer(soundsDO:SoundsDO){
			super();
			this.soundsDO = soundsDO;
		}
		
		/**
		 * 播放
		 * @return 
		 * 
		 */
		override protected function play():void{
			var soundDOHv:Vector.<SoundDO> = soundsDO.soundDOHv;
			playNum = 0;
			playNextMp3s();
		}
		
		private function playNextMp3s():void{
			if(soundsDO != null && soundsDO.soundDOHv != null){
				if(playNum < soundsDO.soundDOHv.length){
					var soundDO:SoundDO = soundsDO.soundDOHv[playNum];
					var mp3Player:Mp3Player = new Mp3Player(soundDO.soundList,soundDO.timeOffset,soundDO.timeLength,soundDO.timeout);
					mp3Player.addEventListener(Event.COMPLETE,handlerMp3PlayerCMP);
					this.addChild(mp3Player);
				}
				else{
					this.isPlayCmp = true;
					this.dispatchEventState();
				}
			}
		}
		
		private function handlerMp3PlayerCMP(e:Event):void{
			playNum ++;
			playNextMp3s();
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
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
	}
}