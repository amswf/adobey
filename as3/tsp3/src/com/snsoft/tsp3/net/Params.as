package com.snsoft.tsp3.net {

	public class Params {

		private var paramsStr:String = "";

		public function Params() {
		}

		public function addParam(name:String, value:String):void {
			paramsStr += "    <" + name + ">" + "<![CDATA[" + value + "]]>" + "</" + name + ">\r";
		}

		public function toXML():String {
			var xml:String = "<xml>\r" + paramsStr + "</xml>";
			return xml;
		}
	}
}
