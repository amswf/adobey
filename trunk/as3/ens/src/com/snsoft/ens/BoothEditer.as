package com.snsoft.ens {
	import fl.controls.Button;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class BoothEditer extends MovieClip {

		public static const EVENT_CMP:String = "EVENT_CMP";

		public static const EVENT_DEL:String = "EVENT_DEL";

		private var dId:TextField;

		private var dText:TextField;

		private var dcmp:Button;

		private var ddel:Button;

		private var _text:String;

		private var _id:String;

		public function BoothEditer() {
			super();
			this.addEventListener(Event.ENTER_FRAME, handlerEnterFrame);
		}

		private function handlerEnterFrame(e:Event):void {
			this.removeEventListener(Event.ENTER_FRAME, handlerEnterFrame);

			dId = this.getChildByName("tfd") as TextField;
			dText = this.getChildByName("ttfd") as TextField;
			dcmp = this.getChildByName("cmp") as Button;
			ddel = this.getChildByName("del") as Button;

			dcmp.addEventListener(MouseEvent.CLICK, handlerCmpClick);
			ddel.addEventListener(MouseEvent.CLICK, handlerDelClick);
		}

		private function handlerCmpClick(e:Event):void {
			if (dId.text != null && dId.text.length > 0) {
				_id = dId.text;
			}
			else {
				_id = "";
			}
			dId.text = "";

			if (dText.text != null && dText.text.length > 0) {
				_text = dText.text;
			}
			else {
				_text = "";
			}
			dText.text = "";
			this.dispatchEvent(new Event(EVENT_CMP));
		}

		private function handlerDelClick(e:Event):void {
			this.dispatchEvent(new Event(EVENT_DEL));
		}

		public function get text():String {
			return _text;
		}

		public function set text(value:String):void {
			if (value != null) {
				_text = value;
			}
			else {
				_text = "";
			}
			this.dText.text = _text;
		}

		public function get id():String {
			return _id;
		}

		public function set id(value:String):void {
			if (value != null) {
				_id = value;
			}
			else {
				_id = "";
			}
			this.dId.text = _id;
		}

	}
}
