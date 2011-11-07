package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.Common;
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.tsp3.net.DataLoader;
	import com.snsoft.tsp3.net.DataSet;
	import com.snsoft.tsp3.net.ReqParams;
	import com.snsoft.tsp3.pagination.Pagination;
	import com.snsoft.tsp3.pagination.PaginationEvent;
	import com.snsoft.util.SpriteUtil;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;

	public class NewsBookCtrler extends EventDispatcher {

		public static const EVENT_ITEM_CLICK:String = "eventItemClick";

		public static const EVENT_LOAD_COMPLETE:String = "eventLoadComplete";

		private var newsBook:NewsBook;

		private var pagin:Pagination;

		private var url:String;

		private var code:String;

		private var newsState:NewsState;

		private var _clickItem:NewsItemBase;

		private var _itemViewType:String;

		private var _infoViewType:String;

		private var bookSize:Point = null;

		private var paginH:int = 0;

		private var bookHeadLayer:Sprite;

		private var bookHeadH:int = 0;

		private var bookY:int = 0;

		private var title:NewsInfoTitle;

		public function NewsBookCtrler(newsBook:NewsBook, pagin:Pagination, bookHeadLayer:Sprite, title:NewsInfoTitle = null) {
			super();
			this.newsBook = newsBook;
			this.pagin = pagin;
			this.bookHeadLayer = bookHeadLayer;
			this.title = title;
			init();
		}

		private function init():void {
			newsBook.addEventListener(NewsBook.EVENT_NEED_NEXT, handlerBookNext);
			newsBook.addEventListener(NewsBook.EVENT_NEED_PREV, handlerBookPrev);
			newsBook.addEventListener(NewsBook.EVENT_CHANGE_PAGE, handlerChangePage);
			newsBook.addEventListener(NewsBook.EVENT_ITEM_CLICK, handleritemClick);

			pagin.addEventListener(PaginationEvent.PAGIN_CLICK, handlerPaginBtnClick);
		}

		public function refresh(url:String, code:String, newsState:NewsState, bookSize:Point = null, paginH:int = 0, y:int = NaN):void {
			pagin.visible = false;
			bookHeadLayer.visible = false;
			this.bookSize = bookSize;
			this.paginH = paginH;
			if (!isNaN(y)) {
				bookY = y;
			}
			this.url = url;
			this.code = code;
			this.newsState = newsState.clone();
			newsBook.gotoPage(1);
		}

		private function handlerPaginBtnClick(e:Event):void {
			var pagin:Pagination = e.currentTarget as Pagination;
			newsBook.gotoPage(pagin.pageNum);
			pagin.setPageNum(pagin.pageNum, newsBook.pageCount);
		}

		private function handleritemClick(e:Event):void {
			if (_clickItem != null) {
				_clickItem.setSelected(false);
			}
			_clickItem = newsBook.clickItem;
			_clickItem.setSelected(true);
			this.dispatchEvent(new Event(EVENT_ITEM_CLICK));
		}

		private function handlerChangePage(e:Event):void {
			//trace("handlerChangePage");
			var curnum:int = int(newsBook.currentNum);
			var pCount:int = int(newsBook.pageCount);
			pagin.setPageNum(curnum, pCount);
		}

		private function handlerBookNext(e:Event):void {
			//trace("handlerBookNext");
			newsState.pageNum = newsBook.npNum;
			loadInfoItems();
		}

		private function handlerBookPrev(e:Event):void {
			//trace("handlerBookPrev");
			newsState.pageNum = newsBook.npNum;
			loadInfoItems();
		}

		private function loadInfoItems():void {
			var params:ReqParams = newsState.toParams();
			var dl:DataLoader = new DataLoader();
			dl.addEventListener(Event.COMPLETE, handlerSearchCmp);
			dl.addEventListener(IOErrorEvent.IO_ERROR, handlerSearchError);
			dl.loadData(url, code, Common.OPERATION_SEARCH, params);
		}

		private function handlerSearchCmp(e:Event):void {
			//trace("handlerSearchCmp");
			SpriteUtil.deleteAllChild(bookHeadLayer);

			var dl:DataLoader = e.currentTarget as DataLoader;
			var rsv:Vector.<DataSet> = dl.data;

			var nbpv:Vector.<NewsBookPage> = new Vector.<NewsBookPage>();
			var itemv:Vector.<Sprite> = new Vector.<Sprite>();
			for (var i:int = 0; i < rsv.length; i++) {
				var rs:DataSet = rsv[i];

				var rowNum:int = int(newsState.columnNumber);
				rowNum = rowNum > 1 ? rowNum : 1;

				infoViewType = newsState.detailViewType;
				var itype:String = newsState.listViewType;
				if (itype == null) {
					itype = NewsItemBase.ITEM_TYPE_I;
				}

				itemViewType = itype;

				var MClass:Class = null;
				try {
					MClass = getDefinitionByName("com.snsoft.tsp3.plugin.news.NewsItem" + itype) as Class;
				}
				catch (error:Error) {
					trace("找不到[列表]显示类型：" + itype);
				}
				var items:Vector.<NewsItemBase> = new Vector.<NewsItemBase>();

				bookHeadH = 0;
				if (MClass != null) {
					if (rs.dtoList.length > 0) {
						if (newsState.listViewType == "IV") {
							var nbh:NewsItemHead = new NewsItemHead(rs.dtoList[0]);
							nbh.itemWidth = newsBook.bookSize.x;
							bookHeadLayer.addChild(nbh);
							nbh.y = bookY;
							nbh.draw();
							bookHeadH = nbh.height;
						}
					}

					for (var j:int = 0; j < rs.dtoList.length; j++) {
						var dto:DataDTO = rs.dtoList[j];
						var item:NewsItemBase = new MClass(dto);
						items.push(item);
					}
				}
				if (items.length > 0) {
					var nbp:NewsBookPage = new NewsBookPage(new Point(newsBook.bookSize.x, 500), rowNum);
					for (var i2:int = 0; i2 < items.length; i2++) {
						var itm:NewsItemBase = items[i2];
						nbp.addItem(itm);
					}

					var nextnum:int = int(newsBook.npNum);
					var curnum:int = int(newsBook.currentNum);
					var pCount:int = int(rs.attr.pageCount);
					newsBook.pageCount = pCount;
					nbp.setPaginText(nextnum, pCount);
					nbpv.push(nbp);
				}
			}

			//trace("newsBook.changeType:", newsBook.changeType);
			var sign:Boolean = false;
			if (newsBook.changeType == NewsBook.CHANGE_TYPE_PREV) {
				//trace("prev");
				for (var k:int = 0; k < nbpv.length; k++) {
					var knbp:NewsBookPage = nbpv[k];
					newsBook.addPagePrev(knbp);
					sign = true;
				}
			}
			else if (newsBook.changeType == NewsBook.CHANGE_TYPE_NEXT) {
				//trace("next");
				for (var k2:int = 0; k2 < nbpv.length; k2++) {
					var k2nbp:NewsBookPage = nbpv[k2];
					newsBook.addPageNext(k2nbp);
					sign = true;
				}
			}
			if (bookSize != null) {
				var pp:Point = new Point();
				if (pCount <= 1) {
					pagin.visible = false;
				}
				else {
					pagin.visible = true;
					pp.y = pagin.height + 10 + 10;
				}
				pp.y += bookHeadH;

				var tp:Point = new Point(0, 0);
				var by:int = 0;
				if (title != null) {
					tp.y = title.height;
					by = title.y + tp.y;
				}
				var bs:Point = bookSize.subtract(pp).subtract(tp);
				newsBook.reSize(bs);
				newsBook.y = bookY + bookHeadH + by;
			}
			bookHeadLayer.visible = true;
			if (sign && newsBook.addPageCmp) {
				this.dispatchEvent(new Event(EVENT_LOAD_COMPLETE));
			}
		}

		private function handlerSearchError(e:Event):void {

		}

		public function get clickItem():NewsItemBase {
			return _clickItem;
		}

		public function get itemViewType():String {
			return _itemViewType;
		}

		public function set itemViewType(value:String):void {
			_itemViewType = value;
		}

		public function get infoViewType():String {
			return _infoViewType;
		}

		public function set infoViewType(value:String):void {
			_infoViewType = value;
		}

	}
}
