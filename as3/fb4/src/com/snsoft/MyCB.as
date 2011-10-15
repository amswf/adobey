package com.snsoft {
	import com.snsoft.ws.ICB;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	[Event(name = "complete", type = "flash.events.Event")]
	public class MyCB extends EventDispatcher implements ICB {
		public function MyCB() {
		}

		public function wsfb4InitCmp():void {
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}
