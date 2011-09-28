package com.snsoft.wsfb {

	public class WSM {
		private static var lock:Boolean = false;

		private static var wsm:WSM = new WSM();

		private var _wsfb3:IWS;

		public function WSM() {
			if (lock) {
				throw(new Error("WSM Can not new "));
			}
			else {
				lock = true;
			}
		}

		public static function instance():WSM {
			return wsm;
		}

		public function sendOpertion(wss:WSStatus):void {
			wsfb3.ws(wss);
		}

		public function get wsfb3():IWS
		{
			return _wsfb3;
		}

		public function set wsfb3(value:IWS):void
		{
			_wsfb3 = value;
		}

	}
}
