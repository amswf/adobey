package com.snsoft.tsp3.net {

	public class DataSetAttr {

		private var _id:String;

		private var _name:String;

		private var _type:String;

		private var _pageNum:String;

		private var _pageCount:String;

		public function DataSetAttr() {
		}

		public function get id():String {
			return _id;
		}

		public function set id(value:String):void {
			_id = value;
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

		public function get pageNum():String {
			return _pageNum;
		}

		public function set pageNum(value:String):void {
			_pageNum = value;
		}

		public function get pageCount():String {
			return _pageCount;
		}

		public function set pageCount(value:String):void {
			_pageCount = value;
		}
	}
}
