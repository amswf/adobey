package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.Common;
	import com.snsoft.tsp3.MySprite;
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.tsp3.net.DataLoader;
	import com.snsoft.tsp3.net.DataSet;
	import com.snsoft.tsp3.net.Params;
	import com.snsoft.tsp3.pagination.Pagination;
	import com.snsoft.tsp3.pagination.PaginationEvent;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;

	public class NewsBookCtrler extends EventDispatcher {

		private var newsBook:NewsBook;

		private var pagin:Pagination;

		private var url:String;

		private var code:String;

		private var params:Params;

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

		public function refresh(url:String, code:String, parmas:Params, size:Point = null, y:int = NaN):void {
			if (size != null) {
				newsBook.reSize(size);
			}
			if (!isNaN(y)) {
				newsBook.y = y;
			}
			this.url = url;
			this.code = code;
			this.params = params;

			newsBook.gotoPage(1);
		}

		private function handlerPaginBtnClick(e:Event):void {
			var pagin:Pagination = e.currentTarget as Pagination;
			newsBook.gotoPage(pagin.pageNum);
			pagin.setPageNum(pagin.pageNum, newsBook.pageCount);
		}

		private function handleritemClick(e:Event):void {
			var dto:DataDTO = newsBook.clickItem.data;

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
			var dl:DataLoader = new DataLoader();
			dl.addEventListener(Event.COMPLETE, handlerSearchCmp);
			dl.addEventListener(IOErrorEvent.IO_ERROR, handlerSearchError);
			dl.loadData(url, code, Common.OPERATION_SEARCH, params);
		}

		private function handlerSearchCmp(e:Event):void {
			trace("handlerSearchCmp");
			var dl:DataLoader = e.currentTarget as DataLoader;
			var rsv:Vector.<DataSet> = dl.data;

			var nbp:NewsBookPage = new NewsBookPage(new Point(newsBook.bookSize.x, 500));

			var itemv:Vector.<Sprite> = new Vector.<Sprite>();
			for (var i:int = 0; i < rsv.length; i++) {
				var rs:DataSet = rsv[i];

				var itype:String = rs.attr.listViewType;
				if (itype == null) {
					itype = NewsItemBase.ITEM_TYPE_I;
				}
				for (var j:int = 0; j < rs.dtoList.length; j++) {
					var dto:DataDTO = rs.dtoList[j];
					var item:NewsItemBase;
					if (itype == NewsItemBase.ITEM_TYPE_I) {
						item = new NewsItemI(dto);
						nbp.addItem(item);
					}
				}

				newsBook.pageCount = int(rs.attr.pageCount);
				var nextnum:int = int(newsBook.npNum);
				var curnum:int = int(newsBook.currentNum);
				var pCount:int = int(rs.attr.pageCount);
				nbp.setPaginText(nextnum, pCount);
			}

			trace("newsBook.changeType:", newsBook.changeType);

			if (newsBook.changeType == NewsBook.CHANGE_TYPE_PREV) {
				trace("prev");
				newsBook.addPagePrev(nbp);
			}
			if (newsBook.changeType == NewsBook.CHANGE_TYPE_NEXT) {
				trace("next");
				newsBook.addPageNext(nbp);
			}
		}

		private function handlerSearchError(e:Event):void {

		}

	}
}
