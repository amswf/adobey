package com.snsoft.ensview {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class TextMsg extends MovieClip {

		public static const EVENT_BTN:String = "EVENT_BTN";

		public static const BTN_TYPE_MAP:String = "map";

		public static const BTN_TYPE_INTRO:String = "intro";

		public static const BTN_TYPE_ITEMS:String = "items";

		public static const BTN_TYPE_BACK:String = "back";

		public static const BTN_TYPE_MSG:String = "msg";

		private var _btnType:String;

		public function TextMsg() {

			super();
			this.addEventListener(Event.ENTER_FRAME, handlerEnterFrame);
		}

		private function handlerEnterFrame(e:Event):void {
			this.removeEventListener(Event.ENTER_FRAME, handlerEnterFrame);

			addEvent("mapBtn", BTN_TYPE_MAP);
			addEvent("itemsBtn", BTN_TYPE_ITEMS);
			addEvent("introBtn", BTN_TYPE_INTRO);
			addEvent("backBtn", BTN_TYPE_BACK);
			addEvent("msgBtn", BTN_TYPE_MSG);
		}

		private function addEvent(btnName:String, type:String):void {
			var mc:MovieClip = this;
			var mapBtn:MovieClip = this.getChildByName(btnName) as MovieClip;
			if (mapBtn != null) {
				mapBtn.buttonMode = true;
				mapBtn.addEventListener(MouseEvent.CLICK, function(e:Event):void {_btnType = type;mc.dispatchEvent(new Event(EVENT_BTN));});
			}
		}
		
		public function get btnType():String {
			return _btnType;
		}
	}
}
