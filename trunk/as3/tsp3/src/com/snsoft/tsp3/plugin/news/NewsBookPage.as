package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.Common;
	import com.snsoft.tsp3.plugin.news.layout.Util;
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.rlm.rs.RSEmbedFonts;

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

		private var defTft:TextFormat = new TextFormat(RSEmbedFonts.findFontByName(Common.FONT_HZGBYS), 14, 0x575757);

		private var topPageText:TextField;

		private var bottomPageText:TextField;

		private var backLayer:Sprite = new Sprite();

		private var paginLayer:Sprite = new Sprite();

		private var itemsLayer:Sprite = new Sprite();

		private var itemsh:int = boaderi;

		private var _itemsWidth:int;

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

		private var rowNum:int = 1;

		public function NewsBookPage(pageSize:Point, rowNum:int) {
			this.pageSize = pageSize;

			this.pageCount = pageCount;
			this._pageNum = pageNum;
			this.rowNum = rowNum;

			this.addChild(backLayer);
			this.addChild(paginLayer);
			this.addChild(itemsLayer);

			init();
		}

		public function addItem(nib:NewsItemBase):void {

			//nib.buttonMode = true;
			//nib.mouseChildren = false;
			if (nib.autoCol) {
				nib.draw();
				itemsLayer.addChild(nib);
			}
			else {
				nib.itemWidth = int(itemsWidth / rowNum);
				nib.draw();
				itemsLayer.addChild(nib);

			}

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

			itemv.push(nib);
			var h:int = itemsh + boaderi;
			pb.height = Math.max(h, pageSize.y);
		}

		private function init():void {
			_itemsWidth = pageSize.x - boader - boaderf - boader - boaderf;

			pb = SkinsUtil.createSkinByName("NewsBookPage_backSkin");
			pb.width = pageSize.x;
			backLayer.addChild(pb);

			topPageText = Util.ctntSameLine("", defTft);
			paginLayer.addChild(topPageText);

			bottomPageText = Util.ctntSameLine("", defTft);
			paginLayer.addChild(bottomPageText);

		}

		public function setPaginText(pageNum:int, pageCount:int):void {
			this.pageCount = pageCount;
			this._pageNum = pageNum;

			var text:String = "" + pageNum + "/" + pageCount;

			topPageText.text = text;
			topPageText.x = pageSize.x - topPageText.width - boaderf - boader;
			topPageText.y = boaderf;

			bottomPageText.text = text;
			bottomPageText.x = pageSize.x - topPageText.width - boaderf - boader;
			bottomPageText.y = backLayer.height - boaderf - bottomPageText.height;
		}

		public function get pageNum():int {
			return _pageNum;
		}

		public function get itemv():Vector.<NewsItemBase> {
			return _itemv;
		}

		public function get itemsWidth():int {
			return _itemsWidth;
		}

	}
}
