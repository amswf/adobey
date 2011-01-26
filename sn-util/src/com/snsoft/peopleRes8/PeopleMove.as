package com.snsoft.peopleRes8{
	import com.snsoft.util.SpriteUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	public class PeopleMove extends Sprite{
		
		private static const LEFT:int = 37;
		
		private static const FRONT:int = 38;
		
		private static const RIGHT:int = 39;
		
		private static const BACK:int = 40;
		
		
		
		private var leftDown:int = 0;
		
		private var frontDown:int = 2;
		
		private var rightDown:int = 4;
		
		private var backDown:int = 8;
		
		private var keyCodeV:Vector.<int> = new Vector.<int>();
		
		private var peopleRes:PeopleRes;
		
		private var imageIndex:int = 0;
		
		private var imageLayer:Sprite;
		
		public function PeopleMove(peopleRes:PeopleRes)
		{
			this.peopleRes = peopleRes;
			this.addEventListener(Event.ADDED_TO_STAGE,handlerAddToStage);
		}
		
		/**
		 * 
		 * @param keyCode
		 * 
		 */		
		private function pushKeyCode(keyCode:int):void{
			keyCodeV.push(keyCode);
			if(keyCodeV.length >2){
				keyCodeV.splice(0,keyCodeV.length - 2);
			}
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerAddToStage(e:Event):void{
			imageLayer = new Sprite();
			this.addChild(imageLayer);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,handlerKeyDown);	
			stage.addEventListener(KeyboardEvent.KEY_UP,handlerKeyUp);
			keyCodeV.push(-1,-1);
			this.addEventListener(Event.ENTER_FRAME,handlerEnterFrame);
		}
		
		private function handlerEnterFrame(e:Event):void{
			
			var key1:int = tranKeyCode(keyCodeV[0]);
			var key2:int = tranKeyCode(keyCodeV[1]);
			
			var code:int = -1;
			
			if(key1 >= 0 || key2 >= 0){
				code = 0;
			}
			if(key1 >= 0){
				code += key1;
			}
			if(key2 >= 0){
				code += key2;
			}
			if((key1 == 0 && key2 == 6) || (key1 == 6 && key2 == 0)){
				code += 8;
			}
			if(key1 >= 0 && key2 >= 0){
				code = code / 2;
			}
			var bmd:BitmapData;
			if(code >= 0){
				trace(code);
				
				var direction:int = Direction8.tranDirection(code);
				var index:int = getNextIndex();
				bmd = peopleRes.getImage(direction,index);
			}
			else{
				bmd = peopleRes.getImage(0,0);
			}
			SpriteUtil.deleteAllChild(imageLayer);
			var bm:Bitmap = new Bitmap(bmd,"auto",true);
			imageLayer.addChild(bm);
		}
		
		private function getNextIndex():int{
			imageIndex ++;
			if(imageIndex >= 8){
				imageIndex = 0;
			}
			return imageIndex;
		}
		
		/**
		 * 
		 * @param keyCode
		 * @return 
		 * 
		 */		
		private function tranKeyCode(keyCode:int):int{
			if(keyCode == LEFT){
				return 0;
			}
			else if(keyCode == FRONT){
				return 2;
			}
			else if(keyCode == RIGHT){
				return 4;
			}
			else if(keyCode == BACK){
				return 6;
			}
			return -1;
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerKeyDown(e:KeyboardEvent):void{
			if(e.keyCode != keyCodeV[0] && e.keyCode != keyCodeV[1]){
				pushKeyCode(e.keyCode);
			}
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerKeyUp(e:KeyboardEvent):void{
			if(e.keyCode == keyCodeV[0]){
				keyCodeV[0] = -1;
			}
			else if(e.keyCode == keyCodeV[1]){
				keyCodeV[1] = -1;
			}
		}
	}
}