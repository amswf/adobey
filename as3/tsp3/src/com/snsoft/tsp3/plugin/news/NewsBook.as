package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.MySprite;
	import com.snsoft.tsp3.ViewUtil;
	import com.snsoft.tsp3.hand.HandGroup;
	import com.snsoft.tsp3.touch.TouchDrag;
	import com.snsoft.tsp3.touch.TouchDragEvent;
	import com.snsoft.util.SpriteUtil;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class NewsBook extends MySprite {

		public static const EVENT_NEED_NEXT:String = "needNext";

		public static const EVENT_NEED_PREV:String = "needPrev";

		public static const EVENT_CHANGE_PAGE:String = "changePage";

		public static const EVENT_ITEM_CLICK:String = "itemClick";

		private var _bookSize:Point;

		private var pageLayer:Sprite = new Sprite();

		private var maskLayer:Sprite = new Sprite();

		private var handLayer:Sprite = new Sprite();

		private var pages:Sprite = new Sprite();

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

		private var _clickItem:NewsItemBase;

		private var _addPageCmp:Boolean = false;

		private var handg:HandGroup;

		private var handX:int = 15;

		public function NewsBook(bookSize:Point, catchMax:int = 0) {
			this._bookSize = bookSize;
			this.catchMax = catchMax;

			this.addChild(pageLayer);
			this.addChild(maskLayer);
			this.addChild(handLayer);
			
			pageLayer.y = space;
			pageLayer.addChild(pages);
			super();
		}

		public function reSize(bookSize:Point):void {
			this._bookSize = bookSize;
			msk.width = bookSize.x;
			msk.height = bookSize.y;

			var dy:int = pages.height - bookSize.y + space + space;
			dy = dy < 0 ? 0 : dy;
			td.dragBounds.y = -dy;
			td.dragBounds.height = dy;

			handg.up.y = bookSize.y - handg.up.height;
			setHandsState();
		}

		private function setHandsState():void {
			handg.up.visible = !td.isEnd;
			handg.down.visible = !td.isStart;
		}

		override protected function configMS():void {

		}

		override protected function draw():void {
			msk = ViewUtil.creatRect(100, 100, 0xffffff, 1);
			maskLayer.addChild(msk);
			pageLayer.mask = maskLayer;

			var dragBounds:Rectangle = new Rectangle(0, 0, 0, 0);
			td = new TouchDrag(pages, stage, dragBounds);
			td.addEventListener(TouchDragEvent.TOUCH_DRAG_MOUSE_UP, handlerTouchUp);
			td.addEventListener(TouchDragEvent.TOUCH_CLICK, handlerTouchClick);

			handg = new HandGroup(40, 40);

			handg.down.visible = false;
			handLayer.addChild(handg.down);
			handg.down.x = handX;

			handg.up.visible = false;
			handLayer.addChild(handg.up);
			handg.up.x = handg.down.x;

			reSize(bookSize);
		}

		public function gotoPage(pageNum:int):void {
			this._npNum = pageNum;
			SpriteUtil.deleteAllChild(pages);
			pages.y = 0;
			pagev.splice(0, pagev.length);
			dispatchEventNeedNext();
		}

		private function handlerTouchClick(e:Event):void {
			_clickItem = td.clickObj as NewsItemBase;
			this.dispatchEvent(new Event(EVENT_ITEM_CLICK));
		}

		private function handlerTouchUp(e:Event):void {
			var rect:Rectangle = pages.getRect(this);
			if (rect.bottom - 5 <= bookSize.y) {
				dispatchEventNeedNext();
			}
			else if (rect.top + 5 >= 0) {
				dispatchEventNeedPrev();
			}
			setHandsState();
			checkChangePage();
		}

		public function addPageNext(npage:NewsBookPage):void {
			_addPageCmp = false;
			addTouchBtn(npage);

			var nexty:int = 0;
			if (pagev.length > 0) {
				var page:NewsBookPage = pagev[pagev.length - 1];
				nexty = page.y + page.height;
			}
			npage.y = nexty;
			pages.addChild(npage);
			pagev.push(npage);

			var dh:int = 0;
			if (catchMax >= 0) {
				var dp:NewsBookPage = pagev[0];
				while (pagev.length > catchMax && dp.getRect(this).bottom < 0) {
					dh += dp.height;
					removeTouchBtn(dp);
					pages.removeChild(dp);
					pagev.splice(0, 1);
					dp = pagev[0];
				}
			}

			var dy:int = pages.height - bookSize.y + space + space;
			dy = dy < 0 ? 0 : dy;
			td.dragBounds.y = -dy;
			td.dragBounds.height = dy;

			for (var i:int = 0; i < pagev.length; i++) {
				var p:NewsBookPage = pagev[i];
				p.y -= dh;
			}
			pages.y += dh;

			if (pages.y + npage.y + npage.height < bookSize.y) {
				dispatchEventNeedNext();
			}
			else {
				_addPageCmp = true;
			}
			td.refreshPlaceState();
			checkChangePage();
		}

		public function addPagePrev(ppage:NewsBookPage):void {
			_addPageCmp = false;
			addTouchBtn(ppage);

			var prevy:int = 0;
			if (pagev.length > 0) {
				var page:NewsBookPage = pagev[0];
				prevy = page.y - ppage.height;
			}
			ppage.y = prevy;
			pages.addChild(ppage);
			pagev.splice(0, 0, ppage);

			if (catchMax >= 0) {
				var dp:NewsBookPage = pagev[pagev.length - 1];
				while (pagev.length > catchMax && dp.getRect(this).y > bookSize.y) {
					removeTouchBtn(dp);
					pages.removeChild(dp);
					pagev.pop();
					dp = pagev[pagev.length - 1];
				}
			}

			var dy:int = pages.height - bookSize.y + space + space;
			dy = dy < 0 ? 0 : dy;
			td.dragBounds.y = -dy;
			td.dragBounds.height = dy;

			for (var i:int = 0; i < pagev.length; i++) {
				var p:NewsBookPage = pagev[i];
				p.y += ppage.height;
			}
			pages.y -= ppage.height;

			if (pages.y + ppage.y > 0) {
				dispatchEventNeedPrev();
			}
			else {
				_addPageCmp = true;
			}
			td.refreshPlaceState();
		}

		private function addTouchBtn(page:NewsBookPage):void {
			var itemv:Vector.<NewsItemBase> = page.itemv;
			if (itemv != null) {
				for (var j:int = 0; j < itemv.length; j++) {
					var item:NewsItemBase = itemv[j];
					td.addClickObj(item);
				}
			}
		}

		private function removeTouchBtn(page:NewsBookPage):void {
			var itemv:Vector.<NewsItemBase> = page.itemv;
			if (itemv != null) {
				for (var j:int = 0; j < itemv.length; j++) {
					var item:NewsItemBase = itemv[j];
					td.removeClickObj(item);
				}
			}
		}

		private function dispatchEventNeedNext():void {
			if (pagev.length > 0) {
				var ep:NewsBookPage = pagev[pagev.length - 1];
				_npNum = ep.pageNum + 1;
			}
			_changeType = CHANGE_TYPE_NEXT;
			this.dispatchEvent(new Event(EVENT_NEED_NEXT));
		}

		private function dispatchEventNeedPrev():void {
			if (pagev.length > 0) {
				var fp:NewsBookPage = pagev[0];
				var n:int = fp.pageNum - 1;
				if (n >= 1) {
					_npNum = n;
					_changeType = CHANGE_TYPE_PREV;
					this.dispatchEvent(new Event(EVENT_NEED_PREV));
				}
			}
		}

		private function checkChangePage():void {
			//trace("checkChangePage");
			for (var i:int = 0; i < pagev.length; i++) {
				var page:NewsBookPage = pagev[i];
				var cr:Rectangle = page.getRect(this);
				if ((cr.y <= 0 && cr.bottom >= bookSize.y) || (cr.y <= bookSize.y / 2 && cr.bottom > bookSize.y / 2)) {
					_currentNum = page.pageNum;
					this.dispatchEvent(new Event(EVENT_CHANGE_PAGE));
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

		public function get clickItem():NewsItemBase {
			return _clickItem;
		}

		public function get addPageCmp():Boolean {
			return _addPageCmp;
		}

	}
}
