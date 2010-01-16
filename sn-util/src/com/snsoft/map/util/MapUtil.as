package com.snsoft.map.util{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Point;
	
	/**
	 * 生成地图工具类 
	 * @author Administrator
	 * 
	 */
	public class MapUtil {
		
		public function MapUtil() {
			
		}
		
		/**
		 * 检测图形是否全包围另一个图形，类似同心圆情况 
		 * @param outsidePointArray
		 * @param insidePointArray
		 * @return 
		 * 
		 */
		public function checkShapeSurround(outsidePointArray:Array,...insidePointArrayArray):Boolean {
			
			var ipaa:Array = insidePointArrayArray;
			var ospa:Array = outsidePointArray;
			
			if (ipaa != null && ospa != null) {
				
				for (var i = 0; i<ipaa.length; i++) {
					var ipa:Array = ipaa[i] as Array;
					var hipa:Array = new Array();
					if (ipa != null) {
						for (var j=0; j<ipa.length; j++) {
							var point:Point = ipa[j] as Point;
							if (point != null) {
								if (! this.concludeIsInShape(point,ospa)) {
									return false;
								}
							}
						}
					}
				}
			}
			return true;
		}
		
		/**
		 * 判断点是否在闭合曲线内 
		 * @param pointArray
		 * @param q
		 * @return 
		 * 
		 */
		public function concludeIsInShape(q:Point,pointArray:Array):Boolean {
			var sign = false;
			if(pointArray != null && q != null){
				var shape:Shape = this.drawFill(0x000000,0x000000,pointArray);
				if(shape.hitTestPoint(q.x,q.y)){
					sign = true;
				}
			}
			return sign;
		}
		
		
		/**
		 * 给闭合曲线填充，闭合曲线可有多个。
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
		
		
		/**
		 * 判定点是否在线的左侧，在左侧说明不符合条件
		 * @param p1
		 * @param p2
		 * @param q
		 * @return 
		 * 
		 */
		public function concludeIsLeft(p1:Point,p2:Point,q:Point):Boolean {
			var radP1P2 = get2PointRad(p1,p2);
			var radP1Q = get2PointRad(p1,q);
			var lP1P2 = get2PointLength(p1,p2);
			var lP1Q = get2PointLength(p1,q);
			var radSub = radP1Q - radP1P2;
			var lSub = lP1Q - lP1P2;
			var lQP1P2 = lP1Q * Math.sin(radSub);
			if ( -Math.PI / 2 < radSub && radSub < 0 && lSub < 0) {
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
		
		/**
		 * 获得两点所在直线与坐标系的夹角（弧度） 
		 * @param p1
		 * @param p2
		 * @return 
		 * 
		 */
		function get2PointRad(p1:Point,p2:Point):Number {
			
			var rad = Math.atan2(p2.y - p1.y,p2.x - p1.x);
			return rad;
		}
		
		/**
		 * 获得两点间距离 
		 * @param p1
		 * @param p2
		 * @return 
		 * 
		 */
		function get2PointLength(p1:Point,p2:Point):Number {
			
			var l = Math.sqrt((p2.y - p1.y) * (p2.y - p1.y) + (p2.x - p1.x) * (p2.x - p1.x));
			return l;
		}
		
		
	}
}