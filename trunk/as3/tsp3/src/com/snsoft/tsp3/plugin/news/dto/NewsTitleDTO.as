package com.snsoft.tsp3.plugin.news.dto {
	import flash.display.BitmapData;

	public class NewsTitleDTO {

		private var _img:BitmapData;

		private var _titleImg:BitmapData;

		private var _minimizeBtnImg:BitmapData;

		private var _closeBtnimg:BitmapData;

		private var _text:String;

		public function NewsTitleDTO() {
		}

		public function get titleImg():BitmapData {
			return _titleImg;
		}

		public function set titleImg(value:BitmapData):void {
			_titleImg = value;
		}

		public function get minimizeBtnImg():BitmapData {
			return _minimizeBtnImg;
		}

		public function set minimizeBtnImg(value:BitmapData):void {
			_minimizeBtnImg = value;
		}

		public function get closeBtnimg():BitmapData {
			return _closeBtnimg;
		}

		public function set closeBtnimg(value:BitmapData):void {
			_closeBtnimg = value;
		}

		public function get text():String {
			return _text;
		}

		public function set text(value:String):void {
			_text = value;
		}

		public function get img():BitmapData {
			return _img;
		}

		public function set img(value:BitmapData):void {
			_img = value;
		}

	}
}
