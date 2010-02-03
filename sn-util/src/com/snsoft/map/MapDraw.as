package com.snsoft.map
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class MapDraw
	{
		
		public function MapDraw()
		{
			
		}
		
		/**
		 * 画圆
		 * @param point 点坐标
		 * @param thikness 线粗细
		 * @param r 半径
		 * @param lineColor 线色
		 * @param fillColor 填充色
		 * @return 
		 * 
		 */			
		public static function drawPoint(point:Point,thikness:uint,r:uint,lineColor:uint,fillColor:uint):Sprite{
			var sprite:Sprite = new Sprite();
			var shape:Shape = new Shape();
			sprite.addChild(shape);
			var gra:Graphics = shape.graphics;
			gra.lineStyle(thikness,lineColor);
			gra.beginFill(fillColor,1);
			gra.drawCircle(point.x,point.y,r);
			gra.endFill();
			return sprite;
		}
		
		/**
		 * 画线 
		 * @param startPoint 起始点
		 * @param endPoint 结束点
		 * @param thikness 线粗细
		 * @param lineColor 线色
		 * @return Sprite
		 * 
		 */			
		public static function drawLine(startPoint:Point,endPoint:Point,thikness:uint,lineColor:uint):Sprite{
			var sprite:Sprite = new Sprite();
			var shape:Shape = new Shape();
			sprite.addChild(shape);
			var gra:Graphics = shape.graphics;
			gra.lineStyle(thikness,lineColor);
			gra.moveTo(startPoint.x,startPoint.y);
			gra.lineTo(endPoint.x,endPoint.y);
			return sprite;
		}
		
		/**
		 * 给闭合曲线填充。
		 * @param lineColor 线色
		 * @param fillColor 填充色
		 * @param pointArrayArray 闭合点链（数组）的数组。
		 * @return Shape
		 * 
		 */		
		public static function drawFill(pointArrayArray:Array,lineColor:uint= 0x000000,fillColor:uint = 0xffffff,thikness:uint = 0):Shape {
			if (pointArrayArray != null) {
				var shape:Shape = new Shape();
				var gra:Graphics = shape.graphics;
				gra.lineStyle(thikness,lineColor,1);
				gra.beginFill(fillColor,1);
				for (var ii:int = 0; ii<pointArrayArray.length; ii++) {
					var pointArray:Array = pointArrayArray[ii];
					if (pointArray != null && pointArray.length >= 3) {
						
						var pStart:Point = pointArray[0];
						gra.moveTo(pStart.x,pStart.y);
						for (var i:int=1; i<pointArray.length; i++) {
							var p:Point = pointArray[i];
							gra.lineTo(p.x,p.y);
						}
						var pEnd:Point = pointArray[pointArray.length - 1];
						if (! pEnd.equals(pStart)) {
							gra.lineTo(pStart.x,pStart.y);
						}
					}
				}
				gra.endFill();
				return shape;
			}
			return null;
		}
	}
}