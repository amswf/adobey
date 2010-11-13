package com.snsoft.util{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class UrlUtil extends EventDispatcher{
		
		private var url:String;
		
		private var window:String;
		
		public function UrlUtil(){
			
		}
		
		public static function openUrl(url:String,window:String="_self"):void{
			var req:URLRequest = new URLRequest(url);
			try{
				navigateToURL(req,window);
			}
			catch(e:Error){
				trace("打开地址出错：" +　url);
			}
		}
	}
}