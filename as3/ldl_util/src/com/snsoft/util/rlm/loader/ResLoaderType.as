package com.snsoft.util.rlm.loader {

	/**
	 * 要加载的文件的类型
	 * @author Administrator
	 *
	 */
	public class ResLoaderType {

		/**
		 * SWF 文件
		 */
		public static const SWF:String = "swf";

		/**
		 * 图像（JPG、PNG 或 GIF）文件
		 */
		public static const IMAGE:String = "img";

		/**
		 * 类以文本、二进制数据或 URL 编码变量的形式从 URL 下载数据
		 */
		public static const URL:String = "url";

		/**
		 * 音频文件加载，如:mp3
		 */
		public static const SOUND:String = "sound";

		public function ResLoaderType() {

		}

		/**
		 * 判断 url 文件类型
		 * @param url
		 * @param type
		 * @return
		 *
		 */
		public static function checkType(url:String, type:String):Boolean {
			var sign:Boolean = false;
			if (url != null && type != null && getType(url) == type) {
				sign = true;
			}
			return sign;
		}

		/**
		 * 获得文件类型
		 * @param url
		 * @return
		 *
		 */
		public static function getType(url:String):String {
			var type:String = ResLoaderType.URL;
			var dotIndex:int = url.lastIndexOf(".");
			if (dotIndex > 0) {
				var eName:String = url.substring(dotIndex + 1, url.length);
				if (eName.toLocaleLowerCase() == "swf") {
					type = ResLoaderType.SWF;
				}
				else if (eName.toLocaleLowerCase() == "png" || eName.toLocaleLowerCase() == "jpg" || eName.toLocaleLowerCase() == "gif") {
					type = ResLoaderType.IMAGE;
				}
				else if (eName.toLocaleLowerCase() == "mp3") {
					type = ResLoaderType.SOUND;
				}
			}
			return type;
		}

	}
}
