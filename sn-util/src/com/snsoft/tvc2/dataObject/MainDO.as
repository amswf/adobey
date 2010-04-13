package com.snsoft.tvc2.dataObject{
	import com.snsoft.util.HashVector;

	public class MainDO{
		
		// vars
		private var _mainVarDOHv:HashVector = new HashVector();
		
		// timeLines
		private var _dataDOHv:HashVector = new HashVector();
		
		public function MainDO()	{
		}

		public function get mainVarDOHv():HashVector
		{
			return _mainVarDOHv;
		}

		public function set mainVarDOHv(value:HashVector):void
		{
			_mainVarDOHv = value;
		}

		public function get dataDOHv():HashVector
		{
			return _dataDOHv;
		}

		public function set dataDOHv(value:HashVector):void
		{
			_dataDOHv = value;
		}
	}
}