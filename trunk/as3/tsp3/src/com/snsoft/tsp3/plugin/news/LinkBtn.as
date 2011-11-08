package com.snsoft.tsp3.plugin.news {
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

	public class LinkBtn extends Sprite {

		private var imgSize:Point = new Point();

		private var boader:int = 8;

		private var boader2:int = 3;

		private var tfdH:int = 17;

		private var img:BitmapData;

		private var tft:TextFormat = new TextFormat(null, 12, 0xffffff);

		private var text:String;

		private var _data:Object;

		private var _uuid:String;

		private var embedFonts:Boolean;

		public function LinkBtn(imgSize:Point, img:BitmapData, text:String, uuid:String = null, tft:TextFormat = null, embedFonts:Boolean = false) {
			super();
			this.imgSize = imgSize;
			this.img = img;
			this.text = text;

			if (uuid != null) {
				this._uuid = uuid;
			}
			else {
				this._uuid = UUID.create();
			}

			if (tft != null) {
				this.tft = tft;
			}

			this.embedFonts = embedFonts;
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
			tfd.embedFonts = embedFonts;
			tfd.antiAliasType = AntiAliasType.ADVANCED;
			tfd.gridFitType = GridFitType.PIXEL;
			tfd.thickness = 100;
			tfd.width = w;
			tfd.height = tfdH;
			tfd.autoSize = TextFieldAutoSize.CENTER;
			tfd.text = text;
			ViewUtil.filterTfd(tfd);
			this.addChild(tfd);

			tfd.x = (w - tfd.width) / 2;
			tfd.y = boader + imgSize.y + boader2;

			var h:int = boader + imgSize.y + boader2 + tfdH + boader;
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
