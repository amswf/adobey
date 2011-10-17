package com.snsoft.ensview {

	import com.snsoft.util.SkinsUtil;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class TextIntroduction extends MovieClip {

		public static const EVENT_BTN:String = "EVENT_BTN";

		public static const BTN_TYPE_MAP:String = "map";

		public static const BTN_TYPE_INTRO:String = "intro";

		public static const BTN_TYPE_ITEMS:String = "items";

		public static const BTN_TYPE_BACK:String = "back";
		
		public static const BTN_TYPE_MSG:String = "msg";

		private var src:MovieClip;

		private var _btnType:String;

		public function TextIntroduction() {
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

			var mask:MovieClip = SkinsUtil.createSkinByName("HiddenBtn");
			this.addChild(mask);
			mask.width = 410;
			mask.height = 320;
			mask.x = 85;
			mask.y = 290;

			src = SkinsUtil.createSkinByName("IntroContent");
			this.addChild(src);
			src.x = 85;
			src.y = 290;
			src.mask = mask;

			var scrollBar:ScrollBar = new ScrollBar(320, src.height);
			scrollBar.x = mask.getRect(this).right;
			scrollBar.y = 290;
			this.addChild(scrollBar);
			scrollBar.addEventListener(ScrollBar.EVENT_SCROLLING, handlerScrolling);

		}

		private function handlerScrolling(e:Event):void {
			var scrollBar:ScrollBar = e.currentTarget as ScrollBar;
			var sv:Number = scrollBar.getScrollValue();
			src.y = 290 - (src.height - 320) * sv;
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
