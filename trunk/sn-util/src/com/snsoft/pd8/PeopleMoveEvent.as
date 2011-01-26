package com.snsoft.pd8{
	import flash.events.Event;

	/**
	 * 人物八方走动事件 
	 * @author Administrator
	 * 
	 */	
	public class PeopleMoveEvent extends Event{
		
		private var _code:int = -1;
		
		public static const PEOPLE_MOVE:String = "people_move";
		
		/**
		 * 
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 * 
		 */		
		public function PeopleMoveEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		public function get code():int
		{
			return _code;
		}

		public function set code(value:int):void
		{
			_code = value;
		}

	}
}