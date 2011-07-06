package com.snsoft.ens {
	import fl.controls.Button;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class BoothEditer extends MovieClip {

		public static const EVENT_CMP:String = "EVENT_CMP";

		public static const EVENT_DEL:String = "EVENT_DEL";

		private var dtfd:TextField;

		private var dcmp:Button;

		private var ddel:Button;

		private var _text:String;

		public function BoothEditer() {
			super();
			this.addEventListener(Event.ENTER_FRAME, handlerEnterFrame);
		}

		private function handlerEnterFrame(e:Event):void {
			this.removeEventListener(Event.ENTER_FRAME, handlerEnterFrame);

			dtfd = this.getChildByName("tfd") as TextField;
			dcmp = this.getChildByName("cmp") as Button;
			ddel = this.getChildByName("del") as Button;

			dcmp.addEventListener(MouseEvent.CLICK, handlerCmpClick);
			ddel.addEventListener(MouseEvent.CLICK, handlerDelClick);
		}

		private function handlerCmpClick(e:Event):void {
			if (dtfd.text != null && dtfd.text.length > 0) {
				_text = dtfd.text;
			}
			else {
				_text = "";
			}
			dtfd.text = "";
			this.dispatchEvent(new Event(EVENT_CMP));
		}

		private function handlerDelClick(e:Event):void {
			this.dispatchEvent(new Event(EVENT_DEL));
		}

		public function get text():String {
			return _text;
		}

	}
}
