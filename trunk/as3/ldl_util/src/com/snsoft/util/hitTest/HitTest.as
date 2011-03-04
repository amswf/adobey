package com.snsoft.util.hitTest{
	import flash.geom.Point;
	
	public class HitTest {
		//碰撞检测点数组的矩阵，矩阵是一个二维数组
		private var pointAryAryAry:Array = new Array();
		
		//最大值点
		private var _sizePoint:Point = new Point();

		 

		
		//X 和 Y 的步进值
		private var _stepPoint:Point = new Point();
		
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
				
				this._sizePoint = sizePoint;
				this._stepPoint = stepPoint;
				
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
		 * 创建新的碰撞对象，复制所有碰撞点。 
		 * @param sizePoint
		 * @param stepPoint
		 * @return 
		 * 
		 */		
		public function createCopy(sizePoint:Point,stepPoint:Point):HitTest{
			var xary:Array = this.pointAryAryAry;
			var ht:HitTest = new HitTest(sizePoint,stepPoint);
			for (var i:int = 0; i<this.xNum; i++) {
				var yary:Array = xary[i] as Array;
				for (var j:int = 0; j<this.xNum; j++) {
					var pary:Array = yary[j] as Array;
					if(pary != null){
						for(var k:int = 0;k<pary.length;k ++){
							var ohtp:HitTestPoint = pary[k] as HitTestPoint;
							ht.addPoint(ohtp.point);
						}
					}
				}
				xary.push(yary);
			}
			return ht;
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
						var htp:HitTestPoint = this.findHitTestPoint(point,new Point(0,0));
						if(htp == null){
							htp = new HitTestPoint(point,1);
							pary.push(htp);
						}
						else {
							htp.sameCount ++;
						}
					}
				}
			}
		}
		
		/**
		 * 删除注册的碰撞点 
		 * @param point
		 * 
		 */		
		public function deletePoint(point:Point):void{
			if(point != null){
				var p:Point = this.getArrayIndex(point);
				var ix:int = int(p.x);
				var iy:int = int(p.y);
				
				if(this.pointAryAryAry != null && this.pointAryAryAry.length >= ix){
					var yary:Array =  this.pointAryAryAry[ix] as Array;
					if(yary != null && yary.length >=iy){
						var pary:Array = yary[iy] as Array;
						if(pary != null){
							for(var k:int = 0;k<pary.length;k ++){
								var ohtp:HitTestPoint = pary[k] as HitTestPoint;
								if(ohtp != null){
									var op:Point = ohtp.point;
									if(this.isHit2Point(op,point,new Point(0,0))){
										ohtp.sameCount --;
										trace("hitTest",pary.length);
										if(ohtp.sameCount <= 0){
											pary = pary.splice(k,1);
										}
										trace(pary.length);
									}
								}
							}
						}
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
			var htp:HitTestPoint = this.findHitTestPoint(point,dvalue);
			var p:Point = null;
			if(htp != null){
				p = htp.point;
			}
			return p;
		}
		
		/**
		 *  
		 * @param point 需要检测的点
		 * @param dvalue 点坐标的差值域
		 * @return 
		 * 
		 */		
		private function findHitTestPoint(point:Point,dvalue:Point = null):HitTestPoint{
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
								var ohtp:HitTestPoint = pary[k] as HitTestPoint;
								if(ohtp != null){
									var op:Point = ohtp.point;
									if(this.isHit2Point(op,point,dvalue)){
										return ohtp;
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
		 * 测试两个点是否碰撞 
		 * @param p1 测试点
		 * @param p2 测试点
		 * @param dp 差值
		 * @return Boolean
		 * 
		 */		
		public function isHit2Point(p1:Point,p2:Point,dp:Point):Boolean{
			if(Math.abs(p1.x -p2.x) <= Math.abs(dp.x)){
				if(Math.abs(p1.y -p2.y) <= Math.abs(dp.y)){
					return true;
				}
			}
			return false;
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

		public function get stepPoint():Point
		{
			return _stepPoint;
		}

		public function get sizePoint():Point
		{
			return _sizePoint;
		}


	}
}