package com.snsoft.room3d{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Menu extends MovieClip{
		public function Menu()
		{
			super();
			this.addEventListener(Event.ENTER_FRAME,handlerEnterFrame);
		}
		
		private function handlerEnterFrame(e:Event):void{
			this.removeEventListener(Event.ENTER_FRAME,handlerEnterFrame);			
			this.setButtonEvent("left");
			this.setButtonEvent("right");
			this.setButtonEvent("up");
			this.setButtonEvent("down");
			this.setButtonEvent("def");
			this.setButtonEvent("zoomIn");
			this.setButtonEvent("zoomOut");
		}
		
		private function setButtonEvent(btnName:String):void{
			var btn:MovieClip = this.getChildByName(btnName) as MovieClip;
			trace(btn);
			btn.buttonMode = true;
			btn.mouseEnabled = true;
			btn.mouseChildren = false;
			btn.addEventListener(MouseEvent.MOUSE_DOWN,handlerMouseDown);
			btn.addEventListener(MouseEvent.MOUSE_UP,handlerMouseUp);
			btn.addEventListener(MouseEvent.MOUSE_OUT,handlerMouseUp);
			
			function handlerMouseDown(e:Event):void{
				dispatchEvents(btnName+"_DOWN");
			}	
			
			function handlerMouseUp(e:Event):void{
				dispatchEvents(btnName+"_UP");
			}
		}
		
		private function dispatchEvents(eventName:String):void{
			this.dispatchEvent(new Event(eventName));
		}
	}
}