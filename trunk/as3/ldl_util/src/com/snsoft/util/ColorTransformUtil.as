package com.snsoft.util{
	import fl.motion.Color;
	
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	
	public class ColorTransformUtil{
		public function ColorTransformUtil()
		{
		}
		
		public static function setColor(mc:Sprite = null,color:uint = 0xffffff,alpha:Number = 1,mult:Number = 0):void{
			if(mc != null){
				mc.alpha = alpha;
				var ct:ColorTransform = mc.transform.colorTransform;
				var cl:Color = new Color();
				cl.color = color;
				ct.redOffset = cl.redOffset;
				ct.greenOffset = cl.greenOffset;
				ct.blueOffset = cl.blueOffset;
				ct.redMultiplier = mult;
				ct.greenMultiplier = mult;
				ct.blueMultiplier = mult;
				mc.transform.colorTransform = ct;
			}
		}
	}
}