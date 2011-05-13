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
	}
}
