package com.snsoft.util.rlm.rs {
	import com.snsoft.util.HashVector;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;

	/**
	 * 图片资源集
	 * @author Administrator
	 *
	 */
	public class RSSwf extends ResSet {

		private var swfList:HashVector = new HashVector();

		public function RSSwf() {

		}

		/**
		 * 取出图片
		 * @param url
		 * @return
		 *
		 */
		public function getImageByUrl(url:String):MovieClip {
			return this.swfList.findByName(url) as MovieClip;
		}

		override public function callBack():void {
			var list:Vector.<String> = this.urlList;
			if (list != null) {
				for (var i:int = 0; i < list.length; i++) {
					var name:String = list[i];
					if (name != null && name.length > 0) {
						var li:LoaderInfo = this.resDataList[i] as LoaderInfo;
						if (li != null) {
							var dobj:DisplayObject = li.content;
							if (dobj is MovieClip) {
								swfList.push(dobj, name);
							}
						}
					}
				}
			}
		}
	}
}
