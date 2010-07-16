package com.snsoft.tvc2.dataObject{
	import com.snsoft.util.HashVector;

	/**
	 * 时间线数据对象 
	 * @author Administrator
	 * 
	 */
	public class TimeLineDO{
		
		//名称
		private var _name:String;
		
		//文本
		private var _text:String;
		
		//业务数据对象列表
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