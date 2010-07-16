package com.snsoft.tvc2.util{
	import com.snsoft.tvc2.Business;
	import com.snsoft.tvc2.SystemConfig;
	import com.snsoft.util.HashVector;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 位置显示 
	 * @author Administrator
	 * 
	 */	
	public class PlaceType{
		
		public function PlaceType(){
		}
		
		/**
		 * 设置显示位置 
		 * @param sprite 要设置的显示对象
		 * @param stageSize 场景宽高
		 * @param type 位置类型 ，水平：无 / 左 l /中 c / 右 r ，垂直：无 / 上 t / 中 m / 下 l
		 * 
		 */		
		public static function setSpritePlace(sprite:Business,stageSize:Point,type:String = null):void{
			if(sprite != null && stageSize != null){
				sprite.addEventListener(Business.EVENT_PLAYED,handlerAddToStage);
			}
			function handlerAddToStage(e:Event):void{				
				var rect:Rectangle = sprite.getRect(sprite.parent);
				if(type != null){
					if(type.indexOf("t") >= 0){
						sprite.y = 0;
					}
					else if(type.indexOf("m") >= 0){
						sprite.y = (stageSize.y - rect.height) / 2 - rect.y;
					}
					else if(type.indexOf("b") >= 0){
						sprite.y = (stageSize.y - rect.height);
					}
					
					if(type.indexOf("l") >= 0){
						sprite.x = 0;
					}
					else if(type.indexOf("c") >= 0){
						sprite.x = (stageSize.x - rect.width) / 2 - rect.x;
					}
					else if(type.indexOf("r") >= 0){
						sprite.x = (stageSize.x - rect.width);
					}
				}
			}
		}
	}
}