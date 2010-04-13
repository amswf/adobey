package com.snsoft.tvc2.dataObject{
	public class TextPointDO{
		
		private var _name:String;
		
		private var _text:String;
		
		private var _value:String;
		
		public function TextPointDO()
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

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text = value;
		}

		public function get value():String
		{
			return _value;
		}

		public function set value(value:String):void
		{
			_value = value;
		}


	}
}