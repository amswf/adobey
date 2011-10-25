package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.MySprite;
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.rlm.rs.RSEmbedFonts;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class NewsClassBtn extends Sprite {

		private var text:String;

		private var boader:int = 5;

		private var btnWidth:int;

		private var btnHeight:int;

		private var tft:TextFormat = new TextFormat(RSEmbedFonts.findFontByName("MicrosoftYaHei"), 14, 0xffffff);

		private var _data:DataDTO;

		private var selSkin:MovieClip;

		private var unSelSkin:MovieClip;

		public function NewsClassBtn(text:String) {
			super();
			this.text = text;
			init();
		}

		private function init():void {

			unSelSkin = SkinsUtil.createSkinByName("NewsClassBtn_unSelectedSkin");
			this.addChild(unSelSkin);

			selSkin = SkinsUtil.createSkinByName("NewsClassBtn_selectedSkin");
			selSkin.visible = false;
			this.addChild(selSkin);

			var tfd:TextField = new TextField();
			tfd.mouseEnabled = false;
			tfd.defaultTextFormat = tft;
			tfd.autoSize = TextFieldAutoSize.LEFT;
			tfd.embedFonts = true;
			tfd.antiAliasType = AntiAliasType.ADVANCED;
			tfd.gridFitType = GridFitType.PIXEL;
			tfd.thickness = 100;
			tfd.text = text;
			this.addChild(tfd);
			tfd.y = (unSelSkin.height - tfd.height) / 2;

			var maxw:int = Math.max(unSelSkin.width, tfd.width + boader + boader);
			tfd.x = (maxw - tfd.width) / 2;
			unSelSkin.width = maxw;
			selSkin.width = maxw;
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
