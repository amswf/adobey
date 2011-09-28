package com.snsoft.wsfb {
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.LoadEvent;
	import mx.rpc.soap.Operation;
	import mx.rpc.soap.WebService;

	public class MyWebService {

		private var ws:WebService;

		private var ope:Operation;

		private var wss:WSStatus;

		public function MyWebService(wss:WSStatus) {
			this.wss = wss;
		}

		public function loadWSDL():void {
			ws = new WebService();
			ws.addEventListener(LoadEvent.LOAD, loadWSDLCMP);
			ws.addEventListener(FaultEvent.FAULT, loadWSDLFault);
			ws.loadWSDL(wss.wsdl);
		}

		public function loadWSDLCMP(e:LoadEvent):void {
			send();
		}

		public function loadWSDLFault(e:FaultEvent):void {
			wss.callBack("wsdlError");
		}

		public function send():void {
			var ope:Operation = ws.getOperation(wss.method) as Operation;
			ope.addEventListener(ResultEvent.RESULT, sendOperationCMP);
			ope.addEventListener(FaultEvent.FAULT, sendOperationFault);
			ope.send.apply(null, wss.params);
		}

		public function sendOperationCMP(e:ResultEvent):void {
			wss.callBack("methodSuccess", e.result);
		}

		public function sendOperationFault(e:FaultEvent):void {
			wss.callBack("methodError");
		}

	}
}
