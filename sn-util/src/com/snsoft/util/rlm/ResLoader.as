package com.snsoft.util.rlm{
	import com.adobe.crypto.MD5;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	public class ResLoader extends Loader{
		 
		private var _urlMd5:String;
		
		private var isReceiveBytesTotal:Boolean = false;
		
		public function ResLoader()
		{
			super();
			this.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,handlerProgress);
		}
		
		override public function load(request:URLRequest, context:LoaderContext=null):void{
			this._urlMd5 = MD5.hash(request.url);
			super.load(request,context);
		}
		
		/**
		 * 获得文件大小后事件 
		 * @param e
		 * 
		 */		
		private function handlerProgress(e:Event):void{
			if(!isReceiveBytesTotal && this.contentLoaderInfo.bytesTotal > 0 ){
				isReceiveBytesTotal = true;
				this.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,handlerProgress);
				this.dispatchEvent(new Event(ResLoaderEvent.IS_RECEIVE_BYTES_TOTAL));
			}
		}

		public function get urlMd5():String
		{
			return _urlMd5;
		}

	}
}