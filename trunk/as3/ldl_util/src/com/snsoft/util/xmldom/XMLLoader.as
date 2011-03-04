package com.snsoft.util.xmldom{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class XMLLoader extends EventDispatcher{
		
		private var url:String;
		
		private var _xml:XML;
		
		public function XMLLoader(url:String){
			this.url = url;
			loadConfig();
		}
		
		/**
		 * 
		 * 
		 */				
		private function loadConfig():void{
			var request:URLRequest = new URLRequest(url);	
			var loader:URLLoader = new URLLoader();
			loader.load(request);
			loader.addEventListener(Event.COMPLETE,handlerConfigLoadComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR,handlerConfigLoadIOError);
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerConfigLoadIOError(e:Event):void{
			trace("地址错误：",url);
			this.dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerConfigLoadComplete(e:Event):void{
			var loader:URLLoader = e.currentTarget as URLLoader;
			_xml = new XML(loader.data);
			this.dispatchEvent(new Event(Event.COMPLETE));
		}

		public function get xml():XML
		{
			return _xml;
		}

	}
}