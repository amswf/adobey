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

		private var sections:HashVector = new HashVector();

		public function MapPathManager(workSizePoint:Point, hitTestDvaluePoint:Point) {
			hitTest = new HitTest(workSizePoint, HIT_TEST_STEP_VALUE_POINT);
			this.hitTestDvaluePoint = hitTestDvaluePoint;
		}

		/**
		 *
		 * @param p1
		 * @param p2
		 *
		 */
		public function addSection(p1:Point, p2:Point):void {
			var section:MapPathSection = new MapPathSection(p1, p2);
			if (sections.findByName(section.name) == null && sections.findByName(section.dename) == null) {
				sections.push(section, section.name);
			}
		}

		/**
		 *
		 * @param p1
		 * @param p2
		 * @return
		 *
		 */
		public function getSection(p1:Point, p2:Point):MapPathSection {
			var section:MapPathSection = new MapPathSection(p1, p2);
			var sec:MapPathSection = sections.findByName(section.name) as MapPathSection;
			if (sec != null) {
				return sec;
			}
			var dsec:MapPathSection = sections.findByName(section.dename) as MapPathSection;
			if (dsec != null) {
				return dsec;
			}
			return null;
		}

		/**
		 *
		 * @param p1
		 * @param p2
		 *
		 */
		public function removeSection(p1:Point, p2:Point):void {
			var section:MapPathSection = new MapPathSection(p1, p2);
			sections.removeByName(section.name);
			sections.removeByName(section.dename);

			trace(sections.length);
		}

		/**
		 *
		 * @param size
		 *
		 */
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