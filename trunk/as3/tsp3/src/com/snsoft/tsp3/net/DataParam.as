package com.snsoft.tsp3.net {

	public class DataParam {
		private var _name:String;

		private var _type:String;

		private var _text:String;

		private var _url:String;

		private var _content:String;

		public function DataParam() {

		}

		public function get name():String {
			return _name;
		}

		public function set name(value:String):void {
			_name = value;
		}

		public function get type():String {
			return _type;
		}

		public function set type(value:String):void {
			_type = value;
		}

		public function get text():String {
			return _text;
		}

		public function set text(value:String):void {
			_text = value;
		}

		public function get content():String {
			return _content;
		}

		public function set content(value:String):void {
			_content = value;
		}

		public function get url():String {
			return _url;
		}

		public function set url(value:String):void {
			_url = value;
		}

	}
}
