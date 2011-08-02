package com.snsoft.util.netPathfinding {
	import flash.geom.Point;

	public class Path {

		private var _points:Vector.<Point> = new Vector.<Point>();

		private var _distance:int = 0;

		public function Path() {
		}

		public function addPoint(point:Point):void {
			points.push(point);
		}

		public function get distance():int {
			return _distance;
		}

		public function set distance(value:int):void {
			_distance = value;
		}

		public function get points():Vector.<Point> {
			return _points;
		}

		public function set points(value:Vector.<Point>):void {
			_points = value;
		}

	}
}
