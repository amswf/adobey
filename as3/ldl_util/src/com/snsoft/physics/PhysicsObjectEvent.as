package com.snsoft.physics{
	import flash.events.Event;
	
	/**
	 * 物理运动单元事件
	 * @author Administrator
	 * 
	 */	
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