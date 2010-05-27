package com.snsoft.tvc2.dataObject{
	 

	public class ListDO{
		
		private var _name:String;
		
		private var _text:String;
		
		private var _style:String;
		
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