package com.snsoft.tvc2.dataObject{
	
	/**
	 * 市场分布背景地图属性信息 
	 * @author Administrator
	 * 
	 */	
	public class MarketMap{
		
		//显示坐标 X
		private var _x:Number;
		
		//显示坐标 Y
		private var _y:Number;
		
		//显示坐标 Z
		private var _z:Number;
		
		//缩放比率
		private var _s:Number;
		
		public function MarketMap()
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