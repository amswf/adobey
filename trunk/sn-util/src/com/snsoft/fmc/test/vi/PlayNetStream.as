package com.snsoft.fmc.test.vi{
	import flash.events.IOErrorEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	public class PlayNetStream extends NetStream{
		
		private var playParameters:Array;		
		
		public function PlayNetStream(connection:NetConnection, peerID:String="connectToFMS")
		{
			super(connection, peerID);
			
			this.addEventListener(IOErrorEvent.IO_ERROR,handerIOError);
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
	}
}