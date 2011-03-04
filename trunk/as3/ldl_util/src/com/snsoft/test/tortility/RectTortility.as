package com.snsoft.test.tortility
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Point;
	
	public class RectTortility
	{
		public function RectTortility()
		{
		}
		
		/**
		 * 转换所有点 
		 * @param q4p
		 * @return 
		 * 
		 */		
		public function tranBitMap(shape:Shape):BitmapData{
			var qp:Vector.<Point> = this.findAllQuadrilateralPoints(shape);
			return null;
		}
		
		/**
		 * 获得所有的转换后的点坐标 
		 * @param shape
		 * @return 
		 * 
		 */		
		public function findAllQuadrilateralPoints(shape:Shape):Vector.<Point>{
			var startX:Number = shape.x;
			var startY:Number= shape.y;
			var w:Number = shape.width;
			var h:Number = shape.height;
			var v:Vector.<Point> = new Vector.<Point>();
			for(var i:int = 0;i < w;i++){
				for(var j:int = 0;j < w;j++){
					var p:Point = new Point(startX + j,startY + i);
					if(shape.hitTestPoint(p.x,p.y,false)){
						v.push(p);
					}
				}
			}
			return v;
		}	
		
		/**
		 * 给闭合曲线填充。
		 * @param lineColor 线色
		 * @param fillColor 填充色
		 * @param pointArrayArray 闭合点链（数组）的数组。
		 * @return Shape
		 * 
		 */		
		public function drawFill(points:Vector.<Point>,lineColor:int= 0x000000,fillColor:int = 0xe6e6e6,thikness:int = 0):Shape {
			if (points != null) {
				var shape:Shape = new Shape();
				var gra:Graphics = shape.graphics;
				gra.lineStyle(thikness,lineColor,1);
				gra.beginFill(fillColor,1);
				if (points != null && points.length >= 3) {
					
					var pStart:Point = points[0];
					gra.moveTo(pStart.x,pStart.y);
					for (var i:int=1; i<points.length; i++) {
						var p:Point = points[i];
						gra.lineTo(p.x,p.y);
					}
					var pEnd:Point = points[points.length - 1];
					if (! pEnd.equals(pStart)) {
						gra.lineTo(pStart.x,pStart.y);
					}
				}
				gra.endFill();
				return shape;
			}
			return null;
		}
		
		/**
		 * 求两直线交点，平行时返回 值为 Point(NaN,NaN)
		 * 
		 * y = ( (y0-y1)*(y3-y2)*x0 + (y3-y2)*(x1-x0)*y0 + (y1-y0)*(y3-y2)*x2 + (x2-x3)*(y1-y0)*y2 ) / ( (x1-x0)*(y3-y2) + (y0-y1)*(x3-x2) );
		 * x = x2 + (x3-x2)*(y-y2) / (y3-y2);
		 * 
		 * @param p0 p0 p1 为一直线 
		 * @param p1
		 * @param p2 p2 p3 为一直线
		 * @param p3
		 * @return 
		 * 
		 */		
		public function calculate2LineRateIntersectionPoint(p0:Point,p1:Point,p2:Point,p3:Point):Point{
			var fy:Number = ( (p1.x - p0.x)*(p3.y - p2.y) + (p0.y - p1.y)*(p3.x - p2.x) );
			
			var fx:Number = (p3.y - p2.y);
			
			var x:Number = NaN;
			var y:Number = NaN;
			if(fy != 0){
				y = ( (p0.y - p1.y) * (p3.y - p2.y) * p0.x + (p3.y - p2.y) * (p1.x - p0.x) * p0.y +
					(p1.y - p0.y) * (p3.y - p2.y) * p2.x + (p2.x - p3.x) * (p1.y - p0.y) * p2.y) / fy;
				
				if(fx != 0){
					x = p2.x + ((p3.x - p2.x)) * (y - p2.y) / fx;
				}
				else {
					x = 0;
				}
			}
			
			return new Point(x,y);
		}
		
		/**
		 * 计算出原来的点坐标百分率 
		 * @param p
		 * @param lp11
		 * @param lp12
		 * @param lp21
		 * @param lp22
		 * @return 
		 * 
		 */		
		public function calculateSpace2LineRatePoint(p:Point,p0:Point,p1:Point,p2:Point,p3:Point):Point{
			
			var ipL0L2:Point = this.calculate2LineRateIntersectionPoint(p0,p1,p3,p2);//上下两边交点
			var ipL3L1:Point = this.calculate2LineRateIntersectionPoint(p0,p3,p1,p2);//左右两边交点
			
			var x:Number = 0;
			var y:Number = 0;
			
			var isParallelTB:Boolean = isNaN(ipL3L1.x) && isNaN(ipL3L1.y);//上下平行
			var isParallelLR:Boolean = isNaN(ipL0L2.x) && isNaN(ipL0L2.y);//左右平行
			
			var ipl:Point = null;//左交点
			var ipr:Point = null;//右交点
			var ipt:Point = null;//上交点
			var ipb:Point = null;//下交点
			
			var sl:Number = 0;
			var sr:Number = 0;
			var st:Number = 0;
			var sb:Number = 0;
			
			ipl = this.calculate2LineRateIntersectionPoint(p,ipL0L2,p0,p3);//左交点
			ipr = this.calculate2LineRateIntersectionPoint(p,ipL0L2,p1,p2);//右交点
			ipt = this.calculate2LineRateIntersectionPoint(p,ipL3L1,p0,p1);//上交点
			ipb = this.calculate2LineRateIntersectionPoint(p,ipL3L1,p3,p2);//下交点
			
			if(!isParallelTB && !isParallelLR){
				sl = Math.sqrt(this.calculate2PointSpaceSquare(p,ipl));
				sr = Math.sqrt(this.calculate2PointSpaceSquare(p,ipr));
				st = Math.sqrt(this.calculate2PointSpaceSquare(p,ipt));
				sb = Math.sqrt(this.calculate2PointSpaceSquare(p,ipb));
			}
			else if(!isParallelTB && isParallelLR){
				sl = Math.sqrt(this.calculate2PointSpaceSquare(p,ipl));
				sr = Math.sqrt(this.calculate2PointSpaceSquare(p,ipr));
				st = Math.sqrt(this.calculate2PointSpaceSquare(ipl,p0));
				sb = Math.sqrt(this.calculate2PointSpaceSquare(ipl,p3));
			}
			else if(isParallelTB && !isParallelLR){
				sl = Math.sqrt(this.calculate2PointSpaceSquare(ipt,p0));
				sr = Math.sqrt(this.calculate2PointSpaceSquare(ipt,p1));
				st = Math.sqrt(this.calculate2PointSpaceSquare(p,ipt));
				sb = Math.sqrt(this.calculate2PointSpaceSquare(p,ipb));
			}
			else if(isParallelTB && isParallelLR){
				sl = Math.sqrt(this.calculateSpacePointTo2PointLineSquare(p,p0,p3));
				sr = Math.sqrt(this.calculateSpacePointTo2PointLineSquare(p,p1,p2));
				st = Math.sqrt(this.calculateSpacePointTo2PointLineSquare(p,p0,p1));
				sb = Math.sqrt(this.calculateSpacePointTo2PointLineSquare(p,p3,p2));
			}
			
			x = sl / (sl + sr);
			y = st / (st + sb);
			return new Point(x,y);
		}
		
		/**
		 * 计算一个点到另两个点所在直线的距离的平方值 
		 * @param p
		 * @param lp1
		 * @param lp2
		 * @return 
		 * 
		 */		
		public function calculateSpacePointTo2PointLineSquare(p1:Point,p2:Point,p3:Point):Number{
			var n:Number = Math.pow((p1.x*(p3.y - p2.y) + p1.y*(p2.x - p3.x) + p3.x*p2.y - p2.x * p3.y),2);
			var m:Number = Math.pow((p3.y - p2.y),2) + Math.pow((p2.x - p3.x),2);
			var r:Number= n/m;
			return r;
		}
		
		/**
		 * 计算两点距离的平方值
		 * @param p1
		 * @param p2
		 * @return 
		 * 
		 */		
		public function calculate2PointSpaceSquare(p1:Point,p2:Point):Number{
			return (p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y);
		}
		
		
		/**
		 * 计算三点三角形面积
		 * double x1 = x[j] - x[i];
		 * double y1 = y[j] - y[i];
		 * double x2 = x[k] - x[i];
		 * double y2 = y[k] - y[i];
		 * return 0.5 * fabs(x1 * y2 - y1 * x2); 
		 */		
		public function calculate3PointAcreage(p1:Point,p2:Point,p3:Point):Number{
			
			var x1:Number = p2.x - p1.x;
			var y1:Number = p2.y - p1.y;
			var x2:Number = p3.x - p1.x;
			var y2:Number = p3.y - p1.y;
			return 0.5 * Math.abs(x1 * y2 - y1 * x2);
		}
	}
}