package com.snsoft.util {
	import com.snsoft.util.Math.Polar;

	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Point;

	public class ShapeUtil {
		public function ShapeUtil() {
		}

		/**
		 * 两点之间画填充，区别于画线
		 * @param p1
		 * @param p2
		 * @param size 填充图形的宽度
		 * @param color 填充颜色
		 * @param alpha 透明度
		 * @return
		 *
		 */
		public static function drawShape(p1:Point, p2:Point, size:int, color:int, alpha:Number):Shape {
			var len:int = Point.distance(p1, p2);
			var sp:Point = p2.subtract(p1);
			var polar:Polar = Polar.point(sp.x, sp.y);
			var shape:Shape = new Shape();
			var gra:Graphics = shape.graphics;
			gra.beginFill(color, alpha);
			gra.drawRect(0, -size / 2, len, size);
			gra.endFill();
			shape.x = p1.x;
			shape.y = p1.y;
			shape.rotation = polar.rotation;
			return shape;
		}

		public static function drawShapeWithPoint(color:int, alpha:Number, ... points:Array):Shape {
			if (points != null) {
				var shape:Shape = new Shape();
				var gra:Graphics = shape.graphics;
				gra.lineStyle(1, color, alpha);
				gra.beginFill(color, alpha);
				var pNum:int = 0;
				var sign:Boolean = true;
				for (var i:int = 0; i < points.length; i++) {
					var point:Point = points[i] as Point;
					if (point != null) {
						pNum++;
						if (sign) {
							gra.moveTo(point.x, point.y);
							sign = false;
						}
						else {
							gra.lineTo(point.x, point.y);
						}
					}
				}
				var point0:Point = points[0];
				if (point0 != null) {
					gra.lineTo(point0.x, point0.y);
				}
				gra.endFill();
				return shape;
			}
			return null;
		}
	}
}
