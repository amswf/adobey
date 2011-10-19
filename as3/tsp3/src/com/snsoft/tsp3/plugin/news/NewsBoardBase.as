package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.MySprite;
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.util.SkinsUtil;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class NewsBoardBase extends MySprite {

		protected static const PARAM_TITLE:String = "title";
		protected static const PARAM_DATE:String = "date";
		protected static const PARAM_DIGEST:String = "digest";
		protected static const PARAM_CONTENT:String = "content";
		protected static const PARAM_KEYWORDS:String = "keywords";

		protected const SRC_PARAMS:String = "params";
		protected const SRC_IMAGES:String = "images";
		protected const SRC_FILES:String = "files";
		protected const SRC_AUDIOS:String = "audios";
		protected const SRC_VIDEOS:String = "videos";

		public static const INFO_TYPE_I:String = "I";
		public static const INFO_TYPE_II:String = "II";
		public static const INFO_TYPE_III:String = "III";

		protected var _data:DataDTO;

		protected var infoSize:Point;

		protected var boader:int = 10;

		public function NewsBoardBase() {
			super();
		}

		public function get data():DataDTO {
			return _data;
		}

		public function set data(value:DataDTO):void {
			_data = value;
		}

	}
}
