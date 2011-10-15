package com.snsoft.ws54 {
	import flash.events.Event;

	public class FaultEvent extends Event {

		public static const FAULT:String = "fault";

		public function FaultEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
