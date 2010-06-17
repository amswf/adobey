package com.snsoft.tvc2.dataObject{
	import com.snsoft.util.HashVector;

	public class TextOutsDO{
		
		private var _textOutDOHv:Vector.<TextOutDO>;
		
		public function TextOutsDO()
		{
		}

		public function get textOutDOHv():Vector.<TextOutDO>
		{
			return _textOutDOHv;
		}

		public function set textOutDOHv(value:Vector.<TextOutDO>):void
		{
			_textOutDOHv = value;
		}

	}
}