package com.snsoft.tvc2.dataObject{
	
	/**
	 * 业务主数据单元 
	 * @author Administrator
	 * 
	 */	
	public class TextPointDO{
		
		//名称
		private var _name:String;
		
		//文本
		private var _text:String;
		
		//值
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