package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.net.DataDTO;
	
	import flash.display.Sprite;
	import flash.text.TextFormat;

	public class NewsItemBase extends Sprite {

		public static const ITEM_TYPE_I:String = "I";
		public static const ITEM_TYPE_II:String = "II";
		public static const ITEM_TYPE_III:String = "III";

		public static const CLICK_TYPE_PLAY:String = "play";

		public static const CLICK_TYPE_INFO:String = "info";

		private var _itemWidth:int;

		private var _itemHeight:int

		protected var _data:DataDTO;

		protected var _autoRow:Boolean = false;

		protected var _clickType:String = CLICK_TYPE_INFO;

		protected var texttft:TextFormat = new TextFormat(null, 14, 0xffffff);

		protected var ctnttft:TextFormat = new TextFormat(null, 12, 0xffffff);

		protected var boader:int = 10;

		public function NewsItemBase() {
			super();
		}

		protected function creatTitleLine(data:DataDTO):Sprite {
			var sprite:Sprite = new Sprite();
			return sprite;
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

		public function get data():DataDTO {
			return _data;
		}

		public function get autoRow():Boolean {
			return _autoRow;
		}

		public function get clickType():String {
			return _clickType;
		}

	}
}
