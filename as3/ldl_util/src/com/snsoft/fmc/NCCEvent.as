package com.snsoft.fmc{
	import flash.events.Event;
	
	/**
	 * NetConnectionCall 事件 
	 * @author Administrator
	 * 
	 */	
	public class NCCEvent extends Event{
		
		/**
		 * call 成功事件 
		 */		
		public static const RESULT:String = "result";
		
		
		/**
		 * call 失败事件 
		 */		
		public static const STATUS:String = "status";
		
		/**
		 * NetConnectionCall 事件 
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 * 
		 */		
		public function NCCEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}