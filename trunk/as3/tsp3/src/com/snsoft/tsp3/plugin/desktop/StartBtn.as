package com.snsoft.tsp3.plugin.desktop {
	import com.snsoft.tsp3.ViewUtil;
	import com.snsoft.util.UUID;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class StartBtn extends Sprite {

		private var imgSize:Point = new Point();

		private var boader:int = 2;

		private var img:BitmapData;

		private var _data:Object;

		private var _uuid:String;

		public function StartBtn(imgSize:Point, img:BitmapData, uuid:String = null) {
			super();
			this.imgSize = imgSize;
			this.img = img;

			if (uuid != null) {
				this._uuid = uuid;
			}
			else {
				this._uuid = UUID.create();
			}

			init();
		}

		private function init():void {

			var bm:Bitmap = new Bitmap(img, "auto", true);
			bm.width = imgSize.x;
			bm.height = imgSize.y;
			bm.x = boader;
			bm.y = boader;
			this.addChild(bm);

			var w:int = imgSize.x + boader + boader;
			var h:int = boader + imgSize.y + boader;
			var back:Sprite = ViewUtil.creatRect(w, h);
			this.addChild(back);
		}

		public function get data():Object {
			return _data;
		}

		public function set data(value:Object):void {
			_data = value;
		}

		public function get uuid():String {
			return _uuid;
		}

	}
}
