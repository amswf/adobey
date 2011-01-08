package com.snsoft.wayfinding{
	import flash.geom.Point;

	/**
	 * 结点 
	 * @author Administrator
	 * 
	 */	
	public class WayNode{
		
		/**
		 * 父结点坐标 
		 */		
		private var _parentPoint:Point;
		
		/**
		 * 结点坐标
		 */		
		private var _point:Point;
		
		public function WayNode(){
			
		}

		public function get point():Point
		{
			return _point;
		}

		public function set point(value:Point):void
		{
			_point = value;
		}

		public function get parentPoint():Point
		{
			return _parentPoint;
		}

		public function set parentPoint(value:Point):void
		{
			_parentPoint = value;
		}

	}
}