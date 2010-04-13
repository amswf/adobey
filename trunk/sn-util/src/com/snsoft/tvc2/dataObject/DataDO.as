package com.snsoft.tvc2.dataObject{
	
	/**
	 * 
	 * @author Administrator
	 * 
	 */	
	public class DataDO{
		
		private var _type:String = null;
		
		private var _data:Vector.<ListDO> = null;
		
		public function DataDO()
		{
		}

		public function get data():Vector.<ListDO>
		{
			return _data;
		}

		public function set data(value:Vector.<ListDO>):void
		{
			_data = value;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}


	}
}