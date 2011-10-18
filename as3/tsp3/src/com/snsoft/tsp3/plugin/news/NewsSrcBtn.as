package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.ViewUtil;
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.SpriteUtil;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class NewsSrcBtn extends Sprite {

		private var boader:int = 8;

		private var boader2:int = 8;

		private var tft:TextFormat = new TextFormat(null, 12, 0x000000);

		private var text:String;

		private var bw:int;

		private var _data:Object;

		private var selBack:Sprite;

		private var unSelBack:Sprite;

		private var btnSkinName:String;

		public function NewsSrcBtn(btnSkinName:String, text:String, btnWidth:int) {
			super();
			this.btnSkinName = btnSkinName;
			this.text = text;
			this.bw = btnWidth;
			init();
		}

		private function init():void {

			var btnSkin:MovieClip = SkinsUtil.createSkinByName(btnSkinName);
			btnSkin.x = boader;
			btnSkin.y = boader;

			var tw:int = bw - (btnSkin.width + boader + boader + boader);
			var tfd:TextField = new TextField();
			tfd.defaultTextFormat = tft;
			tfd.width = tw;
			tfd.height = 17;
			tfd.text = text;
			ViewUtil.filterTfd(tfd);

			tfd.x = btnSkin.width + boader + boader;
			tfd.y = (btnSkin.width + boader2 + boader2 - tfd.height) / 2;

			var h:int = boader2 + btnSkin.height + boader2;

			selBack = SkinsUtil.createSkinByName("NewsSrcBtn_selectedBackSkin");
			selBack.visible = false;
			selBack.width = bw;
			selBack.height = h;

			unSelBack = SkinsUtil.createSkinByName("NewsSrcBtn_unSelectedBackSkin");
			unSelBack.width = bw;
			unSelBack.height = h;

			var view:Sprite = ViewUtil.creatRect(bw, h);

			this.addChild(unSelBack);
			this.addChild(selBack);
			this.addChild(btnSkin);
			this.addChild(tfd);
			this.addChild(view);
		}

		public function setSectcted(b:Boolean):void {
			selBack.visible = b;
		}

		public function get data():Object {
			return _data;
		}

		public function set data(value:Object):void {
			_data = value;
		}

	}
}
