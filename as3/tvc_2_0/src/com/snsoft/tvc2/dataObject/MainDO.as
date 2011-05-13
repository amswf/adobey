package com.snsoft.tvc2.dataObject{
	import com.snsoft.util.HashVector;

	
	/**
	 * 系统主数据对象（数据xml解析结果对象）
	 * @author Administrator
	 * 
	 */	
	public class MainDO{
		
		//主数据变量 VarDO 列表
		private var _mainVarDOHv:HashVector = new HashVector();
		
		//时间线 TimeLinesDO 列表
		private var _timeLineDOHv:HashVector = new HashVector();
		
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

		public function get timeLineDOHv():HashVector
		{
			return _timeLineDOHv;
		}

		public function set timeLineDOHv(value:HashVector):void
		{
			_timeLineDOHv = value;
		}

	}
}