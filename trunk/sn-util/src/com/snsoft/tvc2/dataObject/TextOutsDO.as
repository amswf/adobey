package com.snsoft.tvc2.dataObject{
	import com.snsoft.util.HashVector;

	public class TextOutsDO{
		
		private var _textOutDOHv:HashVector;
		
		public function TextOutsDO()
		{
		}

		public function get textOutDOHv():HashVector
		{
			return _textOutDOHv;
		}

		public function set textOutDOHv(value:HashVector):void
		{
			_textOutDOHv = value;
		}

	}
}