package com.snsoft.map {
	import flash.geom.Point;

	/**
	 * 网结构路径结点
	 * @author Administrator
	 *
	 */
	public class MapPathNode {

		/**
		 * 当前结点坐标
		 */
		private var _point:Point = new Point();

		/**
		 * 关联结点坐标
		 */
		private var _linkNodes:Vector.<MapPathNode> = new Vector.<MapPathNode>();

		public function MapPathNode(x:Number = 0, y:Number = 0) {
			this.point.x = x;
			this.point.y = y;
		}

		/**
		 * 添加关联结点
		 * @param netNode
		 *
		 */
		public function addLinkNode(netNode:MapPathNode):void {
			linkNodes.push(netNode);
			var sign = true;
			for (var i:int = 0; i < linkNodes.length; i++) {
				var node:MapPathNode = linkNodes[i];
				if (node.point.equals(netNode.point)) {
					sign = false;
					break;
				}
			}
			if (sign) {
				netNode.linkNodes.push(this);
			}
		}

		/**
		 * 删除关联结点
		 * @param netNode
		 *
		 */
		public function delLinkNode(netNode:MapPathNode):void {
			for (var i:int = 0; i < linkNodes.length; i++) {
				var node:MapPathNode = linkNodes[i];
				if (node == netNode) {
					linkNodes.splice(i, 1);
					break;
				}
			}
		}

		public function get point():Point {
			return _point;
		}

		public function set point(value:Point):void {
			_point = value;
		}

		public function get linkNodes():Vector.<MapPathNode> {
			return _linkNodes;
		}
	}
}
