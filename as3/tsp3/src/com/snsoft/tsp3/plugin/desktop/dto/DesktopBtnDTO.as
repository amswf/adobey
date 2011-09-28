package com.snsoft.tsp3.plugin.desktop.dto {
	import flash.display.BitmapData;

	public class DesktopBtnDTO {

		private var img:BitmapData;

		private var imgUrl:String;

		private var text:String;

		private var plugin:String;

		private var disobj:String;

		private var params:String;

		private var type:String;

		/**
		 * 控制显示对象的隐藏和显示
		 */
		public static const TYPE_DISOBJ = "disobj";

		/**
		 * 运行插件
		 */
		public static const TYPE_PLUGIN = "plugin";

		public function DesktopBtnDTO() {
		}
	}
}
