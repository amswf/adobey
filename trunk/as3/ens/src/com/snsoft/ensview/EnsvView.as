package com.snsoft.ensview {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class EnsvView extends MovieClip {

		public static const EVENT_BTN:String = "EVENT_BTN";

		public static const BTN_TYPE_MAP:String = "map";

		public static const BTN_TYPE_INTRO:String = "intro";

		public static const BTN_TYPE_ITEMS:String = "items";

		public static const BTN_TYPE_BACK:String = "back";

		public static const BTN_TYPE_MSG:String = "msg";

		public static const BTN_TYPE_VIEW:String = "view";

		private var _btnType:String;

		private var viewWidth:int;

		private var viewHeight:int;

		private var _mousep:Point = new Point();

		public function EnsvView(viewWidth:int, viewHeight:int) {
			this.viewWidth = viewWidth;
			this.viewHeight = viewHeight;
			this.addEventListener(Event.ENTER_FRAME, handlerEnterFrame);
		}

		private function handlerEnterFrame(e:Event):void {
			this.removeEventListener(Event.ENTER_FRAME, handlerEnterFrame);

			var btn:MovieClip = this.getChildByName("backBtn") as MovieClip;
			btn.x = viewWidth - btn.width - 50;

			var back:MovieClip = this.getChildByName("back") as MovieClip;
			back.width = viewWidth;
			back.height = viewHeight;

			addEvent("mapBtn", BTN_TYPE_MAP);
			addEvent("itemsBtn", BTN_TYPE_ITEMS);
			addEvent("introBtn", BTN_TYPE_INTRO);
			addEvent("backBtn", BTN_TYPE_BACK);
			addEvent("msgBtn", BTN_TYPE_MSG);
			addEvent("back", BTN_TYPE_VIEW);
		}

		private function addEvent(btnName:String, type:String):void {
			var mc:MovieClip = this;
			var mapBtn:MovieClip = this.getChildByName(btnName) as MovieClip;
			if (mapBtn != null) {
				mapBtn.buttonMode = true;
				mapBtn.addEventListener(MouseEvent.CLICK, function(e:Event):void {_mousep.x = stage.mouseX;_mousep.y = stage.mouseY;_btnType = type;mc.dispatchEvent(new Event(EVENT_BTN));});
			}
		}

		public function get btnType():String {
			return _btnType;
		}

		public function get mousep():Point {
			return _mousep;
		}

	}
}
