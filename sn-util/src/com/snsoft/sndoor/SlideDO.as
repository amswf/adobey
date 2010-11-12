package com.snsoft.sndoor{
	public class SlideDO{
		
		private var _name:String;
		
		private var _text:String;
		
		private var _media:String;
		
		private var _image:String;
		
		private var _url:String;
		
		private var _window:String;
		
		
		public function SlideDO(){
			
		}

		/**
		 * 名称 
		 */
		public function get name():String
		{
			return _name;
		}

		/**
		 * @private
		 */
		public function set name(value:String):void
		{
			_name = value;
		}

		/**
		 * 中文标题 
		 */
		public function get text():String
		{
			return _text;
		}

		/**
		 * @private
		 */
		public function set text(value:String):void
		{
			_text = value;
		}

		public function get media():String
		{
			return _media;
		}

		public function set media(value:String):void
		{
			_media = value;
		}

		/**
		 * 链接地址 
		 */
		public function get url():String
		{
			return _url;
		}

		/**
		 * @private
		 */
		public function set url(value:String):void
		{
			_url = value;
		}

		/**
		 * 链接地址打开方式 
		 */
		public function get window():String
		{
			return _window;
		}

		/**
		 * @private
		 */
		public function set window(value:String):void
		{
			_window = value;
		}

		public function get image():String
		{
			return _image;
		}

		public function set image(value:String):void
		{
			_image = value;
		}


	}
}