package com.snsoft.ensview {
	import fl.controls.TextArea;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class EnsvBoothMsg extends MovieClip {

		public static const EVENT_CLOSE:String = "EVENT_CLOSE";

		private var dNameTfd:TextField;

		private var dTextTfd:TextField;

		private var dDesTa:TextArea;

		private var dGoodsTa:TextArea;

		private var dLinkmanTfd:TextField;

		private var dPhoneTfd:TextField;

		private var dFaxTfd:TextField;

		private var dEmailTfd:TextField;

		private var dUrlTfd:TextField;

		private var dAddressTfd:TextField;

		private var dPostcodeTfd:TextField;

		private var dCloseBtn:MovieClip;

		private var ensvBoothMsgDO:EnsvBoothMsgDO;

		public function EnsvBoothMsg(ensvBoothMsgDO:EnsvBoothMsgDO) {
			super();
			this.ensvBoothMsgDO = ensvBoothMsgDO;
			this.addEventListener(Event.ENTER_FRAME, handlerEnterFrame);
		}

		private function handlerEnterFrame(e:Event):void {
			this.removeEventListener(Event.ENTER_FRAME, handlerEnterFrame);

			dNameTfd = this.getChildByName("nameTfd") as TextField;
			dTextTfd = this.getChildByName("textTfd") as TextField;
			dDesTa = this.getChildByName("desTa") as TextArea;
			dGoodsTa = this.getChildByName("goodsTa") as TextArea;
			dLinkmanTfd = this.getChildByName("linkmanTfd") as TextField;
			dPhoneTfd = this.getChildByName("phoneTfd") as TextField;
			dFaxTfd = this.getChildByName("faxTfd") as TextField;
			dEmailTfd = this.getChildByName("emailTfd") as TextField;
			dUrlTfd = this.getChildByName("urlTfd") as TextField;
			dAddressTfd = this.getChildByName("addressTfd") as TextField;
			dPostcodeTfd = this.getChildByName("postcodeTfd") as TextField;
			dCloseBtn = this.getChildByName("closeBtn") as MovieClip;

			var tft:TextFormat = new TextFormat("", 12);
			dDesTa.setStyle("textFormat", tft);
			dDesTa.setStyle("disabledTextFormat", tft);
			dGoodsTa.setStyle("textFormat", tft);
			dGoodsTa.setStyle("disabledTextFormat", tft);

			setText(dNameTfd, ensvBoothMsgDO.code);
			setText(dTextTfd, ensvBoothMsgDO.name);
			setText(dDesTa, ensvBoothMsgDO.des);
			setText(dGoodsTa, ensvBoothMsgDO.goods);
			setText(dLinkmanTfd, ensvBoothMsgDO.linkman);
			setText(dPhoneTfd, ensvBoothMsgDO.phone);
			setText(dFaxTfd, ensvBoothMsgDO.fax);
			setText(dEmailTfd, ensvBoothMsgDO.email);
			setText(dUrlTfd, ensvBoothMsgDO.url);
			setText(dAddressTfd, ensvBoothMsgDO.address);
			setText(dPostcodeTfd, ensvBoothMsgDO.postcode);

			dCloseBtn.buttonMode = true;
			dCloseBtn.addEventListener(MouseEvent.CLICK, handlerClose);
		}

		private function handlerClose(e:Event):void {
			this.dispatchEvent(new Event(EVENT_CLOSE));
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
	}
}
