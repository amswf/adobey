package com.snsoft.tsp3.plugin.desktop {
	import com.snsoft.tsp3.ViewUtil;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class DesktopBtn extends Sprite {

		private var imgSize:Point = new Point();

		private var boader:int = 8;

		private var boader2:int = 3;

		private var img:BitmapData;

		private var tft:TextFormat = new TextFormat(null, 12, 0x000000);

		private var text:String;

		private var _data:Object;

		public function DesktopBtn(imgSize:Point, img:BitmapData, text:String) {
			super();
			this.imgSize = imgSize;
			this.img = img;
			this.text = text;
			init();
		}

		private function init():void {

			var w:int = imgSize.x + boader + boader;
			var bm:Bitmap = new Bitmap(img, "auto", true);
			bm.width = imgSize.x;
			bm.height = imgSize.y;
			bm.x = boader;
			bm.y = boader;
			this.addChild(bm);

			var tfd:TextField = new TextField();
			tfd.defaultTextFormat = tft;
			tfd.width = w;
			tfd.height = 17;
			tfd.autoSize = TextFieldAutoSize.CENTER;
			tfd.text = text;
			ViewUtil.filterTfd(tfd);
			this.addChild(tfd);

			tfd.x = (w - tfd.width) / 2;
			tfd.y = boader + imgSize.y + boader2;

			var h:int = boader + imgSize.y + boader2 + tfd.height + boader;
			var back:Sprite = ViewUtil.creatRect(w, h);
			this.addChild(back);
		}

		public function get data():Object {
			return _data;
		}

		public function set data(value:Object):void {
			_data = value;
		}

	}
}