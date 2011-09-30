package com.snsoft.tsp3 {
	import com.snsoft.util.xmldom.Node;
	import com.snsoft.util.xmldom.XMLDom;

	public class XMLData {

		private var _code:String;

		private var _isCmp:Boolean;

		private var _message:String;

		private var _bodyNode:Node;

		public function XMLData(xml:*) {
			var x:XML = new XML(xml);
			var xd:XMLDom = new XMLDom(x);
			var xmlNode:Node = xd.parse();
			var headNode:Node = xmlNode.getNodeListFirstNode("head");
			headNode.childNodeTextTObj(this);
			if (code == "200") {
				isCmp = true;
			}
			bodyNode = xmlNode.getNodeListFirstNode("body");
		}

		public function get code():String {
			return _code;
		}

		public function set code(value:String):void {
			_code = value;
		}

		public function get isCmp():Boolean {
			return _isCmp;
		}

		public function set isCmp(value:Boolean):void {
			_isCmp = value;
		}

		public function get message():String {
			return _message;
		}

		public function set message(value:String):void {
			_message = value;
		}

		public function get bodyNode():Node {
			return _bodyNode;
		}

		public function set bodyNode(value:Node):void {
			_bodyNode = value;
		}

	}
}
