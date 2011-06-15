package com.snsoft.mapview {
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class CuntyLable extends MovieClip {
		private var _lableName:TextField = null;

		private var _lableText:TextField = null;

		private var _nameStr:String = "";

		private var _textStr:String = "";

		public function CuntyLable(nameStr:String = "", textStr:String = "") {
			super();
			_lableName = this.getChildByName("lableName") as TextField;
			_lableText = this.getChildByName("lableText") as TextField;

			this.nameStr = nameStr;
			this.textStr = textStr;
		}

		public function get nameStr():String {
			return _nameStr;
		}

		public function set nameStr(value:String):void {
			if (value != null) {
				_nameStr = value;
				_lableName.text = value;
			}
		}

		public function get textStr():String {
			return _textStr;
		}

		public function set textStr(value:String):void {
			_textStr = value;
			_lableText.text = value;
		}

	}
}
