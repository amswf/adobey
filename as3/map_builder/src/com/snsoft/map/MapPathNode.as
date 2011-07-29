package com.snsoft.map {
	import com.snsoft.util.HashVector;

	import flash.geom.Point;

	public class MapPathNode {

		private var _point:Point;

		private var sections:HashVector = new HashVector();

		public function MapPathNode(point:Point) {
			this.point = point;
		}

		public function get name():String {
			return MapUtil.pointName(point);
		}

		public function addSection(mapPathSection:MapPathSection):void {
			sections.push(mapPathSection, mapPathSection.name);
		}

		public function removeSection(mapPathSection:MapPathSection):void {
			sections.removeByName(mapPathSection.name);
		}

		public function get point():Point {
			return _point;
		}

		public function set point(value:Point):void {
			_point = value;
		}

	}
}
