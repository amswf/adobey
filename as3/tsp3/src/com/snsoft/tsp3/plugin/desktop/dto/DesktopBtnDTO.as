package com.snsoft.tsp3.plugin.desktop.dto {
	import flash.display.BitmapData;

	public class DesktopBtnDTO {

		private var _img:BitmapData;

		private var _imgUrl:String;

		private var _text:String;

		private var _plugin:String;

		private var _disobj:String;

		private var _params:Object;

		private var _type:String;

		/**
		 * 控制显示对象的隐藏和显示
		 */
		public static const TYPE_DISOBJ:String = "disobj";

		/**
		 * 运行插件
		 */
		public static const TYPE_PLUGIN:String = "plugin";

		public function DesktopBtnDTO() {
		}

		public function get img():BitmapData {
			return _img;
		}

		public function set img(value:BitmapData):void {
			_img = value;
		}

		public function get imgUrl():String {
			return _imgUrl;
		}

		public function set imgUrl(value:String):void {
			_imgUrl = value;
		}

		public function get text():String {
			return _text;
		}

		public function set text(value:String):void {
			_text = value;
		}

		public function get plugin():String {
			return _plugin;
		}

		public function set plugin(value:String):void {
			_plugin = value;
		}

		public function get disobj():String {
			return _disobj;
		}

		public function set disobj(value:String):void {
			_disobj = value;
		}

		public function get params():Object {
			return _params;
		}

		public function set params(value:Object):void {
			_params = value;
		}

		public function get type():String {
			return _type;
		}

		public function set type(value:String):void {
			_type = value;
		}

	}
}
