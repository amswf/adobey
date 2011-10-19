package com.snsoft.ensview {
	import com.snsoft.util.SkinsUtil;

	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class TextMsg extends MovieClip {

		public static const EVENT_BTN:String = "EVENT_BTN";

		public static const BTN_TYPE_MAP:String = "map";

		public static const BTN_TYPE_INTRO:String = "intro";

		public static const BTN_TYPE_ITEMS:String = "items";

		public static const BTN_TYPE_BACK:String = "back";

		public static const BTN_TYPE_MSG:String = "msg";

		private var _btnType:String;

		private var rect:Rectangle;

		private var isMouseDown:Boolean = false;

		private var tttMc:MovieClip;

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

			tttMc = SkinsUtil.createSkinByName("TTT");
			this.addChild(tttMc);
			tttMc.x = 90;
			tttMc.y = 200;

			var spr:Sprite = new Sprite();
			var gri:Graphics = spr.graphics;
			gri.beginFill(0xffffff, 1);
			gri.drawRect(0, 0, 100, 100);
			gri.endFill();
			this.addChild(spr);
			spr.x = 90;
			spr.y = 200;
			spr.width = 790;
			spr.height = 450;
			tttMc.mask = spr;

			var sb:ScrollBar = new ScrollBar(450, tttMc.height);
			sb.x = 90 + 790;
			sb.y = 200;
			this.addChild(sb);
			sb.addEventListener(ScrollBar.EVENT_SCROLLING, function(e:Event):void {tttMc.y = (450 - tttMc.height) * sb.getScrollValue()});
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
