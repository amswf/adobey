package com.snsoft.util{
	import flash.display.Sprite;
	
	public class SpriteUtil{
		
		public function SpriteUtil()
		{
		}
		
		/**
		 * 删除所有字MC 
		 * 
		 */		
		public static function deleteAllChild(spr:Sprite):void{
			try{
				while(spr.numChildren > 0){
					spr.removeChildAt(0);
				}
			}
			catch(e:Error){
				trace("SpriteUtil.deleteAllChild("+spr+"):出错！");
			}
		}
	}
}