package com.snsoft.tsp3.plugin.news {

	public class NewsCfg {

		private var _columnDataUrl:String;

		public function NewsCfg() {
		}

		public function get columnDataUrl():String {
			return _columnDataUrl;
		}

		public function set columnDataUrl(value:String):void {
			_columnDataUrl = value;
		}

	}
}
