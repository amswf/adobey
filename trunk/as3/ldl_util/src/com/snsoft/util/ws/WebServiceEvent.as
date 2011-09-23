package com.snsoft.util.ws {
	import flash.events.Event;

	public class WebServiceEvent extends Event {

		public static const WEBSERVICE_ERROR:String = "webServiceError";

		public static const METHOD_SUCCESS:String = "methodSuccess";

		public static const WSAS2_COMPLETE:String = "wsas2Complete";

		public static const WSAS2_ERROR:String = "wsas2Error";

		private var _status:String;

		private var _data:Object;

		public function WebServiceEvent(type:String, status:String = null, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			this._status = status;
			this._data = data;
		}

		public function get status():String {
			return _status;
		}

		public function get data():Object {
			return _data;
		}

	}
}
