package com.snsoft.util.Math{
	public class Polar{
		
		private var _len:Number;
		
		private var _angle:Number;
		
		private var _rotation:Number;
		
		public function Polar(len:Number=0,angle:Number = 0){
			this.len = len;
			this.angle = angle;
		}
		
		public static function point(x:Number,y:int):Polar{
			
			var angle:Number = Math.atan2(x,y);
			var len:Number = Math.sqrt(x * x + y * y);
			return new Polar(len,angle);
		}
		
		
		public function get len():Number
		{
			return _len;
		}

		public function set len(value:Number):void
		{
			_len = value;
		}

		public function get angle():Number
		{
			return _angle;
		}

		public function set angle(value:Number):void
		{
			_angle = value;
			_rotation = value * 180 / Math.PI;
		}

		public function get rotation():Number
		{
			return _rotation;
		}

		public function set rotation(value:Number):void
		{
			_angle = value * Math.PI / 180;
			_rotation = value;
		}


	}
}