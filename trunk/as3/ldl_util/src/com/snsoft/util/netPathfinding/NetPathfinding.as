﻿package com.snsoft.util.netPathfinding {
	import com.snsoft.fmc.test.vi.PubNetStream;
	import com.snsoft.util.HashVector;

	import flash.geom.Point;

	//	从一个点开始，获得这个点的关联结点。
	//	
	//	从每个关联结点开始，寻到分杈结点停止。
	//	
	//	判断找到的这组分杈结点是否已走过。
	//	
	//	已走过的分杈结点，判断是否是更短路径，替换。
	//	
	//	未走过的分杈结点，记录到已走过列表。

	public class NetPathfinding {

		private var netNode:NetNode;

		public function NetPathfinding(netNode:NetNode) {
			this.netNode = netNode;
		}

		public function finding(fromNode:NetNode, toNode:NetNode):Vector.<Point> {
			var branchHV:HashVector = new HashVector();
			var paths:Vector.<Path> = new Vector.<Path>();
			find(paths, fromNode, toNode, branchHV);

			var min:int = int.MAX_VALUE;
			var n:int = -1;
			for (var i:int = 0; i < paths.length; i++) {
				var p:Path = paths[i];
				if (p.distance < min) {
					n = i;
				}
			}

			var points:Vector.<Point> = null;
			if (n >= 0) {
				points = paths[n].points;
			}
			return points;
		}

		private function find(paths:Vector.<Path>, forkNode:NetNode, toNode:NetNode, branchHV:HashVector, parentBranch:Branch = null, prevNode:NetNode = null):void {
			trace(forkNode.point, "-----------------------------------------------------");
			var branchs:Vector.<Branch> = findBranchs(forkNode, toNode, branchHV, prevNode);
			for (var i:int = 0; i < branchs.length; i++) {
				var ppb:Branch = branchs[i];
				ppb.parent = parentBranch;
				var ppn:String = getBranchName(ppb.nodes);
				branchHV.push(ppb, ppn);
			}
			for (i = 0; i < branchs.length; i++) {
				var branch:Branch = branchs[i];

				if (!branch.isEnd) {
					branch.parent = parentBranch;
					var nfnode:NetNode = branch.getLastNode();
					var npnode:NetNode = branch.getLastPrevNode();
					find(paths, nfnode, toNode, branchHV, branch, npnode);
				}
				else {
					var path:Path = getPath(branch, toNode);
					trace("path:", path.points.toString());
					paths.push(path);
				}
			}
		}

		private function getPath(branch:Branch, toNode:NetNode):Path {
			var bra:Branch = branch;
			trace(bra.parent);
			var points:Vector.<Point> = new Vector.<Point>();
			var sign:Boolean = false;

			var distance:int = 0;
			while (bra != null) {

				//每一个杈和父杈有重的点，所以父杈不为空时，不添加杈的第一个结点
				var n:int = (bra.parent == null) ? 0 : 1;
				for (var i:int = bra.nodes.length - 1; i >= n; i--) {
					var node:NetNode = bra.nodes[i];
					if (!sign && node.point.equals(toNode.point)) {
						sign = true;
					}
					if (sign) {
						points.push(node.point);
					}
				}
				distance += bra.pathLen;
				bra = bra.parent;
			}

			var path:Path = new Path();
			path.distance = distance;

			for (var j:int = points.length - 1; j >= 0; j--) {
				var p:Point = points[j];
				path.addPoint(p);
			}

			return path;
		}

		/**
		 * 从某个点开始查找整个分支上的点
		 * @param toNode
		 * @param node
		 * @param prevNode
		 * @return
		 *
		 */
		private function findBranchs(forkNode:NetNode, toNode:NetNode, branchHV:HashVector, prevNode:NetNode = null):Vector.<Branch> {
			trace("findBranchs: " + forkNode.point);
			var branchs:Vector.<Branch> = new Vector.<Branch>();
			var nextNodes:Vector.<NetNode> = getNextNodes(forkNode, prevNode);
			for (var i:int = 0; i < nextNodes.length; i++) {
				var nnode:NetNode = nextNodes[i];

				var n:int = 1;
				var len:int = 0;

				var success:Boolean = false;

				var branch:Branch = new Branch();
				branch.addNode(forkNode);

				var pnode:NetNode = forkNode;
				var cnode:NetNode = nnode;

				while (true) {
					//branch.isEnd 加速
					if (!branch.isEnd && toNode.point.equals(cnode.point)) {
						branch.isEnd = true;
					}

					var nodes:Vector.<NetNode> = getNextNodes(cnode, pnode);
					n = nodes.length;

					var bnode:NetNode = null;

					if (n > 0) {
						bnode = nodes[0];
					}
					if (!cnode.point.equals(forkNode.point) && (n >= 1 || (n == 0 && branch.isEnd))) {
						len += Point.distance(pnode.point, cnode.point);
						branch.addNode(cnode);
						pnode = cnode;
						cnode = bnode;
					}
					else {
						break;
					}

					if (n == 0) {
						success = true;
						break;
					}
					else if (n >= 2) {
						success = true;
						break;
					}
				}
				var nname:String = getDeBranchName(branch.nodes);
				if (success && branch.nodes.length > 1 && branchHV.findByName(nname) == null) {
					branch.hashName = getBranchName(branch.nodes);
					branch.pathLen = len;
					branchs.push(branch);
				}

			}

			for (i = 0; i < branchs.length; i++) {
				var b:Branch = branchs[i];
				var str:String = "";
				for (var j:int = 0; j < b.nodes.length; j++) {
					var nd:NetNode = b.nodes[j];
					str += nd.point.toString() + " , ";
				}
				trace(b.hashName);
				trace(str);
			}
			return branchs;
		}

		/**
		 * 去掉父结点的子关联结点列表
		 * @param prevNetNode
		 * @return
		 *
		 */
		public function getOpenNextNodes(node:NetNode, branchHV:HashVector):Vector.<NetNode> {
			//prevNetNode==null 时可加速，直接反回，不做for 处理
			//trace("getNextNodes: ", node.point, branchHV.length);
			var nodes:Vector.<NetNode> = new Vector.<NetNode>();
			for (var i:int = 0; i < node.linkNodes.length; i++) {
				var nnode:NetNode = node.linkNodes[i];
				//trace(nnode.point);
				var name:String = getNodeName(nnode);
				if (branchHV.findByName(name) == null) {
					nodes.push(nnode);
				}
			}
			return nodes;
		}

		public function getNextNodes(node:NetNode, prevNode:NetNode = null):Vector.<NetNode> {
			//prevNetNode==null 时可加速，直接反回，不做for 处理
			//trace("getNextNodes: ", node.point, branchHV.length);
			var nodes:Vector.<NetNode> = new Vector.<NetNode>();
			for (var i:int = 0; i < node.linkNodes.length; i++) {
				var nnode:NetNode = node.linkNodes[i];
				//trace(nnode.point);

				if (!(prevNode != null && nnode.point.equals(prevNode.point))) {
					nodes.push(nnode);
				}
			}
			return nodes;
		}

		private function getNodeName(node:NetNode):String {
			return "" + node.point.x + "," + node.point.y;
		}

		private function getBranchName(nodes:Vector.<NetNode>):String {
			var name:String = null;
			if (nodes.length > 1) {
				var p1:Point = nodes[0].point;
				var p2:Point = nodes[nodes.length - 1].point;
				name = get2PointHashName(p1, p2);
			}
			return name;
		}

		private function getDeBranchName(nodes:Vector.<NetNode>):String {
			var name:String = null;
			if (nodes.length > 1) {
				var p1:Point = nodes[0].point;
				var p2:Point = nodes[nodes.length - 1].point;
				name = get2PointHashName(p2, p1);
			}
			return name;
		}

		private function get2PointHashName(p1:Point, p2:Point):String {
			return "" + p1.x + "," + p1.y + "-" + p2.x + "," + p2.y;
		}
	}
}