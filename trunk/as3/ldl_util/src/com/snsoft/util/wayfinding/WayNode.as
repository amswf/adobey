package com.snsoft.util.wayfinding {
	import flash.geom.Point;

	/**
	 * 结点
	 * @author Administrator
	 *
	 */
	public class WayNode {

		/**
		 * 父结点坐标
		 */
		private var _parentPoint:Point;

		/**
		 * 结点坐标
		 */
		private var _point:Point;

		/**
		 * 到根的长度(全部结点数)
		 */
		private var _length:int;

		/**
		 * 拐弯数
		 */
		private var _bendNum:int;

		public function WayNode() {

		}

		public function get point():Point {
			return _point;
		}

		public function set point(value:Point):void {
			_point = value;
		}

		public function get parentPoint():Point {
			return _parentPoint;
		}

		public function set parentPoint(value:Point):void {
			_parentPoint = value;
		}

		public function get length():int {
			return _length;
		}

		public function set length(value:int):void {
			_length = value;
		}

		public function get bendNum():int {
			return _bendNum;
		}

		public function set bendNum(value:int):void {
			_bendNum = value;
		}

	}
}
