package com.snsoft.ensview {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class TextMain extends MovieClip {

		public static const EVENT_BTN:String = "EVENT_BTN";

		public static const BTN_TYPE_INTRO:String = "intro";

		public static const BTN_TYPE_MAP:String = "map";

		private var btnType:String;

		public function TextMain() {
			super();

			this.addEventListener(Event.ENTER_FRAME, handlerEnterFrame);
		}

		private function handlerEnterFrame(e:Event):void {
			this.removeEventListener(Event.ENTER_FRAME, handlerEnterFrame);

			var introBtn:MovieClip = this.getChildByName("introBtn") as MovieClip;
			introBtn.buttonMode = true;
			introBtn.addEventListener(MouseEvent.CLICK, handlerIntroClick);

			var mapBtn:MovieClip = this.getChildByName("mapBtn") as MovieClip;
			mapBtn.buttonMode = true;
			mapBtn.addEventListener(MouseEvent.CLICK, handlerMapClick);

		}

		public function getBtnType():String {
			return btnType;
		}

		private function handlerIntroClick(e:Event):void {
			btnType = BTN_TYPE_INTRO;
			this.dispatchEvent(new Event(EVENT_BTN));
		}

		private function handlerMapClick(e:Event):void {
			btnType = BTN_TYPE_MAP;
			this.dispatchEvent(new Event(EVENT_BTN));
		}
	}
}
