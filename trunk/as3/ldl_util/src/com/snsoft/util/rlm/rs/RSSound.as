package com.snsoft.util.rlm.rs {
	import com.snsoft.util.HashVector;

	import flash.media.Sound;
	import flash.net.URLLoader;

	public class RSSound extends ResSet {

		private var soundList:HashVector = new HashVector();

		public function RSSound() {

		}

		public function getSoundByUrl(url:String):Sound {
			return this.soundList.findByName(url) as Sound;
		}

		override public function callBack():void {
			for (var i:int = 0; i < resDataList.length; i++) {
				var sound:Sound = resDataList[i] as Sound;
				this.soundList.push(sound, urlList[i]);
			}
		}
	}
}
