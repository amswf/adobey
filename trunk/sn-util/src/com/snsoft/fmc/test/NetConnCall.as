package com.snsoft.fmc.test{
	import flash.display.Sprite;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.events.NetStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.net.Responder;
	
	public class NetConnCall extends Sprite{
		public function NetConnCall(){
			super();
			init();
		}
		
		public function init():void{
			var nc:NetConnection = new NetConnection();
			nc.client = this;
			nc.connect("rtmp://192.168.0.22/oflaDemo");
			nc.addEventListener(NetStatusEvent.NET_STATUS,handlerNCStatus);
			nc.addEventListener(IOErrorEvent.IO_ERROR,handlerIOError);
			
			
			
			var rspd:Responder = new Responder(ncResult,ncStatus);
			
			function handlerNCStatus(e:Event):void {
				//调用red5的Service
				nc.call("demoService.getListOfAvailableFLVs",rspd);
			}
			
			function handlerIOError(e:Event):void {
				trace("handlerIOError");
			}
			
			function ncResult(obj:Object):void{
				trace("ncResult");
				//返回视频列表
				for(var items:String in obj)
				{
					trace(items);
				}
			}
			
			function ncStatus(obj:Object):void{
				trace("ncStatus");
			}
		}
		
		public function onBWDone():void{
			trace("onBWDone");
		} 
	}
}