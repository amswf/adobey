package com.snsoft.ws {

	public class WSStatus {

		private var _wsdl:String;

		private var _method:String;

		private var _params:Array;

		public function WSStatus() {

		}

		public function get wsdl():String {
			return _wsdl;
		}

		public function set wsdl(value:String):void {
			_wsdl = value;
		}

		public function get method():String {
			return _method;
		}

		public function set method(value:String):void {
			_method = value;
		}

		public function get params():Array {
			return _params;
		}

		public function set params(value:Array):void {
			_params = value;
		}

	}
}
