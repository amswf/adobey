package com.snsoft.map {
	import com.snsoft.util.HashVector;
	import com.snsoft.util.hitTest.HitTest;

	import flash.geom.Point;

	public class MapPathManager {

		//碰撞检测类对象
		private var hitTest:HitTest = null;

		//碰撞检测两点碰撞的阈值
		private var _hitTestDvaluePoint:Point = new Point(0, 0);

		//碰撞检测分块步进值
		private static const HIT_TEST_STEP_VALUE_POINT:Point = new Point(10, 10);

		private var _currentPoint:Point = null;

		private var pathNodes:HashVector = new HashVector();

		public function MapPathManager(workSizePoint:Point, hitTestDvaluePoint:Point) {
			hitTest = new HitTest(workSizePoint, HIT_TEST_STEP_VALUE_POINT);
			this.hitTestDvaluePoint = hitTestDvaluePoint;
		}

		public function addSection(point:Point, section:MapPathSection):void {
			var name:String = MapUtil.pointName(point);
			var node:MapPathNode = pathNodes.findByName(name) as MapPathNode;
			if (node == null) {
				node = new MapPathNode(point);
				pathNodes.push(node, node.name);
			}
		}

		public function removeSection(point:Point, section:MapPathSection):void {
			var name:String = MapUtil.pointName(point);
			var node:MapPathNode = pathNodes.findByName(name) as MapPathNode;
			if (node != null) {
				node.removeSection(section);
			}
		}

		public function removeNode(point:Point):void {
			var name:String = MapUtil.pointName(point);
			var node:MapPathNode = pathNodes.findByName(name) as MapPathNode;
			if (node != null) {
				pathNodes.removeByName(name);
			}
		}

		public function setHitTest(size:Point):void {
			if (hitTest != null) {
				hitTest = hitTest.createCopy(size, HIT_TEST_STEP_VALUE_POINT);
			}
		}

		public function findHitPoint(point:Point):Point {
			return this.hitTest.findPoint(point, hitTestDvaluePoint);
		}

		public function addPoint(point:Point):void {
			currentPoint = point;
			this.hitTest.addPoint(point);
		}

		public function get hitTestDvaluePoint():Point {
			return _hitTestDvaluePoint;
		}

		public function set hitTestDvaluePoint(value:Point):void {
			_hitTestDvaluePoint = value;
		}

		public function get currentPoint():Point {
			return _currentPoint;
		}

		public function set currentPoint(value:Point):void {
			_currentPoint = value;
		}

	}
}
