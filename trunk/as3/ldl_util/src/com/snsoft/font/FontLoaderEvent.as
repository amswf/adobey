package com.snsoft.font{
	import flash.events.Event;
	
	public class FontLoaderEvent extends Event{
		
		/**
		 * 获得了总字节数 
		 */		
		public static const IS_RECEIVE_BYTES_TOTAL:String = "isReceiveBytesTotal";
		
		public function FontLoaderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}