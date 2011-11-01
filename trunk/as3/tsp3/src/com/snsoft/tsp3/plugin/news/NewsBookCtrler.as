package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.Common;
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.tsp3.net.DataLoader;
	import com.snsoft.tsp3.net.DataSet;
	import com.snsoft.tsp3.net.ReqParams;
	import com.snsoft.tsp3.pagination.Pagination;
	import com.snsoft.tsp3.pagination.PaginationEvent;

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

		public function NewsBookCtrler(newsBook:NewsBook, pagin:Pagination) {
			super();
			this.newsBook = newsBook;
			this.pagin = pagin;

			init();
		}

		private function init():void {
			newsBook.addEventListener(NewsBook.EVENT_NEED_NEXT, handlerBookNext);
			newsBook.addEventListener(NewsBook.EVENT_NEED_PREV, handlerBookPrev);
			newsBook.addEventListener(NewsBook.EVENT_CHANGE_PAGE, handlerChangePage);
			newsBook.addEventListener(NewsBook.EVENT_ITEM_CLICK, handleritemClick);

			pagin.addEventListener(PaginationEvent.PAGIN_CLICK, handlerPaginBtnClick);
		}

		public function refresh(url:String, code:String, newsState:NewsState, size:Point = null, y:int = NaN):void {
			if (size != null) {
				newsBook.reSize(size);
			}
			if (!isNaN(y)) {
				newsBook.y = y;
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
			var dl:DataLoader = e.currentTarget as DataLoader;
			var rsv:Vector.<DataSet> = dl.data;

			var nbpv:Vector.<NewsBookPage> = new Vector.<NewsBookPage>();
			var itemv:Vector.<Sprite> = new Vector.<Sprite>();
			for (var i:int = 0; i < rsv.length; i++) {
				var rs:DataSet = rsv[i];

				var rowNum:int = int(rs.attr.columnNumber);
				rowNum = rowNum > 1 ? rowNum : 1;

				infoViewType = rs.attr.detailViewType;
				var itype:String = rs.attr.listViewType;
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

				if (MClass != null) {
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

					newsBook.pageCount = int(rs.attr.pageCount);
					var nextnum:int = int(newsBook.npNum);
					var curnum:int = int(newsBook.currentNum);
					var pCount:int = int(rs.attr.pageCount);
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
			if (sign) {
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
