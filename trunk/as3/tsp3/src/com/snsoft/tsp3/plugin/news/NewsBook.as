package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.MySprite;
	import com.snsoft.tsp3.ViewUtil;
	import com.snsoft.tsp3.touch.TouchDrag;
	import com.snsoft.tsp3.touch.TouchDragEvent;
	import com.snsoft.util.SpriteUtil;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class NewsBook extends MySprite {

		public static const NEED_NEXT:String = "needNext";

		public static const NEED_PREV:String = "needPrev";

		public static const CHANGE_PAGE:String = "changePage";

		private var _bookSize:Point;

		private var pageLayer:Sprite = new Sprite();

		private var maskLayer:Sprite = new Sprite();

		private var msk:Sprite = new Sprite();

		private var pagev:Vector.<NewsBookPage> = new Vector.<NewsBookPage>();

		private var td:TouchDrag;

		private var catchMax:int = 0;

		/**
		 * 要添加的下一个或上一个页的页号
		 */
		private var _npNum:int = 1;

		private var _currentNum:int = 1;

		private var _pageCount:int = 0;

		/**
		 * 拖动时，当前页上或下留白多少，便于拖动，要大于TouchDrag的灵敏度。
		 */
		private var space:int = 20;

		private var _changeType:String;

		public static const CHANGE_TYPE_PAGIN:String = "pagin";

		public static const CHANGE_TYPE_NEXT:String = "next";

		public static const CHANGE_TYPE_PREV:String = "prev";

		public function NewsBook(bookSize:Point, catchMax:int = 0) {
			super();
			this._bookSize = bookSize;
			this.catchMax = catchMax;

			this.addChild(pageLayer);
			this.addChild(maskLayer);
		}

		public function reSize(bookSize:Point):void {
			this._bookSize = bookSize;
			msk.width = bookSize.x;
			msk.height = bookSize.y;

			var dy:int = pageLayer.height - bookSize.y;
			dy = dy < 0 ? 0 : dy;
			td.dragBounds.y = -dy - space;
			td.dragBounds.height = dy + space + space;
		}

		override protected function init():void {
			msk = ViewUtil.creatRect(100, 100, 0xffffff, 1);
			maskLayer.addChild(msk);
			pageLayer.mask = maskLayer;

			var dragBounds:Rectangle = new Rectangle(0, 0, 0, 0);
			td = new TouchDrag(pageLayer, stage, dragBounds);
			td.addEventListener(TouchDragEvent.TOUCH_DRAG_MOUSE_UP, handlerTouchUp);

			reSize(bookSize);
		}

		public function gotoPage(pageNum:int):void {
			this._npNum = pageNum;
			SpriteUtil.deleteAllChild(pageLayer);
			pageLayer.y = 0;
			pagev.splice(0, pagev.length);
			dispatchEventNeedNext();
		}

		private function handlerTouchUp(e:Event):void {
			var rect:Rectangle = pageLayer.getRect(this);
			if (rect.bottom - 5 <= bookSize.y) {
				dispatchEventNeedNext();
			}
			else if (rect.top + 5 >= 0) {
				dispatchEventNeedPrev();
			}
			checkChangePage();
		}

		public function addPageNext(npage:NewsBookPage):void {
			var nexty:int = 0;
			if (pagev.length > 0) {
				var page:NewsBookPage = pagev[pagev.length - 1];
				nexty = page.y + page.height;
			}
			npage.y = nexty;
			pageLayer.addChild(npage);
			pagev.push(npage);

			var dh:int = 0;
			if (catchMax >= 0) {
				var dp:NewsBookPage = pagev[0];
				while (pagev.length > catchMax && dp.getRect(this).bottom < 0) {
					dh += dp.height;
					pageLayer.removeChild(dp);
					pagev.splice(0, 1);
					dp = pagev[0];
				}
			}

			var dy:int = pageLayer.height - bookSize.y;
			dy = dy < 0 ? 0 : dy;
			td.dragBounds.y = -dy - space;
			td.dragBounds.height = dy + space + space;

			for (var i:int = 0; i < pagev.length; i++) {
				var p:NewsBookPage = pagev[i];
				p.y -= dh;
			}
			pageLayer.y += dh;

			if (pageLayer.y + npage.y + npage.height < bookSize.y) {
				dispatchEventNeedNext();
			}
			checkChangePage();
		}

		public function addPagePrev(ppage:NewsBookPage):void {
			var prevy:int = 0;
			if (pagev.length > 0) {
				var page:NewsBookPage = pagev[0];
				prevy = page.y - ppage.height;
			}
			ppage.y = prevy;
			pageLayer.addChild(ppage);
			pagev.splice(0, 0, ppage);

			if (catchMax >= 0) {
				var dp:NewsBookPage = pagev[pagev.length - 1];
				while (pagev.length > catchMax && dp.getRect(this).y > bookSize.y) {
					pageLayer.removeChild(dp);
					pagev.pop();
					dp = pagev[pagev.length - 1];
				}
			}

			var dy:int = pageLayer.height - bookSize.y;
			dy = dy < 0 ? 0 : dy;
			td.dragBounds.y = -dy - space;
			td.dragBounds.height = dy + space + space;

			for (var i:int = 0; i < pagev.length; i++) {
				var p:NewsBookPage = pagev[i];
				p.y += ppage.height;
			}
			pageLayer.y -= ppage.height;

			if (pageLayer.y + ppage.y > 0) {
				dispatchEventNeedPrev();
			}
		}

		private function dispatchEventNeedNext():void {
			if (pagev.length > 0) {
				var ep:NewsBookPage = pagev[pagev.length - 1];
				_npNum = ep.pageNum + 1;
			}
			_changeType = CHANGE_TYPE_NEXT;
			this.dispatchEvent(new Event(NEED_NEXT));
		}

		private function dispatchEventNeedPrev():void {
			if (pagev.length > 0) {
				var fp:NewsBookPage = pagev[0];
				var n:int = fp.pageNum - 1;
				if (n >= 1) {
					_npNum = n;
					_changeType = CHANGE_TYPE_PREV;
					this.dispatchEvent(new Event(NEED_PREV));
				}
			}
		}

		private function checkChangePage():void {
			trace("checkChangePage");
			for (var i:int = 0; i < pagev.length; i++) {
				var page:NewsBookPage = pagev[i];
				var cr:Rectangle = page.getRect(this);
				if ((cr.y <= 0 && cr.bottom >= bookSize.y) || (cr.y <= bookSize.y / 2 && cr.bottom > bookSize.y / 2)) {
					_currentNum = page.pageNum;
					this.dispatchEvent(new Event(CHANGE_PAGE));
					break;
				}

			}
		}

		public function get bookSize():Point {
			return _bookSize;
		}

		public function get npNum():int {
			return _npNum;
		}

		public function get currentNum():int {
			return _currentNum;
		}

		public function get changeType():String {
			return _changeType;
		}

		public function get pageCount():int {
			return _pageCount;
		}

		public function set pageCount(value:int):void {
			_pageCount = value;
		}

	}
}
