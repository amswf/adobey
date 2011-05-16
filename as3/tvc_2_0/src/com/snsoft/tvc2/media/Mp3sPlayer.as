package com.snsoft.tvc2.media {
	import com.snsoft.tvc2.Business;
	import com.snsoft.tvc2.dataObject.SoundDO;
	import com.snsoft.tvc2.dataObject.SoundsDO;
	import com.snsoft.util.rlm.rs.RSSound;
	
	import flash.events.Event;
	import flash.media.Sound;

	/**
	 * mp3 组播放
	 * @author Administrator
	 *
	 */
	public class Mp3sPlayer extends Business {

		private var soundsDO:SoundsDO;

		//当前播放序号
		private var playNum:int;

		private var mp3Player:Mp3Player;

		public function Mp3sPlayer(soundsDO:SoundsDO) {
			super();
			this.soundsDO = soundsDO;
		}

		/**
		 * 播放
		 * @return
		 *
		 */
		override protected function play():void {
			playNum = 0;
			playNextMp3s();
		}

		private function playNextMp3s():void {
			//trace("_______________________________playNum:"+playNum);
			if (soundsDO != null && soundsDO.soundDOHv != null) {
				if (playNum < soundsDO.soundDOHv.length) {
					if (mp3Player != null) {
						this.removeChild(mp3Player);
					}
					var soundDO:SoundDO = soundsDO.soundDOHv[playNum];
					var soundList:Vector.<Sound> = new Vector.<Sound>();

					var rsSound:RSSound = soundDO.rsSound as RSSound;
					if (rsSound != null) {
						var srdl:Vector.<Sound> = rsSound.soundList;
						if (srdl != null) {
							for (var i2:int = 0; i2 < srdl.length; i2++) {
								var sound:Sound = srdl[i2];
								if (sound != null) {
									soundList.push(sound);
								}
							}
						}
					}
					mp3Player = new Mp3Player(soundList, soundDO.timeOffset, soundDO.timeLength, soundDO.timeout);
					mp3Player.addEventListener(Event.COMPLETE, handlerMp3PlayerCMP);
					this.addChild(mp3Player);
				}
				else {
					this.dispatchEventState();
				}
			}
		}

		private function handlerMp3PlayerCMP(e:Event):void {
			playNum++;
			playNextMp3s();
		}

		override protected function dispatchEventState():void {
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}
