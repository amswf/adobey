package com.snsoft.tsp3.net {

	public class Params {

		private var paramsStr:String = "";

		public function Params() {
		}

		public function addParam(name:String, value:String):void {
			if (value != null) {
				paramsStr += "        <param" + " name=\"" + name + "\"><![CDATA[" + value + "]]></param>\r";
			}
		}

		public function toXML():String {
			var xml:String = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\r";
			xml += "<request>\r    <params>\r" + paramsStr + "    </params>\r</request>";
			return xml;
		}
	}
}
