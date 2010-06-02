package com.snsoft.tvc2.media{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;

	public class Mp3Loader extends EventDispatcher{
		
		public function Mp3Loader(target:IEventDispatcher = null){
			super(target);
		}
		
		//声音列表 Sound 对象
		private var _soundList:Vector.<Sound>;
		
		//mp3文件地址列表
		private var urlList:Vector.<String>;
		
		//已经加载的声音个数
		private var _loadedNum:int;
		
		
		/**
		 * 加载声音列表
		 * @param list
		 * 
		 */		
		public function loadList(list:Vector.<String>):void{
			_loadedNum = 0;
			_soundList = new Vector.<Sound>();
			
			if(list != null && list.length > 0){
				this.urlList = list;
				var url:String = this.urlList[_loadedNum];
				if(url != null && url.length > 0){
					this.load(url);
				}
			}
		}
		
		/**
		 * 
		 * @param url
		 * @return 
		 * 
		 */		
		private function load(url:String):void {
			var reqStream:URLRequest = new URLRequest(url);
			var sound:Sound = new Sound(reqStream);
			sound.addEventListener(Event.COMPLETE,handlerLoadSoundComplete);
			sound.addEventListener(IOErrorEvent.IO_ERROR,handlerIOError);
		}
		
		private function handlerIOError(e:Event):void{
			var url:String = this.urlList[_loadedNum];
			trace("加载mp3 出错!" + url);
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerLoadSoundComplete(e:Event):void {
			var s:Sound = e.currentTarget as Sound;
			s.removeEventListener(Event.COMPLETE,handlerLoadSoundComplete);
			this._soundList.push(s);//可能需要优化，列表中已存在，就不再次加载了。
			this._loadedNum ++;
			if(this.loadedNum != this.urlList.length){
				var url:String = this.urlList[_loadedNum];
				this.load(url);
			}
			else{
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}

		public function get soundList():Vector.<Sound> {
			return _soundList;
		}

		public function get loadedNum():int	{
			return _loadedNum;
		}

		
	}
}