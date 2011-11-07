package com.snsoft.tsp3.net {
	import flash.events.Event;

	public class DataLoaderEvent extends Event {

		public static const TIME_OUT:String = "timeOut";

		public function DataLoaderEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
