package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.Common;
	import com.snsoft.tsp3.MySprite;
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.tsp3.net.DataLoader;
	import com.snsoft.tsp3.net.DataSet;
	import com.snsoft.tsp3.net.ReqParams;
	import com.snsoft.tsp3.pagination.Pagination;
	import com.snsoft.tsp3.pagination.PaginationEvent;
	import com.snsoft.util.SkinsUtil;

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
			this.newsState = newsState;

			newsBook.gotoPage(1);
		}

		private function handlerPaginBtnClick(e:Event):void {
			var pagin:Pagination = e.currentTarget as Pagination;
			newsBook.gotoPage(pagin.pageNum);
			pagin.setPageNum(pagin.pageNum, newsBook.pageCount);
		}

		private function handleritemClick(e:Event):void {
			_clickItem = newsBook.clickItem;
			this.dispatchEvent(new Event(EVENT_ITEM_CLICK));
		}

		private function handlerChangePage(e:Event):void {
			trace("handlerChangePage");
			var curnum:int = int(newsBook.currentNum);
			var pCount:int = int(newsBook.pageCount);
			pagin.setPageNum(curnum, pCount);
		}

		private function handlerBookNext(e:Event):void {
			trace("handlerBookNext");
			loadInfoItems();
		}

		private function handlerBookPrev(e:Event):void {
			trace("handlerBookPrev");
			loadInfoItems();
		}

		private function loadInfoItems():void {
			var params:ReqParams = new ReqParams();
			params.addParam(Common.PARAM_PLATE, newsState.cPlateId);
			params.addParam(Common.PARAM_COLUMN, newsState.cColumnId);
			params.addParam(Common.PARAM_CLASS, newsState.cClassId);
			params.addParam(Common.PARAM_FILTER, newsState.filterStr());
			params.addParam(Common.PARAM_PAGE_NUM, String(1));
			params.addParam(Common.PARAM_DIGEST_LENGTH, String(newsState.digestLength));

			var dl:DataLoader = new DataLoader();
			dl.addEventListener(Event.COMPLETE, handlerSearchCmp);
			dl.addEventListener(IOErrorEvent.IO_ERROR, handlerSearchError);
			dl.loadData(url, code, Common.OPERATION_SEARCH, params);
		}

		private function handlerSearchCmp(e:Event):void {
			trace("handlerSearchCmp");
			var dl:DataLoader = e.currentTarget as DataLoader;
			var rsv:Vector.<DataSet> = dl.data;

			var nbv:Vector.<NewsBookPage> = new Vector.<NewsBookPage>();
			var itemv:Vector.<Sprite> = new Vector.<Sprite>();
			for (var i:int = 0; i < rsv.length; i++) {
				var rs:DataSet = rsv[i];

				var rowNum:int = int(rs.attr.rowNum);
				rowNum = rowNum > 1 ? rowNum : 1;

				var nbp:NewsBookPage = new NewsBookPage(new Point(newsBook.bookSize.x, 500), rowNum);
				var itype:String = rs.attr.listViewType;
				if (itype == null) {
					itype = NewsItemBase.ITEM_TYPE_I;
				}

				itemViewType = itype;

				for (var j:int = 0; j < rs.dtoList.length; j++) {
					var dto:DataDTO = rs.dtoList[j];
					var item:NewsItemBase;

					try {
						var MClass:Class;
						MClass = getDefinitionByName("com.snsoft.tsp3.plugin.news.NewsItem" + itype) as Class;
						item = new MClass(dto);
					}
					catch (error:Error) {
						trace(error.getStackTrace());
					}
					if (item != null) {
						nbp.addItem(item);
					}
				}

				newsBook.pageCount = int(rs.attr.pageCount);
				var nextnum:int = int(newsBook.npNum);
				var curnum:int = int(newsBook.currentNum);
				var pCount:int = int(rs.attr.pageCount);
				nbp.setPaginText(nextnum, pCount);
				nbv.push(nbp);
			}

			trace("newsBook.changeType:", newsBook.changeType);

			for (var k:int = 0; k < nbv.length; k++) {
				if (newsBook.changeType == NewsBook.CHANGE_TYPE_PREV) {
					trace("prev");
					newsBook.addPagePrev(nbp);
				}
				else if (newsBook.changeType == NewsBook.CHANGE_TYPE_NEXT) {
					trace("next");
					newsBook.addPageNext(nbp);
				}
			}
			this.dispatchEvent(new Event(EVENT_LOAD_COMPLETE));
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
