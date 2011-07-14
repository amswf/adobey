package com.snsoft.ensview {
	import fl.controls.Button;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class EnsvStart extends MovieClip {

		private var dDownLoadBtn:Button;

		private var dStartBtn:Button;

		private var dCloseBtn:Button;

		private var dMsgTfd:TextField;

		public static const EVENT_DOWNLOAD:String = "EVENT_DOWNLOAD";

		public static const EVENT_START:String = "EVENT_START";

		public static const EVENT_CLOSE:String = "EVENT_CLOSE";

		public function EnsvStart() {
			super();
			this.addEventListener(Event.ENTER_FRAME, handlerEnterFrame);
		}

		private function handlerEnterFrame(e:Event):void {
			this.removeEventListener(Event.ENTER_FRAME, handlerEnterFrame);

			dDownLoadBtn = this.getChildByName("downLoadBtn") as Button;
			dStartBtn = this.getChildByName("startBtn") as Button;
			dCloseBtn = this.getChildByName("closeBtn") as Button;
			dMsgTfd = this.getChildByName("msgTfd") as TextField;
			var tft:TextFormat = new TextFormat("黑体", 16);
			dDownLoadBtn.setStyle("textFormat", tft);
			dStartBtn.setStyle("textFormat", tft);
			dCloseBtn.setStyle("textFormat", tft);

			dDownLoadBtn.addEventListener(MouseEvent.CLICK, handlerDownloadMouseClick);
			dStartBtn.addEventListener(MouseEvent.CLICK, handlerStartMouseClick);
			dCloseBtn.addEventListener(MouseEvent.CLICK, handlerCloseMouseClick);
		}

		private function handlerDownloadMouseClick(e:Event):void {
			this.dispatchEvent(new Event(EVENT_DOWNLOAD));
		}

		private function handlerStartMouseClick(e:Event):void {
			this.dispatchEvent(new Event(EVENT_START));
		}

		private function handlerCloseMouseClick(e:Event):void {
			this.dispatchEvent(new Event(EVENT_CLOSE));
		}

		public function setMsg(text:String):void {
			dMsgTfd.text = text;
		}
	}
}
