package com.snsoft.tvc2.dataObject{
	 
	/**
	 * 业务主数据列表数据对象 
	 * @author Administrator
	 * 
	 */	
	public class ListDO{
		
		//名称
		private var _name:String;
		
		//文本
		private var _text:String;
		
		//样式
		private var _style:String;
		
		//数据单元列表
		private var _listHv:Vector.<TextPointDO>;
		
		public function ListDO()
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

		public function get style():String
		{
			return _style;
		}

		public function set style(value:String):void
		{
			_style = value;
		}

		public function get listHv():Vector.<TextPointDO>
		{
			return _listHv;
		}

		public function set listHv(value:Vector.<TextPointDO>):void
		{
			_listHv = value;
		}


	}
}