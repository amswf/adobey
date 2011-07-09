package com.snsoft.ensview {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;

	public class EnsvBoothCard extends MovieClip {

		private var dNameTfd:TextField;

		private var dTextTfd:TextField;

		private var _dName:String;

		private var _dText:String;

		public function EnsvBoothCard() {
			super();
			this.addEventListener(Event.ENTER_FRAME, handlerEnterFrame);
		}

		private function handlerEnterFrame(e:Event):void {
			this.removeEventListener(Event.ENTER_FRAME, handlerEnterFrame);

			dNameTfd = this.getChildByName("nameTfd") as TextField;
			dTextTfd = this.getChildByName("textTfd") as TextField;

			if (dNameTfd != null && _dName != null) {
				dNameTfd.text = _dName;
			}

			if (dTextTfd != null && _dText != null) {
				dTextTfd.text = _dText;
			}
		}

		public function get dName():String {
			return _dName;
		}

		public function set dName(value:String):void {
			_dName = value;
			if (dNameTfd != null) {
				dNameTfd.text = _dName;
			}
		}

		public function get dText():String {
			return _dText;
		}

		public function set dText(value:String):void {
			_dText = value;

			if (dTextTfd != null) {
				dTextTfd.text = _dText;
			}
		}

	}
}
