package com.snsoft.ws54 {
	import flash.events.Event;

	public class ResultEvent extends Event {

		public static const RESULT:String = "result";

		private var _data:*;

		public function ResultEvent(type:String, data:*, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			this._data = data;
		}

		public function get data():* {
			return _data;
		}
	}
}
