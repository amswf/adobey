package com.snsoft.map.util
{
	import flash.geom.Point;

	public class HitTestPoint
	{
		//碰撞点
		private var _point:Point = new Point();
		
		//相同碰撞点数量
		private var _sameCount:int = 0;
		
		
		public function HitTestPoint(point:Point,sameCount:int)
		{
			this.point = point;
			this.sameCount = sameCount;
		}

		public function get point():Point
		{
			return _point;
		}

		public function set point(value:Point):void
		{
			_point = value;
		}

		public function get sameCount():int
		{
			return _sameCount;
		}

		public function set sameCount(value:int):void
		{
			_sameCount = value;
		}


	}
}