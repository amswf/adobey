package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.Common;
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.rlm.rs.RSEmbedFonts;
	
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

		private var tft:TextFormat = new TextFormat(RSEmbedFonts.findFontByName(Common.FONT_YH), 15, 0xffffff);

		private var _data:DataDTO;

		private var selSkin:MovieClip;

		private var unSelSkin:MovieClip;

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

			unSelSkin = SkinsUtil.createSkinByName("NewsTextBtn_unSelectedSkin");
			unSelSkin.width = tfd.width + boader + boader;
			unSelSkin.height = tfd.height + boader2 + boader2;

			selSkin = SkinsUtil.createSkinByName("NewsTextBtn_selectedSkin");
			selSkin.visible = false;
			selSkin.width = tfd.width + boader + boader;
			selSkin.height = tfd.height + boader2 + boader2;

			this.addChild(unSelSkin);
			this.addChild(selSkin);
			this.addChild(tfd);
		}

		public function setSectcted(b:Boolean):void {
			selSkin.visible = b;
		}

		public function get data():DataDTO {
			return _data;
		}

		public function set data(value:DataDTO):void {
			_data = value;
		}

	}
}
