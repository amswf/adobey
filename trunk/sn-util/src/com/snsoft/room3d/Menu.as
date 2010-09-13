package com.snsoft.room3d{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Menu extends MovieClip{
		
		private var _autoMove:Boolean = true;
		
		private var autoBtn:SimpleButton;
		
		private var manuBtn:SimpleButton;
		
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
			
			autoBtn = this.getChildByName("auto") as SimpleButton;
			autoBtn.addEventListener(MouseEvent.CLICK,handlerAutoMouseClick);
			
			manuBtn = this.getChildByName("manu") as SimpleButton;
			manuBtn.addEventListener(MouseEvent.CLICK,handlerAutoMouseClick);
			manuBtn.visible = false;
		}	
		
		private function handlerAutoMouseClick(e:Event):void{
			if(autoMove){
				autoMove = false;
			}
			else{
				autoMove = true;
			}
			manuBtn.visible = !autoMove;
			autoBtn.visible = autoMove;
			dispatchEvents("auto_DOWN");
		}
		
		private function setButtonEvent(btnName:String):void{
			var btn:SimpleButton = this.getChildByName(btnName) as SimpleButton;
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

		public function get autoMove():Boolean
		{
			return _autoMove;
		}

		public function set autoMove(value:Boolean):void
		{
			_autoMove = value;
		}

	}
}