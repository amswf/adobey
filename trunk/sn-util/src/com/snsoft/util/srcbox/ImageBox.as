package com.snsoft.util.srcbox{
	import com.snsoft.util.HashVector;
	import com.snsoft.util.ImageLoader;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	
	/**
	 * 图片箱子缓存需要的图片 
	 * @author Administrator
	 * 
	 */	
	public class ImageBox extends EventDispatcher{
		
		private var imageUrlV:Vector.<String> = new Vector.<String>();
		
		private var imageBitMapDataHv:HashVector = new HashVector();
		
		private var _loadingCount:int = 0;
		
		private var _allCount:int = 0;
		
		private var isLoadingCmp:Boolean = false;
		
		private var isLoading:Boolean = false;
		
		public static const EVENT_LOADING:String = "EVENT_LOADING";

		
		public function ImageBox(imageUrlV:Vector.<String> = null){
			if(imageUrlV != null){
				this.imageUrlV = imageUrlV;
			}
		}
		
		public function addImageUrl(url:String):void{
			imageUrlV.push(url);
			_allCount = imageUrlV.length;
		}
		
		public function getImageByUrl(url:String):BitmapData{
			return imageBitMapDataHv.findByName(url) as BitmapData;
		}
		
		/**
		 * 加载图片 
		 * 
		 */		
		public function loadImage():void{
			if(!isLoading){
				isLoading = true;
				loadingImage();
			}
		}
		
		/**
		 * 
		 * 
		 */		
		private function loadingImage():void{
			if(loadingCount < imageUrlV.length){
				var imgl:ImageLoader = new ImageLoader();
				var url:String = imageUrlV[loadingCount];
				imgl.loadImage(url);
				imgl.addEventListener(Event.COMPLETE,handlerCmp);
				imgl.addEventListener(IOErrorEvent.IO_ERROR,handlerError);
			}
			else {
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerCmp(e:Event):void{
			var imgl:ImageLoader = e.currentTarget as ImageLoader;
			imgl.removeEventListener(Event.COMPLETE,handlerCmp);
			imageBitMapDataHv.push(imgl.bitmapData,imgl.url);
			_loadingCount ++;
			this.dispatchEvent(new Event(EVENT_LOADING));
			loadingImage();
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerError(e:Event):void{
			_loadingCount ++;
			this.dispatchEvent(new Event(EVENT_LOADING));
			loadingImage();
		}

		public function get loadingCount():int
		{
			return _loadingCount;
		}

		public function get allCount():int
		{
			return _allCount;
		}


	}
}