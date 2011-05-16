package com.snsoft.util.rlm.rs {
	import com.snsoft.util.HashVector;

	import flash.net.URLLoader;

	public class RSTextFile extends ResSet {

		private var textHV:HashVector = new HashVector();

		private var _textList:Vector.<String> = new Vector.<String>();

		public function RSTextFile() {

		}

		public function getTextByUrl(url:String):String {
			return this.textHV.findByName(url) as String;
		}

		override protected function callBack():void {
			for (var i:int = 0; i < resDataList.length; i++) {
				var text:String = String(resDataList[i]);
				this.textHV.push(text, urlList[i]);
				this.textList.push(text);
			}
		}

		public function get textList():Vector.<String> {
			return _textList;
		}

	}
}
