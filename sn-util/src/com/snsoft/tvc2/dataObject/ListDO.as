package com.snsoft.tvc2.dataObject{
	 

	public class ListDO{
		
		private var _name:String;
		
		private var _text:String;
		
		private var _doStyle:String;
		
		private var _listHv:Vector = new Vector();
		
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

		public function get doStyle():String
		{
			return _doStyle;
		}

		public function set doStyle(value:String):void
		{
			_doStyle = value;
		}

		public function get listHv():Vector
		{
			return _listHv;
		}

		public function set listHv(value:Vector):void
		{
			_listHv = value;
		}


	}
}