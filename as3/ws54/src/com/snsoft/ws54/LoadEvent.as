package com.snsoft.ws54 {
	import flash.events.Event;

	public class LoadEvent extends Event {

		public static const LOAD:String = "load";

		public function LoadEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
