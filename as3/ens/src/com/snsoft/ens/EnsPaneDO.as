package com.snsoft.ens {

	public class EnsPaneDO {

		private var _width:int;

		private var _height:int;

		private var _selected:Boolean = true;

		private var _text:String;

		private var _name:String;

		private var _value:String;

		private var _row:int;

		private var _col:int;

		public function EnsPaneDO() {
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

		public function get selected():Boolean {
			return _selected;
		}

		public function set selected(value:Boolean):void {
			_selected = value;
		}

		public function get text():String {
			return _text;
		}

		public function set text(value:String):void {
			_text = value;
		}

		public function get name():String {
			return _name;
		}

		public function set name(value:String):void {
			_name = value;
		}

		public function get value():String {
			return _value;
		}

		public function set value(value:String):void {
			_value = value;
		}

		public function get row():int
		{
			return _row;
		}

		public function set row(value:int):void
		{
			_row = value;
		}

		public function get col():int
		{
			return _col;
		}

		public function set col(value:int):void
		{
			_col = value;
		}


	}
}
