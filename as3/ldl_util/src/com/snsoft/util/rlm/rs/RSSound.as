package com.snsoft.util.rlm.rs {
	import com.snsoft.util.HashVector;
	
	import flash.media.Sound;
	import flash.net.URLLoader;

	public class RSSound extends ResSet {

		private var soundHV:HashVector = new HashVector();
		
		private var _soundList:Vector.<Sound> = new Vector.<Sound>();

		public function RSSound() {

		}

		public function getSoundByUrl(url:String):Sound {
			return this.soundHV.findByName(url) as Sound;
		}

		override protected function callBack():void {
			for (var i:int = 0; i < resDataList.length; i++) {
				var sound:Sound = resDataList[i] as Sound;
				this.soundHV.push(sound, urlList[i]);
				soundList.push(sound);
			}
		}

		public function get soundList():Vector.<Sound>
		{
			return _soundList;
		}

	}
}
