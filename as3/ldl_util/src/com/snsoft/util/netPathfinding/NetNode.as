package com.snsoft.util.netPathfinding {
	import flash.geom.Point;

	/**
	 * 网结构结点
	 * @author Administrator
	 *
	 */
	public class NetNode {

		/**
		 * 当前结点坐标
		 */
		private var _point:Point = new Point();

		/**
		 * 关联结点坐标
		 */
		private var _linkNodes:Vector.<NetNode> = new Vector.<NetNode>();

		public function NetNode(x:Number = 0, y:Number = 0) {
			this.point.x = x;
			this.point.y = y;
		}

		/**
		 * 去掉父结点的子关联结点列表
		 * @param prevNetNode
		 * @return
		 *
		 */
		public function getNextNodes(prevNetNode:NetNode = null):Vector.<NetNode> {
			//prevNetNode==null 时可加速，直接反回，不做for 处理

			var nodes:Vector.<NetNode> = new Vector.<NetNode>();
			for (var i:int = 0; i < linkNodes.length; i++) {
				var node:NetNode = linkNodes[i];
				if (prevNetNode == null || !node.point.equals(prevNetNode.point)) {
					nodes.push(node);
				}
			}
			return nodes;
		}

		/**
		 * 添加关联结点
		 * @param netNode
		 *
		 */
		public function addLinkNode(netNode:NetNode):void {
			linkNodes.push(netNode);
			netNode.linkNodes.push(this);
		}

		public function get point():Point {
			return _point;
		}

		public function set point(value:Point):void {
			_point = value;
		}

		public function get linkNodes():Vector.<NetNode> {
			return _linkNodes;
		}
	}
}
