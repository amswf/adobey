package com.snsoft.ltree {
	import com.snsoft.util.rlm.rs.RSImages;
	import com.snsoft.util.xmldom.Node;
	import com.snsoft.util.xmldom.NodeList;

	import flash.display.Sprite;

	public class LNode extends Sprite {

		private var nodeIndex:int = 0;

		private var parentNode:Node = null;

		private var lTreeDO:LTreeDO = null;

		public function LNode(nodeIndex:int, parentNode:Node, lTreeDO:LTreeDO) {
			super();
			this.nodeIndex = nodeIndex;
			this.parentNode = parentNode;
			this.lTreeDO = lTreeDO;
			init();
		}

		private function init():void {
			if (parentNode != null) {
				var list:NodeList = parentNode.getNodeList("node");
				if (list != null && nodeIndex < list.length()) {
					var node:Node = list.getNode(nodeIndex);
					var text:LText = new LText(node, lTreeDO);
					this.addChild(text);

					var lp:LPanel = new LPanel(node, lTreeDO);
					this.addChild(lp);
					lp.x = 20;
					lp.y = text.height;
				}
			}
		}

		private function getMinusOrPlusImageUrl(nodeIndex:int, parentNode:Node):String {
			var url:String = null;
			var list:NodeList = parentNode.getNodeList("node");
			if (list != null && nodeIndex < list.length()) {
				var node:Node = list.getNode(nodeIndex);
				var open:Boolean = Boolean(node.getAttributeByName("open"));
				if (open) {
					if (list.length() == 1) {

					}
				}
			}
			return url;
		}

	}
}
