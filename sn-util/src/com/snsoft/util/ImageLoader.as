package com.snsoft.util
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	public class ImageLoader extends EventDispatcher
	{
		private var _bitmapData:BitmapData = null;
		
		private var _url:String;
		
		public function ImageLoader(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**
		 * 加载图片 
		 * @param url
		 * 
		 */		
		public function loadImage(url:String):void {
			if (url != null) {
				this.url = url;
				var req:URLRequest = new URLRequest(url);
				var loader:Loader = new Loader();
				loader.load(req);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,handlerLoaderComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,handlerLoaderIoError);
			}
		}
		
		
		/**
		 * 转换成BitMap
		 * @param e
		 * 
		 */		
		private function handlerLoaderComplete(e:Event):void {
			
			//创建并图片
			var info:LoaderInfo = LoaderInfo(e.currentTarget);
			if (info != null) {
				var bm:Bitmap = Bitmap(info.content);
				var data:BitmapData = bm.bitmapData;
				this._bitmapData = data;
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function handlerLoaderIoError(e:Event):void{
			trace("图片地址错误！");
			this.dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
		}

		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}

		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
		}


	}
}