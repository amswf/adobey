package com.snsoft.fmc.test.vi{
	import com.snsoft.util.UUID;
	
	import flash.net.NetConnection;

	public class UUNetConnection extends NetConnection{
		
		private var _uuid:String;
		
		public function UUNetConnection()
		{
			this.uuid = UUID.create();
		}
		
		/**
		 * 替代NetConnection.connect方法 
		 * @param command
		 * 
		 */		
		public function uuconnect(command:String):void{
			
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