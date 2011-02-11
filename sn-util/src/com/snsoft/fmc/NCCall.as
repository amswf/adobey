package com.snsoft.fmc{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.NetConnection;
	import flash.net.Responder;
	
	/**
	 * NetConnectionCall  
	 * @author Administrator
	 * 
	 */	
	public class NCCall extends EventDispatcher{
		
		/**
		 * 
		 */		
		private var rspd:Responder = new Responder(localNcCallSeatListResult,localNcCallSeatListStatus);
		
		/**
		 * 正常反回结果 
		 */
		private var _resultObj:Object = null;
		
		/**
		 * 错误反回结果 
		 */
		private var _statusObj:Object = null;
		
		/**
		 * NetConnectionCall 
		 * @param conn
		 * @param command
		 * @param arguments
		 * 
		 */		
		public function NCCall(conn:NetConnection,command:String, ... arguments){
			var arg:Array = arguments as Array;
			arg.splice(0,0,rspd);
			arg.splice(0,0,command);
			conn.call.apply(null,arg);
		}
		
		/**
		 * 共享对象Responder事件  
		 * @param obj
		 * 
		 */		
		private function localNcCallSeatListResult(obj:Object):void{	
			this.resultObj = obj;
			this.dispatchEvent(new Event(NCCEvent.RESULT));
		}
		
		/**
		 * 共享对象Responder事件 
		 * @param obj
		 * 
		 */		
		private function localNcCallSeatListStatus(obj:Object):void{
			this.statusObj = obj;
			this.dispatchEvent(new Event(NCCEvent.STATUS));
		}

		/**
		 * 正常反回结果 
		 */
		public function get resultObj():Object
		{
			return _resultObj;
		}

		/**
		 * @private
		 */
		public function set resultObj(value:Object):void
		{
			_resultObj = value;
		}

		/**
		 * 错误返回结果 
		 */
		public function get statusObj():Object
		{
			return _statusObj;
		}

		/**
		 * @private
		 */
		public function set statusObj(value:Object):void
		{
			_statusObj = value;
		}


	}
}