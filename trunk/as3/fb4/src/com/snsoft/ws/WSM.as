package com.snsoft.ws {

	public class WSM {
		private static var lock:Boolean = false;

		private static var wsm:WSM = new WSM();

		private var _wsfb4:IWS;

		private var _cbfl5:ICB;

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

		public function sendOpertion(wss:WSStatus, wscb:IWSCB):void {
			wsfb4.ws(wss, wscb);
		}

		public function get wsfb4():IWS {
			return _wsfb4;
		}

		public function set wsfb4(value:IWS):void {
			_wsfb4 = value;
		}

		public function get cbfl5():ICB {
			return _cbfl5;
		}

		public function set cbfl5(value:ICB):void {
			_cbfl5 = value;
		}

	}
}
