package com.snsoft.tvc2.util{
	import com.snsoft.tvc2.Business;
	import com.snsoft.tvc2.SystemConfig;
	import com.snsoft.util.HashVector;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class PlaceType{
		
		public function PlaceType(){
		}
		
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