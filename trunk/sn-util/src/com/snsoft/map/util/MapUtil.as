package com.snsoft.map.util{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Point;
	
	public class MapUtil {
		
		public function MapUtil() {
			
		}
		
		//判断点是否在闭合曲线内
		public function concludeIsInShape(pointArray:Array,q:Point):Boolean {
			var sign = true;
			for (var i:int = 0; i<pointArray.length; i++) {
				var j:int = i + 1;
				if (j == pointArray.length) {
					j = 0;
				}
				var p1:Point = pointArray[i];
				var p2:Point = pointArray[j];
				
				var isLeft:Boolean = concludeIsLeft(p1,p2,q);
				if (isLeft) {
					sign = false;
					//break;
				}
			}
			return sign;
		}
		
		//判定点是否在线的左侧，在左侧说明不符合条件
		function concludeIsLeft(p1:Point,p2:Point,q:Point):Boolean {
			var radP1P2 = get2PointRad(p1,p2);
			var radP1Q = get2PointRad(p1,q);
			var lP1P2 = get2PointLength(p1,p2);
			var lP1Q = get2PointLength(p1,q);
			var radSub = radP1Q - radP1P2;
			var lSub = lP1Q - lP1P2;
			var lQP1P2 = lP1Q * Math.sin(radSub);
			if ( -  Math.PI / 2 < radSub && radSub < 0 && lSub < 0) {
				return true;
			}
			return false;
		}
		
		
		/**
		 * 画线 
		 * @param p1
		 * @param p2
		 * @param color
		 * @return 
		 * 
		 */		
		function drawLine(p1:Point,p2:Point,color:uint):Shape {
			var shape:Shape = new Shape();
			var gra:Graphics = shape.graphics;
			gra.lineStyle(1,color,1);
			gra.moveTo(p1.x,p1.y);
			gra.lineTo(p2.x,p2.y);
			return shape;
		}
		
		//获得两点所在直线与坐标系的夹角（弧度）
		function get2PointRad(p1:Point,p2:Point):Number {
			
			var rad = Math.atan2(p2.y - p1.y,p2.x - p1.x);
			return rad;
		}
		
		//获得两点间距离
		function get2PointLength(p1:Point,p2:Point):Number {
			
			var l = Math.sqrt((p2.y - p1.y) * (p2.y - p1.y) + (p2.x - p1.x) * (p2.x - p1.x));
			return l;
		}
		
		//给闭合曲线填充，闭合曲线可有多个。
		/**
		 * 
		 * @param lineColor
		 * @param fillColor
		 * @param pointArrayArray
		 * @return 
		 * 
		 */		
		public function drawFill(lineColor:uint,fillColor:uint,...pointArrayArray:Array):Shape {
			if (pointArrayArray != null) {
				var shape:Shape = new Shape();
				var gra:Graphics = shape.graphics;
				gra.lineStyle(1,lineColor,1);
				gra.beginFill(fillColor,1);
				for (var ii:int = 0; ii<pointArrayArray.length; ii++) {
					var pointArray:Array = pointArrayArray[ii];
					if (pointArray != null && pointArray.length >= 3) {
						
						var pStart:Point = pointArray[0];
						gra.moveTo(pStart.x,pStart.y);
						for (var i=1; i<pointArray.length; i++) {
							var p:Point = pointArray[i];
							gra.lineTo(p.x,p.y);
						}
						var pEnd:Point = pointArray[pointArray.length - 1];
						if (!(pEnd.x == pStart.x && pEnd.y == pStart.y)) {
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