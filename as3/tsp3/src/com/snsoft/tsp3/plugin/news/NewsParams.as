package com.snsoft.tsp3.plugin.news {
	import flash.display.BitmapData;

	public class NewsParams {

		private var _id:String;

		private var _img:BitmapData;

		private var _titleImg:BitmapData;

		private var _text:String;

		private var _columnId:String;

		public function NewsParams() {
		}

		public function get columnId():String {
			return _columnId;
		}

		public function set columnId(value:String):void {
			_columnId = value;
		}

		public function get id():String {
			return _id;
		}

		public function set id(value:String):void {
			_id = value;
		}

		public function get img():BitmapData {
			return _img;
		}

		public function set img(value:BitmapData):void {
			_img = value;
		}

		public function get text():String {
			return _text;
		}

		public function set text(value:String):void {
			_text = value;
		}

		public function get titleImg():BitmapData {
			return _titleImg;
		}

		public function set titleImg(value:BitmapData):void {
			_titleImg = value;
		}

	}
}
