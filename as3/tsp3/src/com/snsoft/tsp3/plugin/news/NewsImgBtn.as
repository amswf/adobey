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

		private var tw:int;

		private var _data:Object;

		private var selBack:Sprite;

		public function NewsImgBtn(imgSize:Point, img:BitmapData, text:String, textWidth:int) {
			super();
			this.imgSize = imgSize;
			this.img = img;
			this.text = text;
			this.tw = textWidth;
			init();
		}

		private function init():void {

			var w:int = imgSize.x + boader + boader + tw;
			var bm:Bitmap = new Bitmap(img, "auto", true);
			bm.width = imgSize.x;
			bm.height = imgSize.y;
			bm.x = boader;
			bm.y = boader2;

			var tfd:TextField = new TextField();
			tfd.defaultTextFormat = tft;
			tfd.width = tw;
			tfd.height = 17;
			tfd.autoSize = TextFieldAutoSize.CENTER;
			tfd.text = text;
			ViewUtil.filterTfd(tfd);

			tfd.x = imgSize.x + boader + boader;
			tfd.y = (imgSize.x + boader2 + boader2 - tfd.height) / 2;

			var h:int = boader2 + imgSize.y + boader2;

			selBack = SkinsUtil.createSkinByName("NewsBtn_selectedBackSkin");
			selBack.width = w;
			selBack.height = h;

			var view:Sprite = ViewUtil.creatRect(w, h);

			this.addChild(selBack);
			this.addChild(bm);
			this.addChild(tfd);
			this.addChild(view);
		}

		public function get data():Object {
			return _data;
		}

		public function set data(value:Object):void {
			_data = value;
		}

	}
}
