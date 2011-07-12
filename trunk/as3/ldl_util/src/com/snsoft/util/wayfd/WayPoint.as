package com.snsoft.util.wayfd {
	import flash.geom.Point;

	public class WayPoint {

		private var _lock:Boolean;

		private var _prev:WayPoint;

		private var _left:WayPoint;

		private var _right:WayPoint;

		private var _top:WayPoint;

		private var _bottom:WayPoint;

		private var _point:Point;

		private var _length:int;

		public function WayPoint(point:Point, prev:WayPoint = null) {
			this.point = point;
			this.prev = prev;
		}

		public function get lock():Boolean {
			return _lock;
		}

		public function set lock(value:Boolean):void {
			_lock = value;
		}

		public function get prev():WayPoint {
			return _prev;
		}

		public function set prev(value:WayPoint):void {
			_prev = value;
		}

		public function get left():WayPoint {
			return _left;
		}

		public function set left(value:WayPoint):void {
			_left = value;
		}

		public function get right():WayPoint {
			return _right;
		}

		public function set right(value:WayPoint):void {
			_right = value;
		}

		public function get top():WayPoint {
			return _top;
		}

		public function set top(value:WayPoint):void {
			_top = value;
		}

		public function get bottom():WayPoint {
			return _bottom;
		}

		public function set bottom(value:WayPoint):void {
			_bottom = value;
		}

		public function get point():Point {
			return _point;
		}

		public function set point(value:Point):void {
			_point = value;
		}

		public function get length():int {
			return _length;
		}

		public function set length(value:int):void {
			_length = value;
		}

	}
}
