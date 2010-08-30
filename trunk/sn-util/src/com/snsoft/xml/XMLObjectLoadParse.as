package com.snsoft.xml
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * 处理XML描述的数据结构或数据对象，还原成对象形式。 
	 * @author Administrator
	 * 
	 */	
	public class XMLObjectLoadParse extends EventDispatcher
	{
		
		/**
		 * xml路径或地址 
		 */		
		private var xmlUrl:String = null;
			
		/**
		 * 构造方法 
		 * @param target
		 * 
		 */				
		public function XMLObjectLoadParse(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function parse(xmlUrl:String):void{
			if(xmlUrl != null && xmlUrl.length > 0){
				this.xmlUrl = xmlUrl;
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE,handlerLoadComplete);
				urlLoader.load(new URLRequest(xmlUrl));
			}	
		}
		
		public function handlerLoadComplete(e:Event):void{
			var urlLoader:URLLoader = e.currentTarget as URLLoader;
			if(urlLoader.data != null){
				var obj:Object = new Object();
				var xml:XML = new XML(urlLoader.data);
				var xmlList:XMLList = xml.children();
				for(var i:int = 0;i<xmlList.length();i++){
					var cxml:XMLList = xmlList[i];
					var nodeName:String = cxml.name();
					if(nodeName != null && nodeName.length > 0){
						nodeName = nodeName.toLowerCase();
						if(nodeName == "states"){
							var stateList:XMLList = cxml;
							for(var si:int = 0;si <stateList.length();si++){
								var state:XML = stateList[i];
								
							}
						}
					}
					
				}
			}
			
		}
	}
}