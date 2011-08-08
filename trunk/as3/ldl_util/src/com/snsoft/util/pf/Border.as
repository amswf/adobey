package com.snsoft.util.pf {

	public class Border {

		private var _i:int;

		private var _j:int;

		private var _value:int;

		public function Border(i:int, j:int, value:int) {
			this.i = i;
			this.j = j;
		}

		public function get i():int {
			return _i;
		}

		public function set i(value:int):void {
			_i = value;
		}

		public function get j():int {
			return _j;
		}

		public function set j(value:int):void {
			_j = value;
		}

		public function get value():int {
			return _value;
		}

		public function set value(value:int):void {
			_value = value;
		}

	}
}
