package com.snsoft.tsp3.plugin.news {

	public class NewsCfg {

		private var _columnDataUrl:String;

		private var _classDataUrl:String;

		private var _filterDataUrl:String;

		private var _searchDataUrl:String;

		private var _infoDataUrl:String;

		private var _digestLength:String;

		private var _pageSize:String;

		public function NewsCfg() {
		}

		public function get columnDataUrl():String {
			return _columnDataUrl;
		}

		public function set columnDataUrl(value:String):void {
			_columnDataUrl = value;
		}

		public function get classDataUrl():String {
			return _classDataUrl;
		}

		public function set classDataUrl(value:String):void {
			_classDataUrl = value;
		}

		public function get filterDataUrl():String {
			return _filterDataUrl;
		}

		public function set filterDataUrl(value:String):void {
			_filterDataUrl = value;
		}

		public function get searchDataUrl():String {
			return _searchDataUrl;
		}

		public function set searchDataUrl(value:String):void {
			_searchDataUrl = value;
		}

		public function get digestLength():String {
			return _digestLength;
		}

		public function set digestLength(value:String):void {
			_digestLength = value;
		}

		public function get infoDataUrl():String {
			return _infoDataUrl;
		}

		public function set infoDataUrl(value:String):void {
			_infoDataUrl = value;
		}

		public function get pageSize():String {
			return _pageSize;
		}

		public function set pageSize(value:String):void {
			_pageSize = value;
		}

	}
}
