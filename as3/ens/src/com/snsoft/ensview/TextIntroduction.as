package com.snsoft.ensview {

	import com.snsoft.util.SkinsUtil;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class TextIntroduction extends MovieClip {

		public static const EVENT_BTN:String = "EVENT_BTN";

		public static const BTN_TYPE_MAP:String = "map";

		public static const BTN_TYPE_BACK:String = "back";

		private var src:MovieClip;

		private var btnType:String;

		public function TextIntroduction() {
			super();
			this.addEventListener(Event.ENTER_FRAME, handlerEnterFrame);
		}

		private function handlerEnterFrame(e:Event):void {
			this.removeEventListener(Event.ENTER_FRAME, handlerEnterFrame);

			var mapBtn:MovieClip = this.getChildByName("mapBtn") as MovieClip;
			mapBtn.buttonMode = true;
			mapBtn.addEventListener(MouseEvent.CLICK, handlerMapClick);

			var backBtn:MovieClip = this.getChildByName("backBtn") as MovieClip;
			backBtn.buttonMode = true;
			backBtn.addEventListener(MouseEvent.CLICK, handlerBackClick);

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

		public function getBtnType():String {
			return btnType;
		}

		private function handlerScrolling(e:Event):void {
			var scrollBar:ScrollBar = e.currentTarget as ScrollBar;
			var sv:Number = scrollBar.getScrollValue();
			src.y = 290 - (src.height - 320) * sv;
		}

		private function handlerMapClick(e:Event):void {
			btnType = BTN_TYPE_MAP;
			this.dispatchEvent(new Event(EVENT_BTN));
		}

		private function handlerBackClick(e:Event):void {
			btnType = BTN_TYPE_BACK;
			this.dispatchEvent(new Event(EVENT_BTN));
		}
	}
}
