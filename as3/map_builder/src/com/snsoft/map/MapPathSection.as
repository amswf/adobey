package com.snsoft.map {
	import flash.geom.Point;

	public class MapPathSection {

		private var _from:Point;

		private var _to:Point;

		private var _areaName:String = null;

		public function MapPathSection(from:Point, to:Point) {
			this._from = from;
			this._to = to;
		}

		public function get name():String {
			return MapUtil.twoPointName(from, to);
		}

		public function get dename():String {
			return MapUtil.twoPointName(to, from);
		}

		public function get from():Point {
			return _from;
		}

		public function set from(value:Point):void {
			_from = value;
		}

		public function get to():Point {
			return _to;
		}

		public function set to(value:Point):void {
			_to = value;
		}

		public function get areaName():String
		{
			return _areaName;
		}

		public function set areaName(value:String):void
		{
			_areaName = value;
		}


	}
}
