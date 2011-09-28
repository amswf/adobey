package com.snsoft.tsp3 {

	public class Test {

		private var _i:int = 0;

		private static var t:Test = new Test();

		public function Test() {

		}

		public static function instance():Test {
			return t;
		}

		public function get i():int {
			return _i;
		}

		public function set i(value:int):void {
			_i = value;
		}

	}
}
