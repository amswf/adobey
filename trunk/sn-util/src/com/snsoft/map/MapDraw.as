package com.snsoft.map
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	
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
			var tfd:TextField = new TextField();
			tfd.text = "("+point.x+","+point.y + ")";
			tfd.x = 5 + point.x;
			tfd.y = point.y;
			sprite.addChild(tfd);
			tfd.mouseEnabled = false;
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
		 * 
		 * 给闭合曲线填充。
		 * @param lineColor 线色
		 * @param fillColor 填充色
		 * @param pointArrayArray 闭合点链（数组）。
		 * @return 
		 * 
		 */		
		public static function drawCloseFoldLine(pointArray:Array,lineColor:uint= 0x000000,fillColor:uint = 0xffffff,thikness:uint = 0,r:uint = 2):Sprite{
			if(pointArray != null && pointArray.length > 0){
				var l:int = pointArray.length;
				var n:int = 0;
				var lastp:Point = pointArray[l-1] as Point;
				var firstp:Point = pointArray[0] as Point;
				if(lastp != null && firstp != null && firstp.equals(lastp)){
					n = l -1;
				}
				else {
					n = l;
				}
				
				var sprite:Sprite = new Sprite();
				var lineSprite:Sprite = new Sprite();
				var pointSprite:Sprite = new Sprite();
				for(var i:int =0;i<n;i++){
					var si:int = i;
					var ei:int = (i +1) % l;
					var sp:Point = pointArray[si] as Point;
					var ep:Point = pointArray[ei] as Point;
					var line:Sprite = MapDraw.drawLine(sp,ep,thikness,lineColor);
					var point:Sprite = MapDraw.drawPoint(sp,thikness,r,lineColor,fillColor);
					lineSprite.addChild(line);
					pointSprite.addChild(point);
				}
				sprite.addChild(lineSprite);
				sprite.addChild(pointSprite);
				return sprite;
			}
			return null;
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