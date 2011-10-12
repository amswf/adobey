package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.ViewUtil;
	import com.snsoft.util.SkinsUtil;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class NewsImgBtn extends Sprite {

		private var imgSize:Point = new Point();

		private var boader:int = 8;

		private var boader2:int = 8;

		private var img:BitmapData;

		private var tft:TextFormat = new TextFormat(null, 12, 0x000000);

		private var text:String;

		private var bw:int;

		private var _data:Object;

		private var selBack:Sprite;

		private var unSelBack:Sprite;

		public function NewsImgBtn(imgSize:Point, img:BitmapData, text:String, btnWidth:int) {
			super();
			this.imgSize = imgSize;
			this.img = img;
			this.text = text;
			this.bw = btnWidth;
			init();
		}

		private function init():void {

			var bm:Bitmap = new Bitmap(img, "auto", true);
			bm.width = imgSize.x;
			bm.height = imgSize.y;
			bm.x = boader;
			bm.y = boader2;

			var tw:int = bw - (imgSize.x + boader + boader + boader);
			var tfd:TextField = new TextField();
			tfd.defaultTextFormat = tft;
			tfd.width = tw;
			tfd.height = 17;
			tfd.text = text;
			ViewUtil.filterTfd(tfd);

			tfd.x = imgSize.x + boader + boader;
			tfd.y = (imgSize.x + boader2 + boader2 - tfd.height) / 2;

			var h:int = boader2 + imgSize.y + boader2;

			selBack = SkinsUtil.createSkinByName("NewsBtn_selectedBackSkin");
			selBack.visible = false;
			selBack.width = bw;
			selBack.height = h;

			unSelBack = SkinsUtil.createSkinByName("NewsBtn_unSelectedBackSkin");
			unSelBack.width = bw;
			unSelBack.height = h;

			var view:Sprite = ViewUtil.creatRect(bw, h);

			this.addChild(unSelBack);
			this.addChild(selBack);
			this.addChild(bm);
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
