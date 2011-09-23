package com.snsoft {
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;

	public class ServiceLoader extends URLLoader {
		private var _hostName:String;
		private var _namespace:String;
		private var _serviceName:String;
		private var _parameters:Array;

		public function ServiceLoader(hostName:String, nameSpace:String, serviceName:String, parameters:Array) {
			_hostName = hostName;
			_namespace = nameSpace;
			_serviceName = serviceName;
			_parameters = parameters;
			var serviceRequest:URLRequest = generateURLRequest();

			this.dataFormat = URLLoaderDataFormat.TEXT;
			this.load(serviceRequest);
			//this.addEventListener("ioError" ,err);
			//this.addEventListener(Event.COMPLETE,xmlLoaded);
		}

		private function generateURLRequest():URLRequest {
			var soap:Namespace = new Namespace("http://schemas.xmlsoap.org/soap/envelope/");
			var serviceRequest:URLRequest = new URLRequest(_hostName);
			serviceRequest.method = URLRequestMethod.POST;
			serviceRequest.requestHeaders.push(new URLRequestHeader("Content-Type", "text/xml;charset=utf-8"));
			serviceRequest.requestHeaders.push(new URLRequestHeader("SOAPAction", _namespace + "/" + _serviceName));
			var rXML:XML =
				<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:tns="http://logic.backend.imageservice.inshow.com" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body/></soap:Envelope>;

			//var conditionStr:String = "<"+_serviceName+" xmlns=\"http://tempuri.org/\">";
			var conditionStr:String = "<" + _serviceName + " xmlns=\"" + _namespace + "\">";

			for (var i:Number = 0; i < _parameters.length; i++) {
				conditionStr += "<" + _parameters[i][0] + ">" + _parameters[i][1] + "</" + _parameters[i][0] + ">";
			}

			conditionStr += "</" + _serviceName + ">";

			var conditionXML:XML = new XML(conditionStr);
			rXML.soap::Body.appendChild(conditionXML);
			trace(rXML)
			serviceRequest.data = rXML;
			return serviceRequest;
		}

		public function xmlLoaded(e:Event):void {
			//trace("--------------------")
			//trace(e.eventInfo.method)
			//trace(e.eventInfo.data)
			//trace("--------------------")
			var listXML:XML = XML(this.data);
			trace(">>>>");
		}

		public function err(e:Event):void {
			trace(">>>>");
		}

	}
}
