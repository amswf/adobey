package com.snsoft.tsp3.plugin.desktop {

	public class DesktopCfg {

		private var _toolBarDataUrl:String;

		private var _boardDataUrl:String;

		private var _backImgUrl:String;

		private var _toolBarBackImgUrl:String;

		public function DesktopCfg() {
		}

		public function get toolBarDataUrl():String {
			return _toolBarDataUrl;
		}

		public function set toolBarDataUrl(value:String):void {
			_toolBarDataUrl = value;
		}

		public function get boardDataUrl():String {
			return _boardDataUrl;
		}

		public function set boardDataUrl(value:String):void {
			_boardDataUrl = value;
		}

		public function get backImgUrl():String {
			return _backImgUrl;
		}

		public function set backImgUrl(value:String):void {
			_backImgUrl = value;
		}

		public function get toolBarBackImgUrl():String {
			return _toolBarBackImgUrl;
		}

		public function set toolBarBackImgUrl(value:String):void {
			_toolBarBackImgUrl = value;
		}

	}
}
