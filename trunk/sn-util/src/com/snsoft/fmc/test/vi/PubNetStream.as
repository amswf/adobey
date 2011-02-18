package com.snsoft.fmc.test.vi{
	import com.snsoft.fmc.NSICode;
	import com.snsoft.fmc.test.PerformTest;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	/**
	 * 发布视频，扩展 NetStream 断线，重链
	 * @author Administrator
	 * 
	 */	
	public class PubNetStream extends NetStream{
		
		private var pubName:String;
		
		private var pubType:String;
		
		private var pt:PerformTest;
		
		public function PubNetStream(connection:NetConnection, peerID:String="connectToFMS")
		{
			super(connection, peerID);
			this.addEventListener(IOErrorEvent.IO_ERROR,handerIOError);
			this.addEventListener(AsyncErrorEvent.ASYNC_ERROR,handerAsyncError);
			this.addEventListener(NetStatusEvent.NET_STATUS,handerNetStatus);
		}
		
		public function setPerformTest(pt:PerformTest):void{
			this.pt = pt;
		}
		
		/**
		 * 扩展了publish方法 
		 * @param name
		 * @param type
		 * 
		 */		
		public function uuPublish(name:String,type:String):void{
			this.pubName = name;
			this.pubType = type;
			super.publish(name,type); 
		}
		
		private function handerIOError(e:IOErrorEvent):void{
			trace("IO错误，重新发布视频");
			super.publish(pubName,pubType); 
		}
		
		private function handerAsyncError(e:AsyncErrorEvent):void{
			trace("Async错误，重新发布视频");
			super.publish(pubName,pubType); 
		}
		
		private function handerNetStatus(e:NetStatusEvent):void{
			pt.setMsg("Pub状态" + e.info.code);
			if(e.info.code == NSICode.NetStream_Publish_Idle){
				pt.setMsg("Status状态" + e.info.code + "重新发布视频");
				super.publish(pubName,pubType); 
			}
		}
		
	}
}