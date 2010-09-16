package com.snsoft.room3d{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Menu extends MovieClip{
		
		/**
		 * 是否自动步进旋转 
		 */		
		private var _autoMove:Boolean = true;
		
		/**
		 * 自动步进/手动步进一对按钮之一，显示当前是否自动步进状态
		 */		
		private var autoBtn:SimpleButton;
		
		/**
		 * 自动步进/手动步进一对按钮之一，显示当前是否自动步进状态
		 */		
		private var manuBtn:SimpleButton;
		
		public function Menu()
		{
			super();
			this.addEventListener(Event.ENTER_FRAME,handlerEnterFrame);
		}
		
		/**
		 * 按钮元键进入下一帧时，初始化显示对象，及属性信息 
		 * @param e
		 * 
		 */		
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
		
		/**
		 * 自动步进按钮点击事件 
		 * @param e
		 * 
		 */		
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
		
		/**
		 * 给按钮注册事件 
		 * @param btnName
		 * 
		 */		
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
		
		/**
		 * 抛出事件 
		 * @param eventName
		 * 
		 */		
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