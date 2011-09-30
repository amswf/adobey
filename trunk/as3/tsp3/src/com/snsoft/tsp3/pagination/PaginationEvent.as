package com.snsoft.tsp3.pagination {
	import flash.events.Event;

	public class PaginationEvent extends Event {

		public static const PAGIN_CLICK:String = "paginClick";

		public function PaginationEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
