package com.snsoft.tortility
{
	import flash.geom.Point;

	public class Quadrilateral4Point
	{
		private var _a:Point = null;
		
		private var _b:Point = null;
		
		private var _c:Point = null;
		
		private var _d:Point = null;
		
		public function Quadrilateral4Point(a:Point = null,b:Point = null,c:Point = null,d:Point = null)
		{
			this.a = a;
			this.b = b;
			this.c = c;
			this.d = d;
		}

		public function get a():Point
		{
			return _a;
		}

		public function set a(value:Point):void
		{
			_a = value;
		}

		public function get b():Point
		{
			return _b;
		}

		public function set b(value:Point):void
		{
			_b = value;
		}

		public function get c():Point
		{
			return _c;
		}

		public function set c(value:Point):void
		{
			_c = value;
		}

		public function get d():Point
		{
			return _d;
		}

		public function set d(value:Point):void
		{
			_d = value;
		}


	}
}