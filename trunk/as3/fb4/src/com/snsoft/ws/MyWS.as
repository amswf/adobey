package com.snsoft.ws {
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.LoadEvent;
	import mx.rpc.soap.Operation;
	import mx.rpc.soap.WebService;

	public class MyWS {

		private var ws:mx.rpc.soap.WebService;

		private var ope:Operation;

		private var wss:WSStatus;

		private var wscb:IWSCB;

		public function MyWS(wss:WSStatus, wscb:IWSCB) {
			this.wss = wss;
			this.wscb = wscb;
		}

		public function loadWSDL():void {
			ws = new mx.rpc.soap.WebService();
			ws.addEventListener(LoadEvent.LOAD, loadWSDLCMP);
			ws.addEventListener(FaultEvent.FAULT, loadWSDLFault);
			ws.loadWSDL(wss.wsdl);
		}

		public function loadWSDLCMP(e:LoadEvent):void {
			send();
		}

		public function loadWSDLFault(e:FaultEvent):void {
			wscb.callBack("wsdlError");
		}

		public function send():void {
			var ope:Operation = ws.getOperation(wss.method) as Operation;
			ope.addEventListener(ResultEvent.RESULT, sendOperationCMP);
			ope.addEventListener(FaultEvent.FAULT, sendOperationFault);
			ope.send.apply(null, wss.params);
		}

		public function sendOperationCMP(e:ResultEvent):void {
			wscb.callBack("methodSuccess", e.result);
		}

		public function sendOperationFault(e:FaultEvent):void {
			wscb.callBack("methodError");
		}

	}
}
