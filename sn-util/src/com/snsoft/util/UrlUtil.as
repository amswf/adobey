package com.snsoft.util{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	
	/**
	 * 打开URL地址 
	 * @author Administrator
	 * 
	 */	
	public class UrlUtil extends EventDispatcher{
		
		private var url:String;
		
		private var window:String;
		
		public function UrlUtil(){
			
		}
		
		public static function openUrl(url:String,window:String="_self",method:String = "GET",urlvariables:URLVariables = null):void{
			var contentType:URLRequestHeader = new URLRequestHeader("Content-Type", "text/html; charset=utf-8");
			var req:URLRequest = new URLRequest(url);
			req.requestHeaders.push(contentType);
			req.method = method;
			if(urlvariables != null){
				req.data = urlvariables;
			}
			
			trace(req.method,req.data);
			try{
				navigateToURL(req,window);
			}
			catch(e:Error){
				trace("打开地址出错：" +　url);
			}
		}
		
		/**
		 * 把get 请求ulr参数转成post 参数对象 
		 * @param url
		 * @return 
		 * 
		 */		
		public static function tranGetParamToPostData(url:String):URLVariables{
			var psi:int = url.indexOf("?") + 1;
			var urlvariables:URLVariables = new URLVariables(); 
			if(psi >= 0){
				var ps:String = url.slice(psi);
				var pa:Array = ps.split("&");
				for( var i:int = 0 ;i < pa.length;i ++){
					var p:String = pa[i];
					var pi:int = p.indexOf("=");
					if(pi >= 0){
						var name:String = p.slice(0,pi);
						var value:String = p.slice(pi+1);
						
						trace(name,value);
						urlvariables[name] = value;
					}
				}
			}
			return urlvariables;
		}
		
		public static function getUrlExceptParam(url:String):String{
			var psi:int = url.indexOf("?");
			var surl:String = new String();
			if(psi >= 0){
				surl = url.slice(0,psi);
			}
			else {
				surl = url;
			}
			return surl;
		}
	}
}