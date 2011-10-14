package com.snsoft.tsp3.html {
	import com.snsoft.tsp3.MySprite;
	import com.snsoft.tsp3.ViewUtil;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.html.HTMLLoader;
	import flash.net.URLRequest;

	public class HtmlExplorer extends MySprite {

		private var heSize:Point;

		private var htmlView:Sprite;

		private var htmlCtn:Sprite;

		private var htmlMask:Sprite;

		private var htmldragBounds:Rectangle;

		private var html:HTMLLoader;

		private var isHtmlMouseDown:Boolean = false;

		public function HtmlExplorer(heSize:Point) {
			this.heSize = heSize;
			super();

		}

		override protected function configMS():void {
			htmlMask = ViewUtil.creatRect(100, 100);
			htmlMask.width = heSize.x;
			htmlMask.height = heSize.y;
			this.addChild(htmlMask);

			htmlCtn = new Sprite();
			this.addChild(htmlCtn);
			htmlCtn.mask = htmlMask;

			html = new HTMLLoader();
			html.addEventListener(Event.COMPLETE, handlerHtmlLoadCmp);
			htmlCtn.addChild(html);
			html.width = htmlMask.width;

			htmlView = ViewUtil.creatRect(100, 100);
			htmlView.width = htmlMask.width;
			htmlCtn.addChild(htmlView);
		}

		public function load(url:String):void {
			html.load(new URLRequest(url));
		}

		public function loadString(htmlContent:String):void {
			html.loadString(htmlContent);
		}

		override protected function draw():void {
			stage.addEventListener(MouseEvent.MOUSE_UP, handlerMouseUp);
		}

		private function handlerHtmlLoadCmp(e:Event):void {
			var html:HTMLLoader = e.currentTarget as HTMLLoader;
			html.height = html.contentHeight;
			htmlView.height = html.contentHeight;

			var y:int = Math.max(htmlCtn.height - htmlMask.height, 0);

			htmldragBounds = new Rectangle(0, -y, 0, y);
			htmlCtn.addEventListener(MouseEvent.MOUSE_DOWN, handlerHtmlMouseDown);
		}

		private function handlerHtmlMouseDown(e:Event):void {
			isHtmlMouseDown = true;
			htmlCtn.startDrag(false, htmldragBounds);
		}

		private function handlerMouseUp(e:Event):void {
			if (isHtmlMouseDown) {
				isHtmlMouseDown = false;
				htmlCtn.stopDrag();
			}
		}
	}
}
