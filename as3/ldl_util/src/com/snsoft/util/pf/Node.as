package com.snsoft.util.pf {

	public class Node {

		private var _adjvex:int = 0;

		private var _next:Node;

		public function Node() {
		}

		public function get adjvex():int {
			return _adjvex;
		}

		public function set adjvex(value:int):void {
			_adjvex = value;
		}

		public function get next():Node {
			return _next;
		}

		public function set next(value:Node):void {
			_next = value;
		}

	}
}
