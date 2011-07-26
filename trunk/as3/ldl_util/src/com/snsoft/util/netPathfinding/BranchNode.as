package com.snsoft.util.netPathfinding {

	public class BranchNode {

		private var _branchPaths:Vector.<BranchPath> = new Vector.<BranchPath>();

		public function BranchNode() {
		}

		public function addBranchPath(branchPath:BranchPath):void {
			branchPaths.push(branchPath);
		}

		public function get branchPaths():Vector.<BranchPath> {
			return _branchPaths;
		}

	}
}
