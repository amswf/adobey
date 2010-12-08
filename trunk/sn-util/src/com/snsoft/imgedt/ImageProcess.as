package com.snsoft.imgedt{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
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
		public static function cutImage(bmd:BitmapData,clipRect:Rectangle,scaleX:Number,scaleY:Number):BitmapData{
			
			
			var sclbmd:BitmapData = new BitmapData(bmd.width * scaleX,bmd.height * scaleY);
			var sclMatrix:Matrix = new Matrix();
			sclMatrix.scale(scaleX,scaleY);
			sclbmd.draw(bmd,sclMatrix,new ColorTransform(),BlendMode.NORMAL,null,true);
			
			var rtbmd:BitmapData = new BitmapData(clipRect.width,clipRect.height);
			var tranMatrix:Matrix = new Matrix();
			tranMatrix.translate(- clipRect.x,- clipRect.y);
			rtbmd.draw(sclbmd,tranMatrix,new ColorTransform(),BlendMode.NORMAL,null,true);
			return rtbmd;
		}
	}
}