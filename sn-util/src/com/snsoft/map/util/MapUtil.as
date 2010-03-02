package com.snsoft.map.util{
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Transform;
	
	/**
	 * 生成地图工具类 
	 * @author Administrator
	 * 
	 */
	public class MapUtil {
		
		public function MapUtil() {
			
		}
		
		/**
		 * 点缩放计算
		 * @param p
		 * @param scalePoint
		 * @return 
		 * 
		 */		
		public static function creatSaclePoint(p:Point,scalePoint:Point = null):Point{
			if(scalePoint == null){
				scalePoint = new Point(1,1);
			}
			var rp:Point = new Point(p.x * scalePoint.x,p.y * scalePoint.y); 
			return rp;
		}
		
		/**
		 * 点缩放逆运算
		 * @param p
		 * @param scalePoint
		 * @return 
		 * 
		 */		
		public static function creatInverseSaclePoint(p:Point,scalePoint:Point = null):Point{
			if(scalePoint == null){
				scalePoint = new Point(1,1);
			}
			var rp:Point = new Point(p.x / scalePoint.x,p.y / scalePoint.y); 
			return rp;
		}
		
		
		/**
		 * 获得一个点的哈希名字 key 
		 * @param point 点坐标
		 * @return 
		 * 
		 */		
		public static function createPointHashName(point:Point):String {
			var str:String = String(point.x) + "|" + String(point.y);
			return str;
		}
		
		/**
		 * 删除所有字MC 
		 * 
		 */		
		public static function deleteAllChild(sprite:Sprite):void{
			while(sprite.numChildren >0){
				sprite.removeChildAt(0);
			}
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
				
				for (var i:int = 0; i<ipaa.length; i++) {
					var ipa:Array = ipaa[i] as Array;
					var hipa:Array = new Array();
					if (ipa != null) {
						for (var j:int=0; j<ipa.length; j++) {
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
			var sign:Boolean = false;
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
		
		/**
		 * 画线 
		 * @param p1
		 * @param p2
		 * @param color
		 * @return 
		 * 
		 */
		public function drawLine(p1:Point,p2:Point,color:uint):Shape {
			var shape:Shape = new Shape();
			var gra:Graphics = shape.graphics;
			gra.lineStyle(1,color,1);
			gra.moveTo(p1.x,p1.y);
			gra.lineTo(p2.x,p2.y);
			return shape;
		}
		
		/**
		 *  
		 * @param mc
		 * 
		 */		
		private function setPointSkinColor(mc:MovieClip,color:uint,alpha:Number):void{
			var trfm:Transform = mc.transform;
			var ctrfm:ColorTransform = trfm.colorTransform;
			ctrfm.alphaMultiplier = 1;
			ctrfm.alphaOffset = 255;
			ctrfm.blueMultiplier = 1;
			ctrfm.blueOffset = -255;
			ctrfm.greenMultiplier = 1;
			ctrfm.greenOffset = -255;
			ctrfm.redMultiplier = 1;
			ctrfm.redOffset = -255;
			trfm.colorTransform = ctrfm;
			mc.transform = trfm;
		}	
	}
}