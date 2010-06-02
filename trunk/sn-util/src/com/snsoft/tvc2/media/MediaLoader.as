package com.snsoft.tvc2.media{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	public class MediaLoader extends EventDispatcher{
		
		//媒体文件列表	
		private var _mediaList:Vector.<DisplayObject>;
		
		//媒体文件地址列表
		private var urlList:Vector.<String>;
		
		//已经加载的声音个数
		private var _loadedNum:int;
		
		//是否已经调度事件
		private var isDispatchEvent:Boolean;
		
		public function MediaLoader(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function loadList(list:Vector.<String>):void{
			this._loadedNum = 0;
			this._mediaList = new Vector.<DisplayObject>();
			if(list != null){
				this.urlList = list;
				var url:String = this.urlList[_loadedNum];
				if(url != null && url.length > 0){
					this.load(url);
				}
				 
			}
		}
		
		private function load(url:String):void{
			var req:URLRequest = new URLRequest(url);
			var loader:Loader = new Loader();
			var context:LoaderContext = new LoaderContext();
			loader.load(req,context);
			var info:LoaderInfo = loader.contentLoaderInfo;
			info.addEventListener(Event.COMPLETE,handlerLoadComplete);
			info.addEventListener(IOErrorEvent.IO_ERROR,handlerLoadIOError);
		}
		
		private function handlerLoadComplete(e:Event):void{
			var info:LoaderInfo = e.currentTarget as LoaderInfo;
			var dobj:DisplayObject = info.content;
			this._mediaList.push(dobj);
			this._loadedNum ++;
			if(this._loadedNum != this.urlList.length){
				var url:String = this.urlList[_loadedNum];
				if(url != null && url.length > 0){
					this.load(url);
				}
			}
			else {
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function handlerLoadIOError(e:Event):void{
			var info:LoaderInfo = e.currentTarget as LoaderInfo;
			trace("加载媒体出错!" + info.url);
		}

		public function get loadedNum():int
		{
			return _loadedNum;
		}

		public function get mediaList():Vector.<DisplayObject>
		{
			return _mediaList;
		}

		
	}
}