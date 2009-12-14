package com.snsoft.util
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Point;
	
	public class ShapeUtil
	{
		public function ShapeUtil()
		{
		}
		
		public function drawShapeWithPoint(color:uint,alpha:Number,... points:Array):Shape{
			if(points != null){
				var shape:Shape = new Shape();
				var gra:Graphics = shape.graphics;
				gra.lineStyle(1,color,alpha);
				gra.beginFill(color,alpha);
				var pNum:int = 0;
				var sign:Boolean = true;
				for(var i:int = 0;i<points.length;i++){
					var point:Point = points[i] as Point;
					if(point != null){
						pNum ++;
						if(sign){
							gra.moveTo(point.x,point.y);
							sign = false;
						}
						else{
							gra.lineTo(point.x,point.y);
						}
					}
				}
				var point0:Point = points[0];
				if(point0 != null){
					gra.lineTo(point0.x,point0.y);
				}
				gra.endFill();
				return shape;
			}
			return null;
		}
	}
}