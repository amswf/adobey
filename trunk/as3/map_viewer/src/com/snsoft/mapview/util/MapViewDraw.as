package com.snsoft.mapview.util{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Point;

	public class MapViewDraw{
		
		public function MapViewDraw()
		{
		}
		
		/**
		 * 给闭合曲线填充，闭合曲线可有多个。
		 * @param lineColor
		 * @param fillColor
		 * @param pointArrayArray
		 * @return 
		 * 
		 */
		public static function drawFill(fillColor:int,fillAlpha:Number=1,...pointArrayArray:Array):Shape {
			if (pointArrayArray != null) {
				var shape:Shape = new Shape();
				var gra:Graphics = shape.graphics;
				gra.lineStyle();
				gra.beginFill(fillColor,fillAlpha);
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
		
		public static function drawCloseLines(lineColor:int,...pointArrayArray:Array):Shape {
			if (pointArrayArray != null) {
				var shape:Shape = new Shape();
				var gra:Graphics = shape.graphics;
				gra.lineStyle(1,lineColor,1);
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
				return shape;
			}
			return null;
		}
		
		/**
		 * 画线 
		 * @param p1
		 * @param p2
		 * @param color
		 * @return 
		 * 
		 */
		public static function drawLine(p1:Point,p2:Point,color:int):Shape {
			var shape:Shape = new Shape();
			var gra:Graphics = shape.graphics;
			gra.lineStyle(1,color,1);
			gra.moveTo(p1.x,p1.y);
			gra.lineTo(p2.x,p2.y);
			return shape;
		}
		
		/**
		 *  
		 * @param sizePoint
		 * @return 
		 * 
		 */		
		public static function drawRect(sizePoint:Point):Shape{
			var shape:Shape = new Shape();
			var gra:Graphics = shape.graphics;
			gra.beginFill(0x000000,1);
			gra.drawRect(0,0,sizePoint.x,sizePoint.y);
			gra.endFill();
			return shape;
		}
	}
}