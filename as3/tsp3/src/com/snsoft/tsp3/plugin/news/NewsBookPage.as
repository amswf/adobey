package com.snsoft.tsp3.plugin.news {
	import com.snsoft.util.SkinsUtil;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class NewsBookPage extends Sprite {

		private var pageSize:Point;

		private var _pageNum:int;

		private var pageCount:int;

		private var boaderi:int = 35;

		private var boaderf:int = 15;

		private var boader:int = 10;

		private var defTft:TextFormat = new TextFormat(null, 12);

		private var topPageText:TextField;

		private var bottomPageText:TextField;

		private var backLayer:Sprite = new Sprite();

		private var paginLayer:Sprite = new Sprite();

		private var itemsLayer:Sprite = new Sprite();

		private var items:Vector.<Sprite>;

		public function NewsBookPage(pageSize:Point, items:Vector.<Sprite>, pageNum:int, pageCount:int) {
			this.pageSize = pageSize;
			this.items = items;
			this.pageCount = pageCount;
			this._pageNum = pageNum;

			this.addChild(backLayer);
			this.addChild(paginLayer);
			this.addChild(itemsLayer);

			init();
		}

		private function init():void {

			var itemsh:int = 0;
			itemsh += boaderi;

			for (var i:int = 0; i < items.length; i++) {
				var spr:Sprite = items[i];
				itemsLayer.addChild(spr);
				spr.x = boaderf + boader;
				spr.y = itemsh;
				itemsh += spr.height;
			}

			itemsh += boaderi;

			trace(itemsh);

			var pb:MovieClip = SkinsUtil.createSkinByName("NewsBookPage_backSkin");
			pb.width = pageSize.x;
			pb.height = Math.max(itemsh, pageSize.y);
			backLayer.addChild(pb);

			topPageText = new TextField();
			paginLayer.addChild(topPageText);

			bottomPageText = new TextField();
			paginLayer.addChild(bottomPageText);

			setPagin(pageNum, pageCount);
		}

		private function setPagin(pageNum:int, pageCount:int):void {
			this.pageCount = pageCount;
			this._pageNum = pageNum;

			topPageText.mouseEnabled = false;
			topPageText.defaultTextFormat = defTft;
			topPageText.autoSize = TextFieldAutoSize.LEFT;
			topPageText.text = "" + pageNum + " / " + pageCount;
			topPageText.x = pageSize.x - topPageText.width - boaderf - boader;
			topPageText.y = boaderf;

			bottomPageText.mouseEnabled = false;
			bottomPageText.defaultTextFormat = defTft;
			bottomPageText.autoSize = TextFieldAutoSize.LEFT;
			bottomPageText.text = "" + pageNum + " / " + pageCount;
			bottomPageText.x = pageSize.x - topPageText.width - boaderf - boader;
			bottomPageText.y = backLayer.height - boaderf - bottomPageText.height;
		}

		public function get pageNum():int {
			return _pageNum;
		}

	}
}
