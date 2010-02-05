package com.snsoft.map
{
	import flash.geom.Point;

	public class MapPointManagerState
	{
		//闭合链
		private static const IS_CLOSE:int = 3;
		
		//在当前链上
		private static const IS_IN_CPA:int = 2;
		
		//碰撞检测有
		private static const IS_HIT:int = 1;
		
		//正常
		private static const IS_NORMAL:int = 0;
		
		//点状态
		private var _pointState:int = IS_NORMAL;
		
		//检测到的点
		private var _hitPoint:Point = null;
		
		public function MapPointManagerState(pointState:int=0,hitPoint:Point = null)
		{
			this.pointState = pointState;
			this.hitPoint = hitPoint;
		}
		
		public function isState(pointState:int):Boolean{
			if(this.pointState == pointState){
				return true;
			}
			return false;
		}

		public function get pointState():int
		{
			return _pointState;
		}

		public function set pointState(value:int):void
		{
			_pointState = value;
		}

		public function get hitPoint():Point
		{
			return _hitPoint;
		}

		public function set hitPoint(value:Point):void
		{
			_hitPoint = value;
		}


	}
}