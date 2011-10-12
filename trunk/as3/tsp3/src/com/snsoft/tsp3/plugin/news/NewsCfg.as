package com.snsoft.tsp3.plugin.news {

	public class NewsCfg {

		private var _columnDataUrl:String;

		private var _classDataUrl:String;

		private var _filterDataUrl:String;

		public function NewsCfg() {
		}

		public function get columnDataUrl():String {
			return _columnDataUrl;
		}

		public function set columnDataUrl(value:String):void {
			_columnDataUrl = value;
		}

		public function get classDataUrl():String
		{
			return _classDataUrl;
		}

		public function set classDataUrl(value:String):void
		{
			_classDataUrl = value;
		}

		public function get filterDataUrl():String
		{
			return _filterDataUrl;
		}

		public function set filterDataUrl(value:String):void
		{
			_filterDataUrl = value;
		}


	}
}
