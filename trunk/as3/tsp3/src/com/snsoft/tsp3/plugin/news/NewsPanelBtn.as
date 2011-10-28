package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.Common;
	import com.snsoft.tsp3.MySprite;
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.rlm.rs.RSEmbedFonts;
	
	import flash.display.MovieClip;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class NewsPanelBtn extends MySprite {

		private var text:String;

		private var boader:int = 5;

		private var btnWidth:int;

		private var btnHeight:int;

		private var _data:DataDTO;

		private var selSkin:MovieClip;

		private var unSelSkin:MovieClip;

		private var tfd:TextField;

		private var unSelectedSkin:String = "NewsPanelBtn_unSelectedSkin";

		private var selectedSkin:String = "NewsPanelBtn_selectedSkin";

		private var selTft:TextFormat = new TextFormat(RSEmbedFonts.findFontByName(Common.FONT_YH), 14, 0x666666);

		private var unSelTft:TextFormat = new TextFormat(RSEmbedFonts.findFontByName(Common.FONT_YH), 14, 0xffffff);

		public function NewsPanelBtn(text:String) {
			super();
			this.text = text;
		}

		override protected function draw():void {
			unSelSkin = SkinsUtil.createSkinByName(unSelectedSkin);
			this.addChild(unSelSkin);

			selSkin = SkinsUtil.createSkinByName(selectedSkin);
			selSkin.visible = false;
			this.addChild(selSkin);

			tfd = new TextField();
			tfd.mouseEnabled = false;
			tfd.defaultTextFormat = unSelTft;
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
			tfd.setTextFormat(b ? selTft : unSelTft);
		}

		public function get data():DataDTO {
			return _data;
		}

		public function set data(value:DataDTO):void {
			_data = value;
		}

	}
}
