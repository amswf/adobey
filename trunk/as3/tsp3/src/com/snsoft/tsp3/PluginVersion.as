package com.snsoft.tsp3 {

	/**
	 *
	 * @author Administrator
	 *
	 */
	public class PluginVersion {

		private var _start:String;
		private var _version:String;
		private var _url:String;
		private var _type:String;

		public function PluginVersion() {
		}

		public function get start():String {
			return _start;
		}

		public function set start(value:String):void {
			_start = value;
		}

		public function get version():String {
			return _version;
		}

		public function set version(value:String):void {
			_version = value;
		}

		public function get url():String {
			return _url;
		}

		public function set url(value:String):void {
			_url = value;
		}

		public function get type():String {
			return _type;
		}

		public function set type(value:String):void {
			_type = value;
		}

	}
}
