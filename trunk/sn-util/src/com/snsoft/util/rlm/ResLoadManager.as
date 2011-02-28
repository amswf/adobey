package com.snsoft.util.rlm{
	import com.adobe.crypto.MD5;
	import com.snsoft.util.HashVector;
	import com.snsoft.util.rlm.res.ResBase;
	
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	/**
	 * 资源加载管理器
	 * resources load manager 
	 * @author Administrator
	 * 
	 */	
	public class ResLoadManager extends EventDispatcher{
		
		/**
		 * 加载类型  顺序/非顺序 ResLoadManagerType 
		 */		
		private var type:String;
		
		/**
		 * 地址列表 
		 */		
		private var urlList:Vector.<String> = new Vector.<String>();
		
		/**
		 * 加载文件类 
		 */		
		private var loadTypeList:Vector.<String> = new Vector.<String>();
		
		/**
		 * 加载到的资源列表 
		 */		
		private var resDataList:HashVector = new HashVector();
		
		/**
		 * 是否在加载 
		 */		
		private var isLoading:Boolean = false;
		
		/**
		 * 加载计数器 
		 */		
		private var loadCmpCount:int = 0;
		
		/**
		 * 加载失败计数 
		 */		
		private var errorCount:int = 0;
		
		/**
		 * 已加载的字节数 
		 */		
		private var bytesLoaded:int = 0;
		
		/**
		 * 总字节数 
		 */		
		private var bytesTotal:int = 0;
		
		private var resList:Vector.<ResBase> = new Vector.<ResBase>();
		
		/**
		 * 非顺序加载时，已加载字节数的列表 
		 */		
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
		 * 添加资源 
		 * @param res
		 * 
		 */		
		public function addRes(res:ResBase):void{
			this.resList.push(res);
			var urlList:Vector.<String> = res.urlList;
			for(var i:int = 0;i < urlList.length;i ++){
				var url:String = urlList[i];
				trace(url);
				this.addUrl(url);
			}
		}
		
		/**
		 * 返回url 对应资源的标识ID，是url 的MD5值，用于取出资源
		 * @param url 资源地址
		 * @param type ResType.MEDIA 或  URL type等 于null时，按扩展名自动处理
		 * 
		 */		
		public function addUrl(url:String,resLoadType:String = null):String{
			var urlMd5:String = null;
			if(!isLoading && url != null){
				if(resLoadType == null){
					resLoadType = getLoaderType(url);
				}
				this.urlList.push(url);
				this.loadTypeList.push(resLoadType);
				urlMd5 = MD5.hash(url);
			}
			return urlMd5;
		}
		
		/**
		 * 扩展名判断加载类型
		 * @param url 
		 * @return 
		 * 
		 */		
		private function getLoaderType(url:String):String{
			var type:String = ResLoaderType.URL;
			var dotIndex:int = url.lastIndexOf(".");
			if(dotIndex > 0){
				var eName:String = url.substring(dotIndex + 1,url.length);
				if(    eName.toLocaleLowerCase() == "swf" 
					|| eName.toLocaleLowerCase() == "png"
					|| eName.toLocaleLowerCase() == "jpg"
					|| eName.toLocaleLowerCase() == "gif"){
					type = ResLoaderType.MEDIA;
				}
			}
			return type;
		}
		
		/**
		 * 获得资源 
		 * @param urlMd5
		 * @return 
		 * 
		 */		
		public function getResByUrlMd5(urlMd5:String):Object{
			return this.resDataList.findByName(urlMd5);
		}
		
		/**
		 * 获得资源 
		 * @param index
		 * @return 
		 * 
		 */		
		public function getResByIndex(index:int):Object{
			return this.resDataList.findByIndex(index);
		}
		
		/**
		 * 资源个数 
		 * @return 
		 * 
		 */		
		public function get length():int{
			return this.resDataList.length;
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
				if(loadType == ResLoaderType.MEDIA){
					var rl:ResLoader = new ResLoader();
					rl.addEventListener(ResLoaderEvent.IS_RECEIVE_BYTES_TOTAL,handlerIsReceiveBytes);
					var rlinfo:LoaderInfo = rl.contentLoaderInfo;
					rlinfo.addEventListener(Event.COMPLETE,handlerLoadComplete);
					rlinfo.addEventListener(IOErrorEvent.IO_ERROR,handlerLoadIoError);
					rlinfo.addEventListener(ProgressEvent.PROGRESS,handlerProgress);
					rl.load(new URLRequest(url));
				}
				else if(loadType == ResLoaderType.URL){
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
			if(e.currentTarget is LoaderInfo){
				var li:LoaderInfo = e.currentTarget as LoaderInfo;
				var rl:ResLoader = li.loader as ResLoader;
				this.resDataList.push(li,rl.urlMd5);
			}
			else if(e.currentTarget is ResURLLoader){
				var rul:ResURLLoader = e.currentTarget as ResURLLoader;
				bytesLoaded = rul.bytesLoaded;
				this.resDataList.push(rul.data,rul.urlMd5);
			}
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
				setResObjToRes();
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
		
		private function setResObjToRes():void{
			for(var i:int = 0;i < this.resList.length;i ++){
				var res:ResBase = this.resList[i];
				if(res != null){
					var rdlist:Vector.<Object> = new Vector.<Object>();
					for(var j:int = 0;j < res.urlMd5List.length;j ++){
						var urlMd5:String = res.urlMd5List[j];
						var obj:Object = this.resDataList.findByName(urlMd5);
						rdlist.push(obj);
					}
					res.resDataList = rdlist;
					res.callBack();
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