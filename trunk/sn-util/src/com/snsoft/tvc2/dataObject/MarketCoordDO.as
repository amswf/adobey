package com.snsoft.tvc2.dataObject{
	import com.snsoft.util.HashVector;

	/**
	 * 市场信息单元 
	 * @author Administrator
	 * 
	 */	
	public class MarketCoordDO{
		
		//名称
		private var _name:String;
		
		//值
		private var _value:String;
		
		//文本
		private var _text:String;
		
		//显示坐标 X
		private var _x:Number;
		
		//显示坐标 Y
		private var _y:Number;
		
		//显示坐标 Z
		private var _z:Number;
		
		//缩放比率
		private var _s:Number;
		
		public function MarketCoordDO()
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

		public function get value():String
		{
			return _value;
		}

		public function set value(value:String):void
		{
			_value = value;
		}

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text = value;
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

		public function get z():Number
		{
			return _z;
		}

		public function set z(value:Number):void
		{
			_z = value;
		}

		public function get s():Number
		{
			return _s;
		}

		public function set s(value:Number):void
		{
			_s = value;
		}


	}
}