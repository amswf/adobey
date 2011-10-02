package com.snsoft.tsp3.plugin.news {
	import flash.display.BitmapData;

	public class NewsBtnDTO {

		private var _img:BitmapData;

		private var _imgUrl:String;

		private var _text:String;

		private var _code:String;

		public function NewsBtnDTO() {
		}

		public function get img():BitmapData
		{
			return _img;
		}

		public function set img(value:BitmapData):void
		{
			_img = value;
		}

		public function get imgUrl():String
		{
			return _imgUrl;
		}

		public function set imgUrl(value:String):void
		{
			_imgUrl = value;
		}

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text = value;
		}

		public function get code():String
		{
			return _code;
		}

		public function set code(value:String):void
		{
			_code = value;
		}


	}
}
