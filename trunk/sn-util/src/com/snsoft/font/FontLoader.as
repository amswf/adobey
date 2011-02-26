package com.snsoft.font{
	import com.adobe.crypto.MD5;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	/**
	 * 字体加载类 
	 * @author Administrator
	 * 
	 */	
	public class FontLoader extends Loader{
		
		private var _fontUrlMd5:String;
		
		private var isReceiveBytesTotal:Boolean = false;
		
		public function FontLoader()
		{
			super();
			this.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,handlerProgress);
		}
		
		override public function load(request:URLRequest, context:LoaderContext=null):void{
			this._fontUrlMd5 = MD5.hash(request.url);
			super.load(request,context);
		}
		
		/**
		 * 获得文件大小后事件 
		 * @param e
		 * 
		 */		
		private function handlerProgress(e:Event):void{
			this.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,handlerProgress);
			if(!isReceiveBytesTotal && this.contentLoaderInfo.bytesTotal > 0 ){
				isReceiveBytesTotal = true;
				this.dispatchEvent(new Event(FontLoaderEvent.IS_RECEIVE_BYTES_TOTAL));
			}
		}

		public function get fontUrlMd5():String
		{
			return _fontUrlMd5;
		}

	}
}