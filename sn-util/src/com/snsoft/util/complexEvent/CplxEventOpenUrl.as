package com.snsoft.util.complexEvent{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	/**
	 * 给显示对象添加事件，响应事件后打开地址
	 * @author Administrator
	 * 
	 */	
	public class CplxEventOpenUrl extends EventDispatcher{
		
		private var dobj:DisplayObject;
		
		private var eventType:String;
		
		private var url:String;
		
		private var window:String;
		
		/**
		 * 事件对象/事件类形/url地址/打开方式 
		 * @param dobj
		 * @param eventType
		 * @param url
		 * @param window
		 * 
		 */		
		public function CplxEventOpenUrl(dobj:DisplayObject,eventType:String,url:String,window:String = "_self"){
			this.dobj = dobj;
			this.eventType = eventType;
			this.url = url;
			this.window = window;
			addEvent();
		}
		
		/**
		 * 移除事件侦听 
		 * 
		 */		
		public function removeEvent():void{
			dobj.removeEventListener(eventType,handler);
		}
		
		private function addEvent():void{
			dobj.addEventListener(eventType,handler);
		}
		
		private function handler(e:Event):void{
			try{
				var req:URLRequest = new URLRequest(url);
				navigateToURL(req,window);
			}
			catch (e:Error){
				trace("打开地址出错:"+ url);
			}
			this.dispatchEvent(new Event(eventType));
		}
		
		
	}
}