package com.snsoft.sndoor{
	import com.snsoft.util.HashVector;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	/**
	 * 媒体盒子，swf/图片混合管理器 
	 * @author Administrator
	 * 
	 */	
	public class MediaBox extends EventDispatcher{
			
		/**
		 * 媒体文件列表
		 */		
		private var mediaDisplayObjectV:HashVector = new HashVector();
		
		/**
		 * 媒体文件地址列表
		 */		
		private var mediaUrlV:Vector.<String> = new Vector.<String>();
		
		private var _loadingCount:int = 0;
		
		private var _allCount:int = 0;
		
		private var isLoadingCmp:Boolean = false;
		
		private var isLoading:Boolean = false;
		
		public static const EVENT_LOADING:String = "EVENT_LOADING";
		
		/**
		 * 
		 * @param mediaUrlV
		 * 
		 */		
		public function MediaBox(mediaUrlV:Vector.<String> = null)
		{
			if(mediaUrlV != null){
				this.mediaUrlV = mediaUrlV;
			}
		}
		
		public function addMediaUrl(url:String):void{
			mediaUrlV.push(url);
			_allCount = mediaUrlV.length;
		}
		
		public function getMediaByUrl(url:String):DisplayObject{
			return mediaDisplayObjectV.findByName(url) as DisplayObject;
		}
		
		/**
		 * 加载图片 
		 * 
		 */		
		public function loadMedia():void{
			if(!isLoading){
				isLoading = true;
				loadingMedia();
			}
		}
		
		/**
		 * 
		 * 
		 */		
		private function loadingMedia():void{
			if(loadingCount < mediaUrlV.length){
				var url:String = mediaUrlV[loadingCount];
				var req:URLRequest = new URLRequest(url);
				var loader:Loader = new Loader();
				var context:LoaderContext = new LoaderContext();
				loader.load(req,context);
				var info:LoaderInfo = loader.contentLoaderInfo;
				info.addEventListener(Event.COMPLETE,handlerLoadComplete);
				info.addEventListener(IOErrorEvent.IO_ERROR,handlerLoadIOError);
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
		private function handlerLoadComplete(e:Event):void{
			var info:LoaderInfo = e.currentTarget as LoaderInfo;
			var dobj:DisplayObject = info.content;
			if(dobj is MovieClip){
				var mc:MovieClip = dobj as MovieClip;
				mc.stop();
			}
			var url:String = mediaUrlV[loadingCount];
			mediaDisplayObjectV.push(dobj,url);
			_loadingCount ++;
			this.dispatchEvent(new Event(EVENT_LOADING));
			loadingMedia();
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerLoadIOError(e:Event):void{
			_loadingCount ++;
			this.dispatchEvent(new Event(EVENT_LOADING));
			loadingMedia();
		}

		public function get loadingCount():int
		{
			return _loadingCount;
		}

		public function get allCount():int
		{
			return _allCount;
		}

		public function set allCount(value:int):void
		{
			_allCount = value;
		}


	}
}