package com.snsoft.util.wayfinding {
	import flash.geom.Point;

	/**
	 * 树排序
	 * @author Administrator
	 *
	 */
	public class Way {

		/**
		 * 树里面所有结点列表
		 */
		private var nodevv:Vector.<Vector.<WayNode>> = new Vector.<Vector.<WayNode>>();

		/**
		 * 初始化
		 * @param ivv
		 *
		 */
		public function Way(ivv:Vector.<Vector.<Boolean>>) {
			//初始化结点列表
			for (var i:int = 0; i < ivv.length; i++) {
				var ivlen:int = ivv[i].length;
				var nv:Vector.<WayNode> = new Vector.<WayNode>(ivlen);
				nodevv.push(nv);
			}
		}

		/**
		 * 树增加结点
		 * @param current
		 * @param parent
		 *
		 */
		public function push(current:Point, parent:Point = null):void {

			var sign:Boolean = true;

			var cwn:WayNode = nodevv[current.y][current.x];
			if (cwn != null) {
				sign = false;
				var pwn:WayNode = nodevv[current.y][current.x];
				if (pwn != null && pwn.length < cwn.length) {
					sign = true;
				}
				else if (pwn != null && pwn.length == cwn.length) {
					if (pwn.bendNum < cwn.bendNum) {
						sign = true;
					}
				}
			}

			if (sign) {

				var l:int = 1;
				var pWayNode:WayNode = null;
				if (parent != null) {
					pWayNode = nodevv[parent.y][parent.x];
					if (pWayNode != null) {
						l = pWayNode.bendNum;
					}
				}

				var wayNode:WayNode = new WayNode();
				var parentName:String = null;
				wayNode.parentPoint = parent;
				wayNode.point = current;
				wayNode.length = l;

				var bendNum:int = 0;
				if (wayNode.length >= 3) {
					var cpv:Vector.<Point> = new Vector.<Point>();
					cpv.push(wayNode.point);
					var pp:Point = wayNode.parentPoint;
					if (pp != null) {
						cpv.push(wayNode.parentPoint);
						var ppwn:WayNode = nodevv[pp.y][pp.x];
						if (ppwn.parentPoint != null) {
							cpv.push(ppwn.parentPoint);
							var cpcn:int = WayUtil.findBendNum(cpv);
							if (cpcn > 0) {
								bendNum = cpcn;
							}
						}
					}
				}
				wayNode.bendNum = bendNum;

				nodevv[current.y][current.x] = wayNode;
			}
		}

		/**
		 * 获得某个页点到根结点的路径
		 * @param p
		 * @return
		 *
		 */
		public function getSort(p:Point):Vector.<Point> {
			var pv:Vector.<Point> = new Vector.<Point>();
			var np:Point = p.clone();

			//从叶结点搜索父结点，根结点结束
			for (; np != null; ) {
				var node:WayNode = nodevv[np.y][np.x];
				if (node != null) {
					pv.push(node.point);
					np = node.parentPoint;
				}
				else {
					np = null;
				}
			}
			var len:int = pv.length;
			var npv:Vector.<Point> = new Vector.<Point>(len);

			//pv是倒序的，反序一下，根结点下标为0
			if (len > 0) {
				for (var i:int = 0; i < len; i++) {
					npv[len - 1 - i] = pv[i];
				}
			}
			return npv;
		}
	}
}
