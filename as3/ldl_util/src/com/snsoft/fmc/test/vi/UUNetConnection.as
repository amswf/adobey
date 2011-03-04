package com.snsoft.fmc.test.vi
{
	import com.snsoft.util.UUID;

	import flash.net.NetConnection;
	import flash.events.IOErrorEvent;
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;

	public class UUNetConnection extends NetConnection
	{

		private var _uuid:String;

		public function UUNetConnection()
		{
			this.uuid = UUID.create();
			this.addEventListener(IOErrorEvent.IO_ERROR,handerIOError);
			this.addEventListener(AsyncErrorEvent.ASYNC_ERROR,handerAsyncError);
			this.addEventListener(NetStatusEvent.NET_STATUS,handerNetStatus);
		}
		private function handerIOError(e:IOErrorEvent):void
		{
			trace("IO错误，重新获得视频");
		}

		private function handerAsyncError(e:AsyncErrorEvent):void
		{
			trace("Async错误，重新获得视频");
		}

		private function handerNetStatus(e:NetStatusEvent):void
		{
			trace("conn状态" + e.info.code);
		}

		/**
		 * 替代NetConnection.connect方法 
		 * @param command
		 * 
		 */
		public function uuconnect(command:String):void
		{

			super.connect(command,this.uuid);
		}

		public function get uuid():String
		{
			return _uuid;
		}

		public function set uuid(value:String):void
		{
			_uuid = value;
		}


	}
}