package com.snsoft.mapview.util
{
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	
	public class MyColorTransform
	{
		public function MyColorTransform(){
		}
		
		public static function transColor(displayObject:DisplayObject,
										  alpha:Number = 1,
										  redOffset:int = 0,
										  greenOffset:int = 0,
										  blueOffset:int = 0):void{
			if(displayObject != null){
				alpha = alpha > 1 ? 1 : alpha;
				alpha = alpha < 0 ? 0 : alpha;
				var ctf:ColorTransform = displayObject.transform.colorTransform;
				ctf.alphaOffset = (1 - alpha) * -255;
				ctf.alphaMultiplier = 1;
				ctf.redOffset = redOffset;
				ctf.redMultiplier = 1;
				ctf.greenOffset = greenOffset;
				ctf.greenMultiplier = 1;
				ctf.blueOffset = blueOffset;
				ctf.blueMultiplier = 1;
				displayObject.transform.colorTransform = ctf;
			}
		}
	}
}