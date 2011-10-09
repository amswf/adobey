package com.snsoft.tsp3 {
	import com.snsoft.tsp3.plugin.desktop.IDesktop;

	public class Common {

		private static var lock:Boolean = false;

		private static var common:Common = new Common();

		private var _dataBaseUrl:String = "";

		private var tsp:ITsp;

		private var deskTop:IDesktop;

		public function Common() {
			if (lock) {
				throw(new Error("Common can not new"));
			}
		}

		public function initTsp(tsp:ITsp):void {
			this.tsp = tsp;
		}

		public function initDesktop(deskTop:IDesktop):void {
			this.deskTop = deskTop;
		}

		public function pluginBarAddBtn(uuid:String):void {
			if (this.deskTop != null) {
				this.deskTop.pluginBarAddBtn(uuid);
			}
		}

		public function pluginBarRemoveBtn(uuid:String):void {
			if (this.deskTop != null) {
				this.deskTop.pluginBarRemoveBtn(uuid);
			}
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
