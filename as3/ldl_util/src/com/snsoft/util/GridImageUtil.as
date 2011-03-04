package com.snsoft.util{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;

	public class GridImageUtil{
		public function GridImageUtil()
		{
		}
		
		/**
		 * 画虚实相间的网格线 
		 * @param width 网格面高
		 * @param height 网格面宽
		 * @param alphaColor 带透明度颜色
		 * @param intervalX 小刻度虚线间隔
		 * @param intervalY 小刻度虚线间隔
		 * @param scaleDivisionX 大刻度实线间隔
		 * @param scaleDivisionY 大刻度实线间隔
		 * @return 
		 * 
		 */		
		public static function drawGridLine(width:int,height:int,backAlphaColor:uint = 0x33ffffff,alphaColor:uint = 0x99ffffff,pointSpaceX:int=2,pointSpaceY:int=2,gradX:int=10,gradY:int=10,gradGroupX:uint=5,gradGroupY:uint = 5):BitmapData{
			var bmd:BitmapData = new BitmapData(width,height,true,backAlphaColor);
			var modx:int = gradX * gradGroupX;
			var mody:int = gradY * gradGroupY;
			for (var j:int = 0; j < bmd.height; j += gradY) {
				var m:int =1;
				if(j % mody == 0){
					m = 1;
				}
				else {
					m = pointSpaceX;
				}
				for (var i:int = 0; i < bmd.width; i +=m) {
					if( j > 0){
						bmd.setPixel32(i,j,alphaColor);
					}
				}
			}
			
			for (var ii:int = 0; ii < bmd.width; ii += gradX) {
				var n:int =1;
				if(ii % modx == 0){
					n = 1;
				}
				else {
					n = pointSpaceY;
				}
				for (var jj:int = 0; jj < bmd.height; jj +=n) {
					if(ii > 0){
						bmd.setPixel32(ii,jj,alphaColor);
					}
				}
			}
			return bmd;
		}
		
		
		public static function drawShepherdSheck(width:int,height:int,rectWidth:int = 8,rectHeigh:int = 8,alphaColor1:uint = 0xffffffff,alphaColor2:uint = 0xffdddddd):BitmapData{
			var bmd:BitmapData = new BitmapData(width,height);
			
			var rectBmd1:BitmapData = new BitmapData(rectWidth,rectHeigh,true,alphaColor1);
			var rectBmd2:BitmapData = new BitmapData(rectWidth,rectHeigh,true,alphaColor2);
			
			var signy:Boolean = true;
			for (var i:int = 0; i < width; i += rectHeigh) {
				
				var signx:Boolean = signy;
				signy = !signy;
				for (var j:int = 0; j < height; j += rectWidth) {
					var matrix:Matrix = new Matrix();
					matrix.translate(i,j);
					if(signx){
						bmd.draw(rectBmd1,matrix);
					}
					else {
						bmd.draw(rectBmd2,matrix);
					}
					signx = !signx;
				}
			}
			trace(i,j);
			return bmd;
			
		}


	}
}