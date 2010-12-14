package com.snsoft.util{
	import com.snsoft.util.Math.Polar;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 图片处理类 
	 * @author Administrator
	 * 
	 */	
	public class ImageProcess{
		
		public function ImageProcess(){
		
		}
		
		/**
		 * 图片缩放裁切 
		 * @param bmd
		 * @param cutRect
		 * @param scaleX
		 * @param scaleY
		 * @return 
		 * 
		 */		
		public static function cutImage(bmd:BitmapData,clipRect:Rectangle,rotation:Number,scaleX:Number,scaleY:Number):BitmapData{
			
			
			var sclbmd:BitmapData = new BitmapData(bmd.width * scaleX,bmd.height * scaleY);
			var sclMatrix:Matrix = new Matrix();
			sclMatrix.scale(scaleX,scaleY);
			sclbmd.draw(bmd,sclMatrix,new ColorTransform(),BlendMode.NORMAL,null,true);
			
			var rtbmd:BitmapData = new BitmapData(clipRect.width,clipRect.height);
			var tranMatrix:Matrix = new Matrix();
			
			
			var crpw:Number = clipRect.width / 2;
			var crph:Number = clipRect.height / 2;
			var cx:Number = clipRect.x + crpw;
			var cy:Number = clipRect.y + crph;
			var cpl:Polar = Polar.point(cx,cy);
			cpl.rotation += rotation;
			var cpi:Point = Point.polar(cpl.len,cpl.angle);
			cpi.x = crpw - cpi.x;
			cpi.y = crph - cpi.y;
			tranMatrix.rotate( Math.PI / 4);
			
			//tranMatrix.translate(cpi.x,cpi.y);
			rtbmd.draw(sclbmd,tranMatrix,new ColorTransform(),BlendMode.NORMAL,null,true);
			return rtbmd;
		}
	}
}