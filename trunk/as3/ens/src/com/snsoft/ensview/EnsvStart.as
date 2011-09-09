package com.snsoft.ensview {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class EnsvStart extends MovieClip {

		private var dDownLoadBtn:MovieClip;

		private var dStartBtn:MovieClip;

		private var dCloseBtn:MovieClip;

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

			dDownLoadBtn = this.getChildByName("downLoadBtn") as MovieClip;
			dStartBtn = this.getChildByName("startBtn") as MovieClip;
			dCloseBtn = this.getChildByName("closeBtn") as MovieClip;

			dDownLoadBtn.buttonMode = true;
			dStartBtn.buttonMode = true;
			dCloseBtn.buttonMode = true;

			dMsgTfd = this.getChildByName("msgTfd") as TextField;

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
