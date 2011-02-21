package com.snsoft.fmc.test{
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	public class SendNetStream extends NetStream{
		public function SendNetStream(connection:NetConnection, peerID:String="connectToFMS")
		{
			super(connection, peerID);
		}
		
		public function onMetaData(infoObject:Object):void { 
			trace("metadata"); 
		}
	}
}