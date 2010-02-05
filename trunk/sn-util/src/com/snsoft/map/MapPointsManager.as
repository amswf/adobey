package com.snsoft.map
{
	import com.snsoft.map.util.HashArray;
	import com.snsoft.map.util.HitTest;
	
	import flash.geom.Point;

	public class MapPointsManager
	{
		
		//当前画线的点数组
		private var currentPointAry:HashArray = new HashArray();
		
		//所有点的数组的数组
		private var pointAryAry:HashArray = new HashArray();
		
		//碰撞检测类对象
		private var hitTest:HitTest = null;
		
		//碰撞检测的坐标差值域
		private var hitTestDValue:Point = new Point(5,5);
		
		public function MapPointsManager(workSizePoint:Point)
		{
			if(hitTest != null){
				hitTest = new HitTest(sizePoint:Point,stepPoint:Point);
			}
		}
		
		/**
		 *  
		 * @param point
		 * 
		 */		
		public function addPoint(point:Point):void{
			
		}
		
	}
}