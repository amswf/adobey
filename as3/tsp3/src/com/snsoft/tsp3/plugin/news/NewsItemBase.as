package com.snsoft.tsp3.plugin.news {
	import flash.display.Sprite;

	public class NewsItemBase extends Sprite {

		protected static const PARAM_TITLE:String = "title";
		protected static const PARAM_DATE:String = "date";
		protected static const PARAM_DIGEST:String = "digest";
		protected static const PARAM_KEYWORDS:String = "keywords";

		public static const ITEM_TYPE_I:String = "1";
		public static const ITEM_TYPE_II:String = "2";
		public static const ITEM_TYPE_III:String = "3";

		private var _itemWidth:int;

		private var _itemHeight:int

		public function NewsItemBase() {
			super();
		}

		public function draw():void {
			throw(new Error("子类需要重写draw方法!"));
		}

		public function get itemWidth():int {
			return _itemWidth;
		}

		public function set itemWidth(value:int):void {
			_itemWidth = value;
		}

		public function get itemHeight():int {
			return _itemHeight;
		}

		public function set itemHeight(value:int):void {
			_itemHeight = value;
		}

	}
}
