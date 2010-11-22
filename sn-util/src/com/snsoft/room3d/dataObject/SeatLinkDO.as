package com.snsoft.room3d.dataObject{
	
	/**
	 * 观察点按钮数据对象 
	 * @author Administrator
	 * 
	 */	
	public class SeatLinkDO{
		
		private var _x:Number;
		
		private var _y:Number;
		
		private var _type:Number;
		
		private var _name:String;
		
		
		public function SeatLinkDO()
		{
		}

		public function get x():Number
		{
			return _x;
		}

		public function set x(value:Number):void
		{
			_x = value;
		}

		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			_y = value;
		}

		public function get type():Number
		{
			return _type;
		}

		public function set type(value:Number):void
		{
			_type = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}


	}
}