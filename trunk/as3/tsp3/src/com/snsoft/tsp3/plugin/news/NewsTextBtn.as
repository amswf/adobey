package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.MySprite;
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.util.SkinsUtil;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class NewsTextBtn extends Sprite {

		private var text:String;

		private var boader:int = 5;

		private var boader2:int = 10;

		private var btnWidth:int;

		private var btnHeight:int;

		private var tft:TextFormat = new TextFormat(null, 12, 0xffffff);

		private var _data:DataDTO;

		public function NewsTextBtn(text:String) {
			super();
			this.text = text;
			init();
		}

		private function init():void {

			var tfd:TextField = new TextField();
			tfd.defaultTextFormat = tft;
			tfd.autoSize = TextFieldAutoSize.LEFT;
			tfd.text = text;
			tfd.mouseEnabled = false;
			tfd.x = boader;
			tfd.y = boader2;

			var back:MovieClip = SkinsUtil.createSkinByName("NewsTextBtn_backSkin");
			this.addChild(back);
			back.width = tfd.width + boader + boader;
			back.height = tfd.height + boader2 + boader2;

			this.addChild(back);
			this.addChild(tfd);
		}

		public function get data():DataDTO {
			return _data;
		}

		public function set data(value:DataDTO):void {
			_data = value;
		}

	}
}
