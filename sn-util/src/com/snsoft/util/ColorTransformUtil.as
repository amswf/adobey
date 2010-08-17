package com.snsoft.util{
	import fl.motion.Color;
	
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	
	public class ColorTransformUtil{
		public function ColorTransformUtil()
		{
		}
		
		public static function setColor(mc:Sprite = null,color:uint = 0xffffff):void{
			if(mc != null){
				var ct:ColorTransform = mc.transform.colorTransform;
				var cl:Color = new Color();
				cl.color = color;
				ct.redOffset = cl.redOffset;
				ct.greenOffset = cl.greenOffset;
				ct.blueOffset = cl.blueOffset;
				mc.transform.colorTransform = ct;
			}
		}
	}
}