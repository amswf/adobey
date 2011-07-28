package com.snsoft.util.netPathfinding {

	public class Branch {

		private var _hashName:String;

		private var _pathLen:int;

		private var _nodes:Vector.<NetNode> = new Vector.<NetNode>();

		private var _isEnd:Boolean;

		private var _parent:Branch;

		public function Branch() {
		}

		public function addNode(node:NetNode):void {
			nodes.push(node);
		}

		public function getLastPrevNode():NetNode {
			if (nodes.length - 2 >= 0) {
				return nodes[nodes.length - 2];
			}
			return null;
		}

		public function getFirstNode():NetNode {
			return nodes[0];
		}

		public function getLastNode():NetNode {
			if (nodes.length - 1 >= 0) {
				return nodes[nodes.length - 1];
			}
			return null;
		}

		public function get pathLen():int {
			return _pathLen;
		}

		public function set pathLen(value:int):void {
			_pathLen = value;
		}

		public function get nodes():Vector.<NetNode> {
			return _nodes;
		}

		public function set nodes(value:Vector.<NetNode>):void {
			_nodes = value;
		}

		public function get hashName():String {
			return _hashName;
		}

		public function set hashName(value:String):void {
			_hashName = value;
		}

		public function get isEnd():Boolean {
			return _isEnd;
		}

		public function set isEnd(value:Boolean):void {
			_isEnd = value;
		}

		public function get parent():Branch {
			return _parent;
		}

		public function set parent(value:Branch):void {
			_parent = value;
		}

	}
}
