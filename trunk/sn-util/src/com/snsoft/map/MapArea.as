package com.snsoft.map
{
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	
	public class MapArea extends MovieClip
	{
		
		//线色
		private var lineColor:uint = 0x000000;
		
		//填充色
		private var fillColor:uint = 0x000000;
		
		
		public function MapArea()
		{
			super();
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
	}
}