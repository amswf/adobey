package com.snsoft.tsp3 {

	public class Common {

		private static var lock:Boolean = false;

		private static var common:Common = new Common();

		private var _dataBaseUrl:String = "";

		private var tsp:ITsp;

		public function Common() {
			if (lock) {
				throw(new Error("Common can not new"));
			}
		}

		public function initTsp(tsp:ITsp):void {
			this.tsp = tsp;
		}

		public function loadPlugin(pluginName:String, params:Object = null, uuid:String = null):void {
			if (tsp != null) {
				tsp.loadPlugin(pluginName, params, uuid);
			}
		}

		public static function instance():Common {
			return common;
		}

		public function get dataBaseUrl():String {
			return _dataBaseUrl;
		}

		public function set dataBaseUrl(value:String):void {
			_dataBaseUrl = value;
		}

	}
}
