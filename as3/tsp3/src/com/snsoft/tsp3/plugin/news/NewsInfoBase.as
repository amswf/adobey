package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.MySprite;
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.util.SkinsUtil;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class NewsInfoBase extends MySprite {

		protected static const PARAM_TITLE:String = "title";
		protected static const PARAM_DATE:String = "date";
		protected static const PARAM_DIGEST:String = "digest";
		protected static const PARAM_CONTENT:String = "content";
		protected static const PARAM_KEYWORDS:String = "keywords";

		public static const INFO_TYPE_I:String = "1";
		public static const INFO_TYPE_II:String = "2";
		public static const INFO_TYPE_III:String = "3";

		public static const EVENT_CLOSE:String = "infoClose";

		protected var _data:DataDTO;

		protected var infoSize:Point;

		protected var boader:int = 10;

		protected var closeBtn:MovieClip;

		public function NewsInfoBase() {
			init();
			super();
		}

		private function init():void {
			var back:Sprite = SkinsUtil.createSkinByName("NewsInfo_backSkin");
			back.width = infoSize.x;
			back.height = infoSize.y;
			this.addChild(back);

			closeBtn = SkinsUtil.createSkinByName("News_closeBtnSkin");
			closeBtn.x = infoSize.x - closeBtn.width - boader;
			closeBtn.y = boader;
			this.addChild(closeBtn);
			closeBtn.addEventListener(MouseEvent.CLICK, handlerClose);
		}

		private function handlerClose(e:Event):void {
			this.dispatchEvent(new Event(EVENT_CLOSE));
		}

		public function get data():DataDTO {
			return _data;
		}

	}
}
