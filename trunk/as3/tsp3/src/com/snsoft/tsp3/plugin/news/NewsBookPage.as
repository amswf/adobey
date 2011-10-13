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

		private var itemsh:int = boaderi;

		private var pb:MovieClip;

		public function NewsBookPage(pageSize:Point) {
			this.pageSize = pageSize;

			this.pageCount = pageCount;
			this._pageNum = pageNum;

			this.addChild(backLayer);
			this.addChild(paginLayer);
			this.addChild(itemsLayer);

			init();
		}

		public function addItem(nib:NewsItemBase):void {
			nib.x = boaderf + boader;
			nib.y = itemsh;
			nib.itemWidth = pageSize.x - boader - boaderf - boader - boaderf;
			nib.draw();
			itemsLayer.addChild(nib);
			itemsh += nib.height;

			var h:int = itemsh + boaderi;
			pb.height = Math.max(h, pageSize.y);
		}

		private function init():void {

			pb = SkinsUtil.createSkinByName("NewsBookPage_backSkin");
			pb.width = pageSize.x;
			backLayer.addChild(pb);

			topPageText = new TextField();
			paginLayer.addChild(topPageText);

			bottomPageText = new TextField();
			paginLayer.addChild(bottomPageText);

		}

		public function setPaginText(pageNum:int, pageCount:int):void {
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
