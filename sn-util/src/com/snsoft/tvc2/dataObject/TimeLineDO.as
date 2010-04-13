package com.snsoft.tvc2.dataObject{
	import com.snsoft.util.HashVector;

	public class TimeLineDO{
		
		private var _name:String;
		
		private var _text:String;
		
		private var _bizDOHv:HashVector;
		
		public function TimeLineDO()
		{
		}

		public function get bizDOHv():HashVector
		{
			return _bizDOHv;
		}

		public function set bizDOHv(value:HashVector):void
		{
			_bizDOHv = value;
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


	}
}