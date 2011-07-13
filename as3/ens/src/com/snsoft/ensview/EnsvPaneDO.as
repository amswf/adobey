package com.snsoft.ensview {

	public class EnsvPaneDO {

		private var _width:int;

		private var _height:int;

		private var _row:int;

		private var _col:int;

		public function EnsvPaneDO() {
		}

		public function get width():int {
			return _width;
		}

		public function set width(value:int):void {
			_width = value;
		}

		public function get height():int {
			return _height;
		}

		public function set height(value:int):void {
			_height = value;
		}

		public function get row():int {
			return _row;
		}

		public function set row(value:int):void {
			_row = value;
		}

		public function get col():int {
			return _col;
		}

		public function set col(value:int):void {
			_col = value;
		}

	}
}
