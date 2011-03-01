package com.snsoft.util.rlm.loader{
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * 加载文本、二进制数据或 URL 编码变量的形式从 URL 下载数据  
	 * @author Administrator
	 * 
	 */	
	public class ResURLLoader extends URLLoader{
		
		private var _url:String;
		
		private var isReceiveBytesTotal:Boolean = false;
		
		public function ResURLLoader(request:URLRequest = null){
			super(request);
			this.addEventListener(ProgressEvent.PROGRESS,handlerProgress);
		}
		
		override public function load(request:URLRequest):void{
			this._url = request.url;
			super.load(request);
		}
		
		private function handlerProgress(e:Event):void{
			if(!isReceiveBytesTotal && this.bytesTotal > 0 ){
				isReceiveBytesTotal = true;
				this.removeEventListener(ProgressEvent.PROGRESS,handlerProgress);
				this.dispatchEvent(new Event(ResLoaderEvent.IS_RECEIVE_BYTES_TOTAL));
			}
		}

		public function get url():String
		{
			return _url;
		}

	}
}