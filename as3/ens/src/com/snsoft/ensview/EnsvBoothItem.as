package com.snsoft.ensview {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class EnsvBoothItem extends MovieClip {

		public static const EVENT_CLOSE:String = "EVENT_CLOSE";

		private var dNameTfd:TextField;

		private var dTextTfd:TextField;

		private var dDesTa:TextField;

		private var _ensvBoothMsgDO:EnsvBoothMsgDO;

		public function EnsvBoothItem(ensvBoothMsgDO:EnsvBoothMsgDO) {
			super();
			this._ensvBoothMsgDO = ensvBoothMsgDO;
			this.addEventListener(Event.ENTER_FRAME, handlerEnterFrame);
		}

		private function handlerEnterFrame(e:Event):void {
			this.removeEventListener(Event.ENTER_FRAME, handlerEnterFrame);

			dNameTfd = this.getChildByName("nameTfd") as TextField;
			dTextTfd = this.getChildByName("textTfd") as TextField;
			dDesTa = this.getChildByName("desTa") as TextField;

			setText(dNameTfd, ensvBoothMsgDO.id);
			setText(dTextTfd, ensvBoothMsgDO.name);
			setText(dDesTa, ensvBoothMsgDO.des);
		}

		private function setText(tfd:*, value:String):void {
			if (value != null) {
				if (tfd != null) {
					tfd.text = value;
				}
				else {
					tfd.text = "";
				}
			}
		}

		public function get ensvBoothMsgDO():EnsvBoothMsgDO {
			return _ensvBoothMsgDO;
		}

	}
}
