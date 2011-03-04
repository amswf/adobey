package com.snsoft.fmc.test{
	
	import flash.display.Sprite;
	import flash.events.NetStatusEvent;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.ObjectEncoding;
	import flash.utils.setTimeout;
	
	public class TestSend extends Sprite
	{
		private var nc:NetConnection = new NetConnection();
		private var ns1:NetStream;
		private var ns2:SendNetStream;
		private var vid:Video = new Video(300,300);
		private var obj:Object = new Object();
		
		public function TestSend() {
			nc.objectEncoding = ObjectEncoding.AMF0;
			nc.client = this;
			nc.addEventListener("netStatus", onNCStatus);
			nc.connect("rtmp://60.10.151.28/live");
			addChild(vid); 
		}
		
		private function onNCStatus(event:NetStatusEvent):void {
			switch (event.info.code) {
				case "NetConnection.Connect.Success":
					trace("You've connected successfully");
					ns1 = new NetStream(nc);
					ns2 = new SendNetStream(nc);
					var c:Camera = Camera.getCamera();
					ns1.client = new CustomClient();;
					ns1.attachCamera(c);
					ns1.publish("dummy", "live");
					
					ns2.play("dummy");
					vid.attachNetStream(ns2);
					setTimeout(sendHello, 3000);
					break;
				
				case "NetStream.Publish.BadName":
					trace("Please check the name of the publishing stream" );
					break;
			}   
		}
		private function sendHello():void {
			ns1.send("@setDataFrame", "onMetaData","lala");
		}   
		
		public function onMetaData(event:String):void {
			trace(event);
		}
		
		/**
		 * 客户端回调方法，必须要有 
		 * 
		 */		
		public function onBWDone():void{
			trace("onBWDone");
		}
	}
}

class CustomClient {
	
	public function onMetaData(obj:Object):void {
		trace("onMetaData");
	}
}
