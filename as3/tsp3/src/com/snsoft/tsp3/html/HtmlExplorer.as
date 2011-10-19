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

	public class HtmlExplorer extends Sprite {

		public static const EVENT_LOAD_CMP:String = "eventLoadCmp";

		private var htmlWidth:int;

		private var htmlView:Sprite;

		private var htmlCtn:Sprite;

		private var htmlMask:Sprite;

		private var htmldragBounds:Rectangle;

		private var html:HTMLLoader;

		private var isHtmlMouseDown:Boolean = false;

		public function HtmlExplorer(htmlWidth:int) {
			this.htmlWidth = htmlWidth;
			super();
			init();
		}

		private function init():void {
			htmlMask = ViewUtil.creatRect(100, 100);
			htmlMask.width = htmlWidth;
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

		private function handlerHtmlLoadCmp(e:Event):void {
			html.height = html.contentHeight;
			htmlView.height = html.contentHeight;
			this.dispatchEvent(new Event(EVENT_LOAD_CMP));
		}

	}
}
