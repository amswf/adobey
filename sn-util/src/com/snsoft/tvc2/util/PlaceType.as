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
				trace("setSpritePlace",sprite.width,sprite.height);
				var rect:Rectangle = sprite.getRect(sprite.parent);
				
				if(type =="tl"){
					sprite.x = 0;
					sprite.y = 0;
				}
				else if(type =="tc"){
					sprite.x = (stageSize.x - rect.width) / 2;
					sprite.y = 0;
				}
				else if(type =="tr"){
					sprite.x = (stageSize.x - rect.width);
					sprite.y = 0;
				}
				else if(type =="ml"){
					sprite.x = 0;
					sprite.y = (stageSize.y - rect.height) / 2;
				}
				else if(type =="mc"){
					sprite.x = (stageSize.x - rect.width) / 2;
					sprite.y = (stageSize.y - rect.height) / 2;
				}
				else if(type =="mr"){
					sprite.x = (stageSize.x - rect.width);
					sprite.y = (stageSize.y - rect.height) / 2;
				}
				else if(type =="bl"){
					sprite.x = 0;
					sprite.y = (stageSize.y - rect.height);
				}
				else if(type =="bc"){
					sprite.x = (stageSize.x - rect.width) / 2;
					sprite.y = (stageSize.y - rect.height);
				}
				else if(type =="br"){
					sprite.x = (stageSize.x - rect.width);
					sprite.y = (stageSize.y - rect.height);
				}
			}
		}
	}
}