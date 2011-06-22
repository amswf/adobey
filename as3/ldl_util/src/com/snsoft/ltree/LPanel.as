package com.snsoft.ltree {
	import com.snsoft.util.rlm.rs.RSImages;
	import com.snsoft.util.xmldom.Node;
	import com.snsoft.util.xmldom.NodeList;

	import flash.display.Sprite;

	public class LPanel extends Sprite {

		private var parentNode:Node = null;

		private var lTreeDO:LTreeDO = null;

		public function LPanel(parentNode:Node, lTreeDO:LTreeDO) {
			super();
			this.parentNode = parentNode;
			this.lTreeDO = lTreeDO;
			init();
		}

		private function init():void {
			if (parentNode != null) {
				var list:NodeList = parentNode.getNodeList("node");
				if (list != null) {
					for (var i:int = 0; i < list.length(); i++) {
						var node:Node = list.getNode(i);
						var ln:LNode = new LNode(i, parentNode, lTreeDO);
						ln.y = i * ln.height;
						this.addChild(ln);
					}
				}
			}
		}
	}
}
