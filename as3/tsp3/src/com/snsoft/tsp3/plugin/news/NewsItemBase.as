package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.Common;
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.util.rlm.rs.RSEmbedFonts;

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

		//标题
		protected var titletft:TextFormat = new TextFormat(RSEmbedFonts.findFontByName(Common.FONT_YH), 15, 0x0657b7);
		//副标题及日期等的标签文字
		protected var texttft:TextFormat = new TextFormat(RSEmbedFonts.findFontByName(Common.FONT_YH), 13, 0x9f9f9f);

		//副标题及日期等的信息文字
		protected var ctnttft:TextFormat = new TextFormat(RSEmbedFonts.findFontByName(Common.FONT_YH), 13, 0x9f9f9f);

		//简介摘要信息
		protected var digesttft:TextFormat = new TextFormat(RSEmbedFonts.findFontByName(Common.FONT_YH), 14, 0x575757);

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
