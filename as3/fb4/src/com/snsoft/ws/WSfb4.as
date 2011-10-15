package com.snsoft.ws {

	public class WSfb4 implements IWS {
		public function WSfb4() {
		}

		public function ws(wss:WSStatus, wscb:IWSCB):void {
			var ws:MyWS = new MyWS(wss, wscb);
			ws.loadWSDL();
		}
	}
}
