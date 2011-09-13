package com.snsoft.util.rlm.loader{
	import flash.events.Event;

	/**
	 * 资源加载事件 
	 * @author Administrator
	 * 
	 */	
	public class LdLoaderEvent extends Event{
		
		/**
		 * 获得了总字节数 
		 */		
		public static const IS_RECEIVE_BYTES_TOTAL:String = "isReceiveBytesTotal";
		
		public function LdLoaderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}