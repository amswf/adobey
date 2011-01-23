package com.snsoft.physics{
	import flash.events.Event;
	
	public class PhysicsObjectEvent extends Event{
		
		/**
		 * 刷新事件 
		 */		
		public static const REFRESH:String = "physicsObjectRefresh";
		
		public function PhysicsObjectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}