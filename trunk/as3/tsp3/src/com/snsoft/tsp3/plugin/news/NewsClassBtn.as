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

	public class NewsClassBtn extends MySprite {

		private var text:String;

		private var boader:int = 5;

		private var btnWidth:int;

		private var btnHeight:int;

		private var _data:DataDTO;

		private var selSkin:MovieClip;

		private var unSelSkin:MovieClip;

		private var tfd:TextField;

		private var _unSelectedSkin:String = "NewsClassBtn_unSelectedSkin";

		private var _selectedSkin:String = "NewsClassBtn_selectedSkin";

		private var _selTft:TextFormat = new TextFormat(RSEmbedFonts.findFontByName(Common.FONT_YH), 14, 0xffffff);

		private var _unSelTft:TextFormat = new TextFormat(RSEmbedFonts.findFontByName(Common.FONT_YH), 14, 0xffffff);

		public function NewsClassBtn(text:String) {
			super();
			this.text = text;
			this.unSelectedSkin = unSelectedSkin;
			this.selectedSkin = selectedSkin;

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

		public function get unSelectedSkin():String {
			return _unSelectedSkin;
		}

		public function set unSelectedSkin(value:String):void {
			_unSelectedSkin = value;
		}

		public function get selectedSkin():String {
			return _selectedSkin;
		}

		public function set selectedSkin(value:String):void {
			_selectedSkin = value;
		}

		public function get selTft():TextFormat {
			return _selTft;
		}

		public function set selTft(value:TextFormat):void {
			_selTft = value;
		}

		public function get unSelTft():TextFormat {
			return _unSelTft;
		}

		public function set unSelTft(value:TextFormat):void {
			_unSelTft = value;
		}

	}
}
