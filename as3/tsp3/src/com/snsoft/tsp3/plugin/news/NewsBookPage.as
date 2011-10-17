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

		private var itemsWidth:int;

		private var pb:MovieClip;

		private var _itemv:Vector.<NewsItemBase> = new Vector.<NewsItemBase>();

		/**
		 * 行数
		 */
		private var col:int = 0;

		/**
		 * 列数
		 */
		private var row:int = 0;

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
			nib.itemWidth = itemsWidth;
			nib.draw();
			itemsLayer.addChild(nib);
			nib.buttonMode = true;
			nib.mouseChildren = false;

			if (nib.autoRow) {
				if (row == 0) {
					itemsh += nib.height;
				}
				nib.x = row * nib.width + boaderf + boader;
				nib.y = col * nib.height + boaderi;
				row++;
				if ((row + 1) * nib.width > itemsWidth) {
					col++;
					row = 0;
				}
			}
			else {
				nib.x = boaderf + boader;
				nib.y = itemsh;
				itemsh += nib.height;
			}

			itemv.push(nib);
			var h:int = itemsh + boaderi;
			pb.height = Math.max(h, pageSize.y);
		}

		private function init():void {
			itemsWidth = pageSize.x - boader - boaderf - boader - boaderf;

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

		public function get itemv():Vector.<NewsItemBase> {
			return _itemv;
		}

	}
}
