package com.snsoft.wsfb {

	public class WSfb3 implements IWS {
		public function WSfb3() {
		}

		public function ws(wss:WSStatus):void {
			var ws:MyWebService = new MyWebService(wss);
			ws.loadWSDL();
		}
	}
}
