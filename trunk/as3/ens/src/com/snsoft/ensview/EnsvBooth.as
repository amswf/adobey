package com.snsoft.ensview {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class EnsvBooth extends Sprite {

		private var ensvBoothDO:EnsvBoothDO;

		private var _order:int;

		private var _panes:Vector.<EnsvPane> = new Vector.<EnsvPane>();

		public function paneNum():int {
			return panes.length;
		}

		public function EnsvBooth(ensvBoothDO:EnsvBoothDO) {
			super();
			this.ensvBoothDO = ensvBoothDO;
			init();
		}

		private function init():void {
			this.mouseChildren = false;
			this.buttonMode = true;
			if (ensvBoothDO != null) {
				var paneDOs:Vector.<EnsvPaneDO> = ensvBoothDO.paneDOs;
				for (var i:int = 0; i < paneDOs.length; i++) {
					var pdo:EnsvPaneDO = paneDOs[i];
					var pane:EnsvPane = new EnsvPane(pdo);
					pane.x = pdo.col * pdo.width;
					pane.y = pdo.row * pdo.height;
					this.addChild(pane);
					panes.push(pane);
				}

				if (paneDOs.length > 0) {
					var fpdo:EnsvPaneDO = paneDOs[0];
					var tft:TextFormat = new TextFormat("", 13, 0x000000);
					var tfd:TextField = new TextField();
					tfd.autoSize = TextFieldAutoSize.LEFT;
					tfd.mouseEnabled = false;
					tfd.defaultTextFormat = tft;
					if (ensvBoothDO.text != null) {
						tfd.text = ensvBoothDO.text;
					}
					tfd.x = fpdo.col * fpdo.width;
					tfd.y = fpdo.row * fpdo.height;
					this.addChild(tfd);
				}
			}
		}

		public function get order():int {
			return _order;
		}

		public function set order(value:int):void {
			_order = value;
		}

		public function get panes():Vector.<EnsvPane> {
			return _panes;
		}

	}
}
