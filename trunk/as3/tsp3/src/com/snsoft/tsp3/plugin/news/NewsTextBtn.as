package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.MySprite;
	import com.snsoft.util.SkinsUtil;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class NewsTextBtn extends Sprite {

		private var text:String;

		private var btnWidth:int;

		private var btnHeight:int;

		private var tft:TextFormat = new TextFormat(null, 12, 0x000000);

		public function NewsTextBtn(text:String, btnWidth:int, btnHeight:int) {
			super();
			this.text = text;
			this.btnWidth = btnWidth;
			this.btnHeight = btnHeight;
			init();
		}

		private function init():void {

			var back:MovieClip = SkinsUtil.createSkinByName("NewsTextBtn_backSkin");
			this.addChild(back);
			back.width = btnWidth;
			back.height = btnHeight;
			this.addChild(back);

			var tfd:TextField = new TextField();
			tfd.defaultTextFormat = tft;
			tfd.width = btnWidth;
			tfd.height = btnHeight;
			tfd.autoSize = TextFieldAutoSize.CENTER;
			tfd.text = text;
			tfd.mouseEnabled = false;
			this.addChild(tfd);
		}
	}
}
