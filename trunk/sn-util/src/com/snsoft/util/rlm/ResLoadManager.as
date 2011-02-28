package com.snsoft.util.rlm{
	import com.adobe.crypto.MD5;
	import com.snsoft.util.HashVector;
	
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	/**
	 * resources load manager 
	 * @author Administrator
	 * 
	 */	
	public class ResLoadManager extends EventDispatcher{
		
		private var type:String;
		
		private var urlList:Vector.<String> = new Vector.<String>();
		
		private var loadTypeList:Vector.<String> = new Vector.<String>();
		
		private var resList:HashVector = new HashVector();
		
		/**
		 * 是否在加载 
		 */		
		private var isLoading:Boolean = false;
		
		/**
		 * 加载计数器 
		 */		
		private var loadCmpCount:int = 0;
		
		private var errorCount:int = 0;
		
		private var bytesLoaded:int = 0;
		
		private var bytesTotal:int = 0;
		
		private var bytesLoadedList:HashVector = new HashVector();
		
		/**
		 * 
		 * @param type ResLoadManagerType.ORDERED / UNORDERED
		 * 
		 */		
		public function ResLoadManager(type:String = "ordered"){
			this.type = type;
		}
		
		/**
		 * 返回url 对应资源的标识ID用于取出资源
		 * @param url 资源地址
		 * @param type ResType.MEDIA 或  URL
		 * 
		 */		
		public function add(url:String,loadType:String):String{
			var urlMd5:String = null;
			if(!isLoading){
				this.urlList.push(url);
				this.loadTypeList.push(loadType);
				urlMd5 = MD5.hash(url);
			}
			return urlMd5;
		}
		
		public function getProgressValue():Number{
			if(this.type == ResLoadManagerType.UNORDERED){
				var bld:int = 0;
				for(var i:int = 0;i < this.bytesLoadedList.length;i ++){
					var bl:int = bytesLoadedList.findByIndex(i) as int;
					bld += bl;
				}
				return bld / this.bytesTotal;
			}
			else {
				return (this.loadCmpCount / this.urlList.length) + (this.bytesLoaded ) / ( this.bytesTotal * this.urlList.length );
			}
		}
		
		/**
		 * 加载启动 
		 * 
		 */		
		public function load():void{
			if(!isLoading){
				if(this.type == ResLoadManagerType.UNORDERED){
					//非顺序加载
					for(var i:int = 0;i < this.urlList.length;i ++){
						loadNext(i);
					}
				}
				else{
					loadNext(this.loadCmpCount);
				}
			}
		}
		
		private function loadNext(i:int):void{
			var url:String = this.urlList[i];
			var loadType:String = this.loadTypeList[i];
			if(url != null && url.length > 0){
				if(loadType == LoadType.MEDIA){
					var rl:ResLoader = new ResLoader();
					rl.addEventListener(ResLoaderEvent.IS_RECEIVE_BYTES_TOTAL,handlerIsReceiveBytes);
					var rlinfo:LoaderInfo = rl.contentLoaderInfo;
					rlinfo.addEventListener(Event.COMPLETE,handlerLoadComplete);
					rlinfo.addEventListener(IOErrorEvent.IO_ERROR,handlerLoadIoError);
					rlinfo.addEventListener(ProgressEvent.PROGRESS,handlerProgress);
					rl.load(new URLRequest(url));
				}
				else if(loadType == LoadType.URL){
					var rul:ResURLLoader = new ResURLLoader();
					rul.addEventListener(ResLoaderEvent.IS_RECEIVE_BYTES_TOTAL,handlerIsReceiveBytes);
					rul.addEventListener(Event.COMPLETE,handlerLoadComplete);
					rul.addEventListener(IOErrorEvent.IO_ERROR,handlerLoadIoError);
					rul.addEventListener(ProgressEvent.PROGRESS,handlerProgress);
					rul.load(new URLRequest(url));
				}
			}
		}
		
		private function handlerIsReceiveBytes(e:Event):void{
			if(this.type == ResLoadManagerType.UNORDERED){
				this.bytesTotal += this.getLoaderBytesTotal(e);
			}
			else {
				this.bytesTotal = this.getLoaderBytesTotal(e);
			}
		}
		
		private function handlerLoadComplete(e:Event):void{
			this.loadCmpCount ++;
			checkLoadsCmp();
		}
		
		private function handlerLoadIoError(e:Event):void{
			this.loadCmpCount ++;
			this.errorCount ++;
			checkLoadsCmp();
		}
		private function handlerProgress(e:Event):void{
			if(this.type == ResLoadManagerType.UNORDERED){
				var value:int = this.getLoaderBytesLoaded(e);
				var name:String = this.getLoaderUrlMd5(e);
				this.bytesLoadedList.push(value,name);
			}
			else {
				this.bytesLoaded = this.getLoaderBytesLoaded(e);
			}
			this.dispatchEvent(new Event(ProgressEvent.PROGRESS));
		}
		
		private function checkLoadsCmp():void{
			if(this.loadCmpCount == this.urlList.length){
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
			else {
				if(this.type == ResLoadManagerType.UNORDERED){
					
				}
				else {
					loadNext(this.loadCmpCount);
				}
			}
		}
		
		/**
		 * 
		 * @param e
		 * @return 
		 * 
		 */		
		private function getLoaderBytesTotal(e:Event):uint{
			var bytesTotal:uint = 0;
			if(e.currentTarget is ResLoader){
				var rl:ResLoader = e.currentTarget as ResLoader;
				bytesTotal = rl.contentLoaderInfo.bytesTotal;
			}
			else if(e.currentTarget is ResURLLoader){
				var rul:ResURLLoader = e.currentTarget as ResURLLoader;
				bytesTotal = rul.bytesTotal;
			}
			return bytesTotal;
		}
		
		/**
		 * 
		 * @param e
		 * @return 
		 * 
		 */		
		private function getLoaderBytesLoaded(e:Event):int{
			var bytesLoaded:int = 0;
			if(e.currentTarget is LoaderInfo){
				var li:LoaderInfo = e.currentTarget as LoaderInfo;
				bytesLoaded = li.bytesLoaded;
			}
			else if(e.currentTarget is ResURLLoader){
				var rul:ResURLLoader = e.currentTarget as ResURLLoader;
				bytesLoaded = rul.bytesLoaded;
			}
			return bytesLoaded;
		}
		
		private function getLoaderUrlMd5(e:Event):String{
			var urlMd5:String = null;
			if(e.currentTarget is LoaderInfo){
				var li:LoaderInfo = e.currentTarget as LoaderInfo;
				var rl:ResLoader = li.loader as ResLoader;
				urlMd5 = rl.urlMd5;
			}
			else if(e.currentTarget is ResURLLoader){
				var rul:ResURLLoader = e.currentTarget as ResURLLoader;
				urlMd5 = rul.urlMd5;
			}
			return urlMd5;
		}
	}
}