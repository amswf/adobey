package com.snsoft.fmc.test.vi{
	import com.snsoft.fmc.NSICode;
	import com.snsoft.fmc.test.PerformTest;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	public class PlayNetStream extends NetStream{
		
		private var playParameters:Array;		
		
		private var pt:PerformTest;
		
		public function PlayNetStream(connection:NetConnection, peerID:String="connectToFMS")
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
		public function uuPlay(... parameters):void{
			this.playParameters = parameters;
			super.play.apply(null,parameters);
		}
		
		private function handerIOError(e:IOErrorEvent):void{
			trace("IO错误，重新获得视频");
			super.play.apply(null,playParameters);
		}
		
		private function handerAsyncError(e:AsyncErrorEvent):void{
			trace("Async错误，重新获得视频");
			super.play.apply(null,playParameters);
		}
		
		private function handerNetStatus(e:NetStatusEvent):void{
			//pt.setMsg("Status播放状态" + e.info.code);
			if(e.info.code == NSICode.NetStream_Play_Failed){
				pt.setMsg("Status状态" + e.info.code + "重新获得视频");
				super.play.apply(null,playParameters);
			}
			if(e.info.code == NSICode.NetStream_Play_PublishNotify){
				//这里要找到NetStream.send  发不过来的原因。
				super.play.apply(null,playParameters);
			}
		}		
	}
}
