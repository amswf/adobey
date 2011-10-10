package com.snsoft.tsp3.net {

	public class Params {

		private var paramsStr:String = "";

		public function Params() {
		}

		public function addParam(name:String, value:String):void {
			paramsStr += "    <filed" + " name=\"" + name + "\" value=\"" + value + "\" />\r";
		}

		public function toXML():String {
			var xml:String = "<fileds>\r" + paramsStr + "</fileds>";
			return xml;
		}
	}
}
