package com.snsoft.map {
	import flash.geom.Point;

	public class MapUtil {
		public function MapUtil() {
		}

		public static function twoPointName(from:Point, to:Point):String {
			return "" + from.x + "," + from.y + "," + to.x + "," + to.y;
		}

		public static function pointName(p:Point):String {
			return "" + p.x + "," + p.y;
		}
	}
}
