package com.snsoft.tortility
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
			trace(qp);
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
					var p:Point = new Point(startX + i,startY + j);
					if(shape.hitTestPoint(p.x,p.y,true)){
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
		public function drawFill(points:Vector.<Point>,lineColor:uint= 0x000000,fillColor:uint = 0xe6e6e6,thikness:uint = 0):Shape {
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
		 * 计算一个点到另两个点所在直线的距离的平方值 
		 * @param p
		 * @param lp1
		 * @param lp2
		 * @return 
		 * 
		 */		
		public function calculateSpacePointTo2PointLineSquare(p:Point,lp1:Point,lp2:Point):Number{
			
			var acr:Number = this.calculate3PointAcreage(p,lp1,lp2);
			return 0;
		}
		
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