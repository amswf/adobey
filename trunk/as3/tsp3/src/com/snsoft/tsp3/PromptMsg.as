package com.snsoft.tsp3 {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class PromptMsg extends MyMovieClip {

		public static const EVENT_BTN_CLICK:String = "event_btn_click";

		private var msgTfd:TextField;

		private var btnMc:MovieClip;

		public function PromptMsg() {
			super();
		}

		override protected function init():void {
			msgTfd = this.getChildByName("msg") as TextField;
			btnMc = this.getChildByName("btn") as MovieClip;
			btnMc.mouseChildren = false;
			btnMc.buttonMode = true;
			btnMc.addEventListener(MouseEvent.CLICK, handlerBtnClick);
		}

		private function handlerBtnClick(e:Event):void {
			this.dispatchEvent(new Event(EVENT_BTN_CLICK));
		}

		public function setMsg(msg:String):void {
			this.msgTfd.text = msg;
		}
	}
}
