package com.snsoft.util.netPathfinding {
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

		public function finding(fromNode:NetNode, toNode:NetNode):void {
			var branchHV:HashVector = new HashVector();
			var forkNodes:HashVector = new HashVector();
			var paths:Vector.<BranchPath> = new Vector.<BranchPath>();
			var pathsv:Vector.<Vector.<BranchPath>> = new Vector.<Vector.<BranchPath>>();

			find(pathsv, branchHV, paths, forkNodes, toNode, fromNode, null);
			//trace(branchHV.length);

			for (var i:int = 0; i < branchHV.length; i++) {
				var bp:BranchPath = branchHV.findByIndex(i) as BranchPath;
				trace(bp.hashName);
				for (var j:int = 0; j < bp.nodes.length; j++) {
					var node:NetNode = bp.nodes[j];
					trace(node.point);
				}
			}

			outPathsv(pathsv);
		}

		private function outPathsv(pathsv:Vector.<Vector.<BranchPath>>):void {
			trace("outPathsv");
			for (var i:int = 0; i < pathsv.length; i++) {
				trace("pathsv.length-------------------------------------------------");
				var paths:Vector.<BranchPath> = pathsv[i];
				for (var j:int = 0; j < paths.length; j++) {
					var bp:BranchPath = paths[j];
					trace(bp.hashName);
					for (var k:int = 0; k < bp.nodes.length; k++) {
						var node:NetNode = bp.nodes[k];
						trace(node.point);
					}
				}

			}

		}

		private function find(pathsv:Vector.<Vector.<BranchPath>>, branchHV:HashVector, paths:Vector.<BranchPath>, forkNodes:HashVector, toNode:NetNode, currentNode:NetNode, prevNode:NetNode = null):void {

			var nextNodes:Vector.<NetNode> = currentNode.getNextNodes(prevNode);
			for (var i:int = 0; i < nextNodes.length; i++) {
				var nnode:NetNode = nextNodes[i];
				//trace("nnode:" + nnode.point);
				var bp:BranchPath = findBranch(toNode, nnode, currentNode);
				var obp:BranchPath = branchHV.findByName(bp.hashName) as BranchPath;
				//trace(bp.hashName);
				if (obp == null || obp.pathLen > bp.pathLen) {
					var ncnode:NetNode = bp.getLastNode();
					var npnode:NetNode = bp.getLastPrevNode();
					var nfnode:NetNode = bp.getFirstNode();
					//trace("ncnode:" + ncnode.point);

					var sign:Boolean = true;
					var forkNode:NetNode = forkNodes.findByName(getNodeName(ncnode)) as NetNode;
					if (forkNode != null) {
						var name:String = get2PointHashName(ncnode.point, nfnode.point);
						if (branchHV.findByName(name) != null) {
							sign = false;
						}
					}

					if (sign) {
						forkNodes.push(ncnode, getNodeName(ncnode));
						branchHV.push(bp, bp.hashName);
						var npaths:Vector.<BranchPath> = clonePaths(paths);
						npaths.push(bp);
						if (!bp.isEnd) {
							find(pathsv, branchHV, npaths, forkNodes, toNode, ncnode, npnode);
						}
						else {
							pathsv.push(npaths);
						}
					}
				}
			}
		}

		private function clonePaths(paths:Vector.<BranchPath>):Vector.<BranchPath> {
			var v:Vector.<BranchPath> = new Vector.<BranchPath>();
			for (var i:int = 0; i < paths.length; i++) {
				v.push(paths[i]);
			}
			return v;
		}

		private function findBranch(toNode:NetNode, node:NetNode, prevNode:NetNode):BranchPath {
			var n:int = 1;
			var len:int = 0;

			var pnode:NetNode = prevNode;
			var cnode:NetNode = node;

			var branchNodes:Vector.<NetNode> = new Vector.<NetNode>();
			branchNodes.push(prevNode);
			branchNodes.push(node);
			len += Point.distance(prevNode.point, node.point);

			var branchPath:BranchPath = new BranchPath();
			while (n == 1) {
				if (cnode.point.equals(toNode.point)) {
					branchPath.isEnd = true;
				}
				var nextNodes:Vector.<NetNode> = cnode.getNextNodes(pnode);
				n = nextNodes.length;
				if (n == 1) {
					var nnode:NetNode =  nextNodes[0];
					len += Point.distance(cnode.point, nnode.point);
					pnode = cnode;
					cnode = nnode;
					branchNodes.push(nnode);
				}
			}
			branchPath.nodes = branchNodes;
			branchPath.pathLen = len;
			branchPath.hashName = getBranchName(branchNodes);
			return branchPath;
		}

		private function getNodeName(node:NetNode):String {
			return node.point.x + "," + node.point.y;
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

		private function get2PointHashName(p1:Point, p2:Point):String {
			return "" + p1.x + "," + p1.y + "-" + p2.x + "," + p2.y;
		}
	}
}
