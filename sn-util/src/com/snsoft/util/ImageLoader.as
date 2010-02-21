package com.snsoft.util
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;
	
	public class ImageLoader extends EventDispatcher
	{
		private var _bitmapData:BitmapData = null;
		
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
				var req:URLRequest = new URLRequest(url);
				var loader:Loader = new Loader();
				loader.load(req);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,handlerLoaderComplete);
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

		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}

	}
}