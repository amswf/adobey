package com.snsoft.util.rlm.loader {
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	/**
	 * 加载 SWF 文件或图像（JPG、PNG 或 GIF）文件
	 * @author Administrator
	 *
	 */
	public class LdSoundLoader extends Sound {

		private var _url:String;

		private var isReceiveBytesTotal:Boolean = false;

		public function LdSoundLoader() {
			super();
			this.addEventListener(ProgressEvent.PROGRESS, handlerProgress);
		}

		override public function load(request:URLRequest, context:SoundLoaderContext = null):void {
			if (request != null) {
				this._url = request.url;
				super.load(request, context);
			}
		}

		private function handlerIOError(e:Event):void {
			trace("加载mp3 出错!" + url);
		}

		/**
		 * 获得文件大小后事件
		 * @param e
		 *
		 */
		private function handlerProgress(e:ProgressEvent):void {
			if (!isReceiveBytesTotal && this.bytesTotal > 0) {
				isReceiveBytesTotal = true;
				this.removeEventListener(ProgressEvent.PROGRESS, handlerProgress);
				this.dispatchEvent(new Event(LdLoaderEvent.IS_RECEIVE_BYTES_TOTAL));
			}
		}

		override public function get url():String {
			return _url;
		}
	}
}
