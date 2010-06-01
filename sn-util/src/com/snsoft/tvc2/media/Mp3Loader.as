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
		
		//已经加载的声音个数
		private var _loadedNum:int;
		
		private var isDispatchEvent:Boolean;
		
		
		/**
		 * 加载声音列表
		 * @param list
		 * 
		 */		
		public function loadList(list:Vector.<String>):void{
			_loadedNum = 0;
			_soundList = new Vector.<Sound>();
			
			if(list != null){
				for(var i:int = 0;i<list.length;i++){
					var url:String = list[i];
					if(url != null && url.length > 0){
						this.load(url);
					}
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
			var sound:Sound = e.currentTarget as Sound;
			trace("加载mp3 出错!" + this._soundList);
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
			if(this.loadedNum == this.soundList.length && !isDispatchEvent){
				isDispatchEvent = true;
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