package com.snsoft.util.ws {
	import com.snsoft.util.UUID;

	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import flash.net.URLRequest;

	[Event(name = "webServiceError", type = "com.snsoft.util.ws.WebServiceEvent")]
	[Event(name = "methodSuccess", type = "com.snsoft.util.ws.WebServiceEvent")]
	[Event(name = "wsas2Complete", type = "com.snsoft.util.ws.WebServiceEvent")]
	[Event(name = "wsas2Error", type = "com.snsoft.util.ws.WebServiceEvent")]

	public class WebService extends EventDispatcher {

		private static const STATIC_AS3_SERVER_NAME:String = "static_as3_2011_conn_server";

		public static const AS2_SERVER_NAME:String = "as2_2011_conn_server";

		public static const AS2_WS_FUN:String = "as2ws";

		private var as3ServerName:String;

		private var as3Server:LocalConnection;

		private var caller:LocalConnection;

		private var wsdlUrl:String;

		private static var initCmp:Boolean = false;

		private static var staticAs3Server:LocalConnection

		public function WebService(wsdlUrl:String, as2swfUrl:String = "ws.as2.swf") {
			this.wsdlUrl = wsdlUrl;
			as3ServerName = UUID.create();
			if (!initCmp) {
				staticAs3Server = new LocalConnection();
				staticAs3Server.connect(STATIC_AS3_SERVER_NAME);
				staticAs3Server.client = new ConnClient(initCompleteCallBack);

				var loader:Loader = new Loader();
				loader.load(new URLRequest(as2swfUrl));
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadWsAs2SwfError);
			}
			else {
				initCompleteCallBack();
			}
		}

		private function loadWsAs2SwfError(e:Event):void {
			trace("load ws.as2.swf error");
			var we:WebServiceEvent = new WebServiceEvent(WebServiceEvent.WSAS2_COMPLETE, WebServiceStatus.ERROR_STATUS_LOAD);
			dispatchEvent(we);
		}

		public function initCompleteCallBack():void {
			initCmp = true;
			init();
			var we:WebServiceEvent = new WebServiceEvent(WebServiceEvent.WSAS2_COMPLETE);
			dispatchEvent(we);
		}

		public function init():void {
			as3Server = new LocalConnection();
			as3Server.client = this;
			try {
				as3Server.connect(as3ServerName);
			}
			catch (error:ArgumentError) {
				trace("Can't connect...the connection name is already being used by another SWF");
				var we:WebServiceEvent = new WebServiceEvent(WebServiceEvent.WEBSERVICE_ERROR, WebServiceStatus.ERROR_STATUS_CONN);
				dispatchEvent(we);
			}

			caller = new LocalConnection();
			caller.addEventListener(StatusEvent.STATUS, handlerStatus);
		}

		public function callMethod(methodName:String, ... param):void {
			if (initCmp) {
				var argAry:Array = new Array();
				argAry.push(wsdlUrl, methodName);
				for (var i:int = 0; i < param.length; i++) {
					argAry.push(param[i]);
				}
				callWS.apply(null, argAry);
			}
		}

		private function callWS(wsdlUrl:String, method:String, ... param):void {
			caller.send(AS2_SERVER_NAME, AS2_WS_FUN, as3ServerName, wsdlUrl, method, param);
		}

		public function callBack(data:Object, status:String):void {
			var wsData:Object = null;
			var type:String = null;
			if (status == WebServiceStatus.SUCCESS_STATUS_METHOD) {
				type = WebServiceEvent.METHOD_SUCCESS;
				wsData = data;
			}
			else if (status == WebServiceStatus.ERROR_STATUS_WSDL) {
				type = WebServiceEvent.WEBSERVICE_ERROR;
			}
			else if (status == WebServiceStatus.ERROR_STATUS_METHOD) {
				type = WebServiceEvent.WEBSERVICE_ERROR;
			}

			if (type != null) {
				var we:WebServiceEvent = new WebServiceEvent(type, status, wsData);
				dispatchEvent(we);
			}
		}

		private function handlerStatus(e:StatusEvent):void {
			switch (e.level) {
				case "status":
					break;
				case "error":
					var we:WebServiceEvent = new WebServiceEvent(WebServiceEvent.WEBSERVICE_ERROR, WebServiceStatus.ERROR_STATUS_SEND);
					dispatchEvent(we);
					break;
			}
		}

		public function close():void {
			try {
				as3Server.close();
			}
			catch (e:Error) {

			}
		}
	}
}
