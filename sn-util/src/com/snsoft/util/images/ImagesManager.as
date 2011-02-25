package com.snsoft.util.images{
	import com.snsoft.util.HashVector;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * 图片加载管理器 
	 * @author Administrator
	 * 
	 */	
	public class ImagesManager extends EventDispatcher{
		
		private var type:String;
		
		/**
		 * 图片地址列表 
		 */		
		private var imgUrlList:Vector.<String> = new Vector.<String>();
		
		/**
		 * 是否在加载 
		 */		
		private var isLoading:Boolean = false;
		
		/**
		 * 加载计数器 
		 */		
		private var loadCmpCount:int = 0;
		
		/**
		 * 图片bmd列表 
		 */		
		private var imgBmdList:HashVector = new HashVector();
			
		/**
		 * 初始化
		 * @param type ImagesManagerType
		 * @param imgUrlList 
		 * 
		 */		
		public function ImagesManager(type:String = "ordered", imgUrlList:Vector.<String> = null){
			if(imgUrlList != null){
				this.imgUrlList = imgUrlList;
			}
		}
		
		/**
		 * 添加图片 
		 * @param imgUrl:String
		 * 
		 */		
		public function pushImgUrl(... imgUrl):void{
			if(!isLoading){
				this.imgUrlList.push.apply(null,imgUrl);
			}
		}
		
		/**
		 * 获得图片 BitMapData
		 * @param imgUrl
		 * 
		 */		
		public function getImgBitmapDataByUrl(imgUrl:String):BitmapData{
			return this.imgBmdList.findByName(imgUrl) as BitmapData;
		}
		
		/**
		 * 图片bmd数量 
		 * @return 
		 * 
		 */		
		public function get imgBmdSize():int{
			return this.imgBmdList.length;
		}	
		/**
		 * 获得图片 BitMapData 
		 * @param index
		 * 
		 */		
		public function getImgBitmapDataByIndex(index:int):BitmapData{
			var bmd:BitmapData = null;
			if(this.imgBmdList.length > 0 && index >= 0 && index < this.imgBmdList.length){
				bmd = this.imgBmdList.findByIndex(index) as BitmapData;
			}
			return bmd;
		}
		
		/**
		 * 加载启动 
		 * 
		 */		
		public function load():void{
			if(!isLoading){
				if(this.type == ImagesManagerType.UNORDERED){
					//非顺序加载
					for(var i:int = 0;i < this.imgUrlList.length;i ++){
						var urluno:String = this.imgUrlList[i];
						if(urluno != null && urluno.length > 0){
							var iluno:ImageLoader = new ImageLoader();
							iluno.addEventListener(Event.COMPLETE,handlerUnorderedLoaderComplete);
							iluno.addEventListener(IOErrorEvent.IO_ERROR,handlerUnorderedLoaderIoError);
							iluno.loadImage(urluno);
						}
					}
				}
				else{
					loadNextImage();
				}
			}
		}
		
		private function loadNextImage():void{
			//顺序加载
			var urlOrdered:String = this.imgUrlList[loadCmpCount];
			var ilOrdered:ImageLoader = new ImageLoader();
			ilOrdered.addEventListener(Event.COMPLETE,handlerOrderedLoaderComplete);
			ilOrdered.addEventListener(IOErrorEvent.IO_ERROR,handlerOrderedLoaderIoError);
			ilOrdered.loadImage(urlOrdered);
		}
		
		/**
		 * 事件	加载成功 
		 * @param e
		 * 
		 */		
		private function handlerUnorderedLoaderComplete(e:Event):void{
			var imageLoader:ImageLoader = e.currentTarget as ImageLoader;
			this.imgBmdList.push(imageLoader.bitmapData,imageLoader.url);
			plusUnOrderedLoadCmpCount();
		}
		
		/**
		 * 事件	加载失败 
		 * @param e
		 * 
		 */		
		private function handlerUnorderedLoaderIoError(e:Event):void{
			plusUnOrderedLoadCmpCount();
		}
		
		/**
		 * 事件	加载成功 
		 * @param e
		 * 
		 */		
		private function handlerOrderedLoaderComplete(e:Event):void{
			var imageLoader:ImageLoader = e.currentTarget as ImageLoader;
			this.imgBmdList.push(imageLoader.bitmapData,imageLoader.url);
			plusOrderedLoadCmpCount();
		}
		
		/**
		 * 事件	加载失败 
		 * @param e
		 * 
		 */		
		private function handlerOrderedLoaderIoError(e:Event):void{
			plusOrderedLoadCmpCount();
		}
		
		/**
		 * 计数器加1,判断是否完成 
		 * 
		 */		
		private function plusOrderedLoadCmpCount():void{
			loadCmpCount ++;
			if(loadCmpCount < this.imgUrlList.length){
				loadNextImage();
			}
			else{
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		/**
		 * 计数器加1,判断是否完成 
		 * 
		 */		
		private function plusUnOrderedLoadCmpCount():void{
			loadCmpCount ++;
			if(loadCmpCount == this.imgUrlList.length){
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
	}
}