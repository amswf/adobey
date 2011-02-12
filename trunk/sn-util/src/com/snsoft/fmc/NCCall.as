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
		private var rspd:Responder = null;
		
		/**
		 * 正常反回结果 
		 */
		private var _resultObj:Object = null;
		
		/**
		 * 错误反回结果 
		 */
		private var _statusObj:Object = null;
		
		/**
		 * 正常反回结果方法
		 */		
		private var result:Function = null;
		
		/**
		 * 错误反回结果方法
		 */		
		private var status:Function = null;
		
		/**
		 * 链接 
		 */		
		private var conn:NetConnection = null;
		
		/**
		 * call 方法 
		 */		
		private var command:String = null;
		
		/**
		 * 参数列表 
		 */		
		private var arg:Array = null;
		
		/**
		 *  
		 * @param conn 链接
		 * @param command call 方法
		 * @param result 为空时以事件处理  NCCEvent.RESULT
		 * @param status 为空时以事件处理  NCCEvent.STATUS
		 * @param arguments 参数
		 * 
		 */			
		public function NCCall(conn:NetConnection,command:String,result:Function,status:Function, ... arguments){
			this.conn = conn;
			if(result != null){
				this.result = result;
			}
			else {
				this.result = localNcCallSeatListResult;
			}
			
			if(status != null){
				this.status = status;
			}
			else {
				this.status = localNcCallSeatListStatus;
			}
			rspd = new Responder(this.result,this.status);
			arg = arguments as Array;
			arg.splice(0,0,rspd);
			arg.splice(0,0,command);
			
		}
		
		public function call():void{
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