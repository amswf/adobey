package com.snsoft.util.complexEvent{
	import com.snsoft.util.UrlUtil;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
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
		
		private var method:String;
		
		private var postData:URLVariables;
		
		/**
		 * 事件对象/事件类形/url地址/打开方式 
		 * @param dobj
		 * @param eventType
		 * @param url
		 * @param window
		 * 
		 */		
		public function CplxEventOpenUrl(dobj:DisplayObject,eventType:String,url:String,window:String = "_self",method:String = "GET",postData:URLVariables = null){
			this.dobj = dobj;
			this.eventType = eventType;
			this.method = method;
			this.url = url;
			this.postData = postData;
			if(window == null){
				window = "_self";
			}
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
			UrlUtil.openUrl(url,window,method,postData);
			this.dispatchEvent(new Event(eventType));
		}
		
		
	}
}