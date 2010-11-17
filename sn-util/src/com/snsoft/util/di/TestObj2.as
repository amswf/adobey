package com.snsoft.util.di{
	public class TestObj2{
		
		private var _name:String;
		
		private var _value:Number;
		
		public function TestObj2()
		{
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get value():Number
		{
			return _value;
		}

		public function set value(value:Number):void
		{
			_value = value;
		}


	}
}