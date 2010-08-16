package com.snsoft.room3d{
	import com.snsoft.xmldom.Node;
	import com.snsoft.xmldom.XMLDom;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class XMLLoader extends EventDispatcher{
		
		//xml地址
		private var xmlUrl:String;
		
		//XML数据
		private var xml:XML;
		
		public function XMLLoader(xmlUrl:String){
			this.xmlUrl = xmlUrl;
			loadXML();
			
		}
		
		private function loadXML():void{
			var request:URLRequest = new URLRequest(xmlUrl);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,handlerLoadXMLCmp);
			loader.addEventListener(IOErrorEvent.IO_ERROR,handlerLoadXMLIOError);
			loader.load(request);
		}
		
		private function parseXML():void{
			var xdom:XMLDom = new XMLDom(xml);
			var node:Node = xdom.parse();
			trace(node.name);
		}
		
		
		private function handlerLoadXMLCmp(e:Event):void{
			var loader:URLLoader = e.currentTarget as URLLoader;
			xml = new XML(loader.data);
			parseXML();
		}
		
		private function handlerLoadXMLIOError(e:Event):void{
			trace("加载XML出错："+xmlUrl);
		}
		
	}
}