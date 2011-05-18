package com.snsoft.util.rlm.rs {
	import com.snsoft.util.HashVector;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.media.SoundMixer;

	/**
	 * 图片资源集
	 * @author Administrator
	 *
	 */
	public class RSSwf extends ResSet {

		private var swfHV:HashVector = new HashVector();
		
		private var _swfList:Vector.<MovieClip> = new Vector.<MovieClip>();

		public function RSSwf() {

		}

		/**
		 * 取出图片
		 * @param url
		 * @return
		 *
		 */
		public function getImageByUrl(url:String):MovieClip {
			return this.swfHV.findByName(url) as MovieClip;
		}

		override protected function callBack():void {
			var list:Vector.<String> = this.urlList;
			if (list != null) {
				for (var i:int = 0; i < list.length; i++) {
					var name:String = list[i];
					if (name != null && name.length > 0) {
						var li:LoaderInfo = this.resDataList[i] as LoaderInfo;
						if (li != null) {
							var mc:MovieClip = li.content as MovieClip;
							if (mc != null ) {
								mc.gotoAndStop(1);
								swfHV.push(mc, name);
								swfList.push(mc);
							}
						}
					}
				}
			}
		}

		public function get swfList():Vector.<MovieClip>
		{
			return _swfList;
		}
	}
}
