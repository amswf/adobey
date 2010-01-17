package com.snsoft.map.util{
	import flash.geom.Point;

	public class HitTest {
		//碰撞检测点数组的矩阵，矩阵是一个二维数组
		private var pointAryAryAry:Array = new Array();

		//最大值点
		private var sizePoint:Point = new Point();

		//X 和 Y 的步进值
		private var stepPoint:Point = new Point();

		private var xNum:int = 0;

		private var yNum:int = 0;

		/**
		 * 全部为正数 
		 * @param sizePoint
		 * @param stepPoint
		 * 
		 */
		public function HitTest(sizePoint:Point,stepPoint:Point) {

			if (stepPoint != null && sizePoint != null) {
				//stepPoint 的坐标值不能大于 sizePoint的坐标值
				if (Math.abs(stepPoint.x) > Math.abs(sizePoint.x)) {
					stepPoint.x = sizePoint.x;
				}
				if (Math.abs(stepPoint.y) > Math.abs(sizePoint.y)) {
					stepPoint.y = sizePoint.y;
				}
				this.sizePoint = sizePoint;
				this.stepPoint = stepPoint;

				var xn:int = int(this.sizePoint.x / this.stepPoint.x + 1);
				this.xNum = xn;
				var yn:int = int(this.sizePoint.y / this.stepPoint.y + 1);
				this.yNum = yn;

				var xary:Array = new Array();
				for (var i:int = 0; i<xn; i++) {
					var yary:Array = new Array();
					for (var j:int = 0; j<yn; j++) {
						var pary:Array = new Array();
						yary.push(pary);
					}
					xary.push(yary);
				}
				this.pointAryAryAry = xary;
			}
		}

		/**
		 * 添加点
		 * @param point
		 * 
		 */
		public function addPoint(point:Point):void {
			var p:Point = this.getArrayIndex(point);
			
			var ix:int = int(p.x);
			var iy:int = int(p.y);
			if(this.pointAryAryAry != null && this.pointAryAryAry.length >= ix){
				var yary:Array =  this.pointAryAryAry[ix] as Array;
				if(yary != null && yary.length >=iy){
					var pary:Array = yary[iy] as Array;
					if(pary != null){
						pary.push(point);
					}
				}
			}
		}
		
		/**
		 *  
		 * @param point 需要检测的点
		 * @param dvalue 点坐标的差值域
		 * @return 
		 * 
		 */		
		public function findPoint(point:Point,dvalue:Point = null):Point{
			if(dvalue == null){
				dvalue = new Point(0,0);
			}
			if(point != null && dvalue != null){
				var p:Point = this.getArrayIndex(point);
				var ix:int = int(p.x);
				var iy:int = int(p.y);
	
				if(this.pointAryAryAry != null && this.pointAryAryAry.length >= ix){
					var yary:Array =  this.pointAryAryAry[ix] as Array;
					if(yary != null && yary.length >=iy){
						var pary:Array = yary[iy] as Array;
						if(pary != null){
							for(var k:int = 0;k<pary.length;k ++){
								var op:Point = pary[k] as Point;
								if(op != null){
									if(Math.abs(op.x -point.x) <= Math.abs(dvalue.x)){
										if(Math.abs(op.y -point.y) <= Math.abs(dvalue.y)){
											return op;
										}
									}
								}
							}
						}
					}
				}
			}
			return null;
		}

		/**
		 * 获得矩阵存放坐标
		 * @param point
		 * @return 
		 * 
		 */
		public function getArrayIndex(point:Point):Point {

			var xn:int = int(point.x / this.stepPoint.x);
			var yn:int = int(point.y / this.stepPoint.y);
			return new Point(xn,yn);
		}
	}
}