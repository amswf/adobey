package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.MySprite;
	import com.snsoft.tsp3.ViewUtil;
	import com.snsoft.tsp3.touch.TouchDrag;
	import com.snsoft.tsp3.touch.TouchDragEvent;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class NewsBook extends MySprite {

		public static const NEED_NEXT:String = "needNext";

		public static const NEED_PREV:String = "needPrev";

		private var _bookSize:Point;

		private var pageLayer:Sprite = new Sprite();

		private var maskLayer:Sprite = new Sprite();

		private var pagev:Vector.<NewsBookPage> = new Vector.<NewsBookPage>();

		private var td:TouchDrag;

		private var catchMax:int = 0;

		private var _pageNum:int = 1;

		public function NewsBook(bookSize:Point, catchMax:int = 0) {
			super();
			this._bookSize = bookSize;
			this.catchMax = catchMax;

			this.addChild(pageLayer);
			this.addChild(maskLayer);
		}

		override protected function init():void {
			maskLayer.addChild(ViewUtil.creatRect(bookSize.x, bookSize.y, 0xffffff, 1));
			pageLayer.mask = maskLayer;

			var dragBounds:Rectangle = new Rectangle(0, 0, 0, 0);
			td = new TouchDrag(pageLayer, stage, dragBounds);
			td.addEventListener(TouchDragEvent.TOUCH_DRAG_MOUSE_UP, handlerTouchUp);
			dispatchEventNeedNext();
		}

		private function handlerTouchUp(e:Event):void {
			var rect:Rectangle = pageLayer.getRect(this);
			if (rect.bottom - 5 <= bookSize.y) {
				if (pagev.length > 0) {
					var ep:NewsBookPage = pagev[pagev.length - 1];
					_pageNum = ep.pageNum + 1;
				}
				dispatchEventNeedNext();
			}
			else if (rect.top + 5 >= 0) {
				if (pagev.length > 0) {
					var fp:NewsBookPage = pagev[0];
					var n:int = fp.pageNum - 1;
					if (n >= 1) {
						_pageNum = n;
						dispatchEventNeedPrev();
					}
				}
			}
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
			td.dragBounds.y = -dy;
			td.dragBounds.height = dy;

			for (var i:int = 0; i < pagev.length; i++) {
				var p:NewsBookPage = pagev[i];
				p.y -= dh;
			}
			pageLayer.y += dh;

			trace(td.dragBounds.y, td.dragBounds.height);
			trace(pageLayer.y, npage.y, npage.height, bookSize.y);
			if (pageLayer.y + npage.y + npage.height < bookSize.y) {
				dispatchEventNeedNext();
			}
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
			td.dragBounds.y = -dy;
			td.dragBounds.height = dy;

			for (var i:int = 0; i < pagev.length; i++) {
				var p:NewsBookPage = pagev[i];
				p.y += ppage.height;
			}
			pageLayer.y -= ppage.height;

			trace(td.dragBounds.y, td.dragBounds.height);
			trace(pageLayer.y, ppage.y, ppage.height, bookSize.y);
			if (pageLayer.y + ppage.y > 0) {
				dispatchEventNeedPrev();
			}
		}

		private function dispatchEventNeedNext():void {
			this.dispatchEvent(new Event(NEED_NEXT));
		}

		private function dispatchEventNeedPrev():void {
			this.dispatchEvent(new Event(NEED_PREV));
		}

		public function get bookSize():Point {
			return _bookSize;
		}

		public function get pageNum():int {
			return _pageNum;
		}

	}
}
