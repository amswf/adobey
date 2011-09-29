package com.snsoft.util.rlm {
	import com.snsoft.util.HashVector;
	import com.snsoft.util.rlm.loader.LdLoader;
	import com.snsoft.util.rlm.loader.LdLoaderEvent;
	import com.snsoft.util.rlm.loader.LdLoaderType;
	import com.snsoft.util.rlm.loader.LdSoundLoader;
	import com.snsoft.util.rlm.loader.LdURLLoader;
	import com.snsoft.util.rlm.rs.ResSet;

	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;

	[Event(name = "complete", type = "flash.events.Event")]
	[Event(name = "progress", type = "flash.events.ProgressEvent")]
	[Event(name = "ioError", type = "flash.events.IOErrorEvent")]
	/**
	 * 资源加载管理器
	 * resources load manager
	 * @author Administrator
	 *
	 */
	public class ResLoadManager extends EventDispatcher {

		/**
		 * 加载类型  顺序/非顺序 ResLoadManagerType
		 */
		private var type:String;

		/**
		 * 地址列表
		 */
		private var urlList:Vector.<String>  = new Vector.<String>;

		/**
		 * 加载文件类
		 */
		private var loadTypeList:Vector.<String>  = new Vector.<String>;

		/**
		 * 加载到的资源列表
		 */
		private var resDataList:HashVector = new HashVector(true);

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

		/**
		 * 资源集列表
		 */
		private var resSetList:Vector.<ResSet>  = new Vector.<ResSet>;

		/**
		 * 非顺序加载时，已加载字节数的列表
		 */
		private var bytesLoadedList:HashVector = new HashVector(true);

		private var isStop:Boolean = false;

		/**
		 *
		 * @param type ResLoadManagerType.ORDERED / UNORDERED
		 *
		 */
		public function ResLoadManager(type:String = "ordered") {
			this.type = type;
		}

		/**
		 * 添加资源
		 * @param res
		 *
		 */
		public function addResSet(resSet:ResSet):void {
			this.resSetList.push(resSet);
			var urlList:Vector.<String>  = resSet.urlList;
			for (var i:int = 0; i < urlList.length; i++) {
				var url:String = urlList[i];
				this.addResUrl(url);
			}
		}

		public function stop():void {
			isStop = true;
		}

		/**
		 *
		 * @param url 资源地址
		 * @param type ResType.MEDIA 或  URL type等 于null时，按扩展名自动处理
		 *
		 */
		public function addResUrl(url:String, resLoadType:String = null):void {
			if (!isLoading && url != null) {
				if (resLoadType == null) {
					resLoadType = LdLoaderType.getType(url);
				}
				this.urlList.push(url);
				this.loadTypeList.push(resLoadType);
			}
		}

		/**
		 * 获得资源
		 * @param index
		 * @return
		 *
		 */
		public function getResByIndex(index:int):Object {
			return this.resDataList.findByIndex(index);
		}

		/**
		 * 获得资源
		 * @param index
		 * @return
		 *
		 */
		public function getResByResUrl(resUrl:String):Object {
			return this.resDataList.findByName(resUrl);
		}

		/**
		 * 资源个数
		 * @return
		 *
		 */
		public function get length():int {
			return this.resDataList.length;
		}

		public function getProgressValue():Number {
			if (this.type == ResLoadManagerType.UNORDERED) {
				var bld:int = 0;
				for (var i:int = 0; i < this.bytesLoadedList.length; i++) {
					var bl:int = bytesLoadedList.findByIndex(i) as int;
					bld += bl;
				}
				return bld / this.bytesTotal;
			}
			else {
				return this.loadCmpCount / this.urlList.length + this.bytesLoaded / (this.bytesTotal * this.urlList.length);
			}
		}

		/**
		 * 加载启动
		 *
		 */
		public function load():void {
			if (!isLoading) {
				if (this.type == ResLoadManagerType.UNORDERED) {
					//非顺序加载
					for (var i:int = 0; i < this.urlList.length; i++) {
						if (isStop) {
							break;
						}
						loadNext(i);
					}
				}
				else {
					loadNext(this.loadCmpCount);
				}
			}
		}

		private function loadNext(i:int):void {
			if (!isStop) {
				var url:String = this.urlList[i];
				var loadType:String = this.loadTypeList[i];
				if (url != null && url.length > 0) {
					if (loadType == LdLoaderType.SWF || loadType == LdLoaderType.IMAGE) {
						var rl:LdLoader = new LdLoader;
						rl.addEventListener(LdLoaderEvent.IS_RECEIVE_BYTES_TOTAL, handlerIsReceiveBytes);
						var rlinfo:LoaderInfo = rl.contentLoaderInfo;
						rlinfo.addEventListener(Event.COMPLETE, handlerLoadComplete);
						rlinfo.addEventListener(IOErrorEvent.IO_ERROR, handlerLoadIoError);
						rlinfo.addEventListener(ProgressEvent.PROGRESS, handlerProgress);
						rl.load(new URLRequest(url));
					}
					else if (loadType == LdLoaderType.URL) {
						var rul:LdURLLoader = new LdURLLoader;
						rul.addEventListener(LdLoaderEvent.IS_RECEIVE_BYTES_TOTAL, handlerIsReceiveBytes);
						rul.addEventListener(Event.COMPLETE, handlerLoadComplete);
						rul.addEventListener(IOErrorEvent.IO_ERROR, handlerLoadIoError);
						rul.addEventListener(ProgressEvent.PROGRESS, handlerProgress);
						rul.load(new URLRequest(url));
					}
					else if (loadType == LdLoaderType.SOUND) {
						var rsl:LdSoundLoader = new LdSoundLoader();
						rsl.addEventListener(LdLoaderEvent.IS_RECEIVE_BYTES_TOTAL, handlerIsReceiveBytes);
						rsl.addEventListener(Event.COMPLETE, handlerLoadComplete);
						rsl.addEventListener(IOErrorEvent.IO_ERROR, handlerLoadIoError);
						rsl.addEventListener(ProgressEvent.PROGRESS, handlerProgress);
						rsl.load(new URLRequest(url));
					}
				}
			}
		}

		private function handlerIsReceiveBytes(e:Event):void {
			if (this.type == ResLoadManagerType.UNORDERED) {
				this.bytesTotal += this.getLoaderBytesTotal(e);
			}
			else {
				this.bytesTotal = this.getLoaderBytesTotal(e);
			}
		}

		private function handlerLoadComplete(e:Event):void {
			this.loadCmpCount++;
			if (e.currentTarget is LoaderInfo) {
				var li:LoaderInfo = e.currentTarget as LoaderInfo;
				var rl:LdLoader = li.loader as LdLoader;
				this.resDataList.push(li, rl.url);
			}
			else if (e.currentTarget is LdURLLoader) {
				var rul:LdURLLoader = e.currentTarget as LdURLLoader;
				bytesLoaded = rul.bytesLoaded;
				this.resDataList.push(rul.data, rul.url);
			}
			else if (e.currentTarget is LdSoundLoader) {
				var rsl:LdSoundLoader = e.currentTarget as LdSoundLoader;
				this.resDataList.push(rsl, rsl.url);
			}
			checkLoadsCmp();
		}

		private function handlerLoadIoError(e:Event):void {
			this.dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
			this.loadCmpCount++;
			this.errorCount++;
			checkLoadsCmp();
		}

		private function handlerProgress(e:Event):void {
			if (this.type == ResLoadManagerType.UNORDERED) {
				var value:int = this.getLoaderBytesLoaded(e);
				var name:String = this.getLoaderUrl(e);
				this.bytesLoadedList.push(value, name);
			}
			else {
				this.bytesLoaded = this.getLoaderBytesLoaded(e);
			}
			this.dispatchEvent(new Event(ProgressEvent.PROGRESS));
		}

		private function checkLoadsCmp():void {
			if (this.loadCmpCount == this.urlList.length) {
				setResObjToRes();
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
			else {
				if (this.type == ResLoadManagerType.UNORDERED) {

				}
				else {
					loadNext(this.loadCmpCount);
				}
			}
		}

		private function setResObjToRes():void {
			for (var i:int = 0; i < this.resSetList.length; i++) {
				var res:ResSet = this.resSetList[i];
				if (res != null) {
					var rdlist:Vector.<Object>  = new Vector.<Object>;
					for (var j:int = 0; j < res.urlList.length; j++) {
						var url:String = res.urlList[j];
						var obj:Object = this.resDataList.findByName(url);
						rdlist.push(obj);
					}
					res.rlm::setResDataList(rdlist);
					res.rlm::loadCmpCallBack();
				}
			}
		}

		/**
		 *
		 * @param e
		 * @return
		 *
		 */
		private function getLoaderBytesTotal(e:Event):uint {
			var bytesTotal:uint = 0;
			if (e.currentTarget is LdLoader) {
				var rl:LdLoader = e.currentTarget as LdLoader;
				bytesTotal = rl.contentLoaderInfo.bytesTotal;
			}
			else if (e.currentTarget is LdURLLoader) {
				var rul:LdURLLoader = e.currentTarget as LdURLLoader;
				bytesTotal = rul.bytesTotal;
			}
			else if (e.currentTarget is LdSoundLoader) {
				var rsl:LdSoundLoader = e.currentTarget as LdSoundLoader;
				bytesTotal = rsl.bytesTotal;
			}
			return bytesTotal;
		}

		/**
		 *
		 * @param e
		 * @return
		 *
		 */
		private function getLoaderBytesLoaded(e:Event):int {
			var bytesLoaded:int = 0;
			if (e.currentTarget is LoaderInfo) {
				var li:LoaderInfo = e.currentTarget as LoaderInfo;
				bytesLoaded = li.bytesLoaded;
			}
			else if (e.currentTarget is LdURLLoader) {
				var rul:LdURLLoader = e.currentTarget as LdURLLoader;
				bytesLoaded = rul.bytesLoaded;
			}
			else if (e.currentTarget is LdSoundLoader) {
				var rsl:LdSoundLoader = e.currentTarget as LdSoundLoader;
				bytesLoaded = rsl.bytesLoaded;
			}
			return bytesLoaded;
		}

		private function getLoaderUrl(e:Event):String {
			var url:String = null;
			if (e.currentTarget is LoaderInfo) {
				var li:LoaderInfo = e.currentTarget as LoaderInfo;
				var rl:LdLoader = li.loader as LdLoader;
				url = rl.url;
			}
			else if (e.currentTarget is LdURLLoader) {
				var rul:LdURLLoader = e.currentTarget as LdURLLoader;
				url = rul.url;
			}
			else if (e.currentTarget is LdSoundLoader) {
				var rsl:LdSoundLoader = e.currentTarget as LdSoundLoader;
				url = rsl.url;
			}
			return url;
		}
	}
}
