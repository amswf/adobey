package com.snsoft.tsp3.touch {
	import flash.events.Event;

	public class TouchDragEvent extends Event {

		public static const TOUCH_DRAG_MOUSE_UP:String = "touchDragMouseUp";

		public static const TOUCH_CLICK:String = "touchClick";

		public function TouchDragEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
