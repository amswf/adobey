package com.snsoft.util.complexEvent{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * 鼠标按下一直按着的事件，按了 delayTime 时间后，没抬起就一直响应 MOUSEEVENT_PRESSING 事件，直到抬起。
	 * 
	 * 按了不够 delayTime 时间，抬起，则响应 MouseEvent.CLICK
	 * 
	 * @author Administrator
	 * 
	 */	
	public class CplxMousePressing extends EventDispatcher{
		
		public static const MOUSEEVENT_CLICK:String = "click";
		
		public static const MOUSEEVENT_PRESSING:String = "pressing";
		
		private var dobj:DisplayObject;
		
		private var delayTime:uint;
		
		private var pressingEventInterval:uint;
		
		private var waitTimer:Timer;
		
		private var waiting:Boolean = false;
		
		private var pressingEventTimer:Timer;
		
		private var isClick:Boolean = true;
		
		public function CplxMousePressing(dobj:DisplayObject,delayTime:uint = 300,pressingEventInterval:uint = 20){
			this.dobj = dobj;	
			this.delayTime = delayTime;
			this.pressingEventInterval = pressingEventInterval;
			waitTimer = new Timer(delayTime,1);
			waitTimer.addEventListener(TimerEvent.TIMER_COMPLETE,handlerWaitTimerCmp);
			
			pressingEventTimer = new Timer(pressingEventInterval,0);
			pressingEventTimer.addEventListener(TimerEvent.TIMER,handlerpressingTimer);
			addEvent();
		}
		
		private function addEvent():void{
			dobj.addEventListener(MouseEvent.MOUSE_DOWN,handlerMouseDown);
			dobj.addEventListener(MouseEvent.MOUSE_UP,handlerMouseUp);
			dobj.addEventListener(MouseEvent.MOUSE_OUT,handlerMouseOut);
		}
		
		private function handlerMouseDown(e:Event):void{
			//trace("handlerMouseDown");
			waiting = true;
			waitTimer.stop();
			waitTimer.start();
		}
		
		private function handlerMouseOut(e:Event):void{
			//trace("handlerMouseOut");
			waitTimer.stop();
			pressingEventTimer.stop();
		}
		
		private function handlerMouseUp(e:Event):void{
			waitTimer.stop();
			pressingEventTimer.stop();
			if(waiting){
				//trace("handlerMouseUp");
				this.dispatchEvent(new Event(MouseEvent.CLICK));
			}
		}
		
		private function handlerWaitTimerCmp(e:Event):void{
			//trace("handlerWaitTimerCmp");
			waiting = false;
			pressingEventTimer.start();
		}
		
		private function handlerpressingTimer(e:Event):void{
			//trace("handlerpressingTimer");
			this.dispatchEvent(new Event(MOUSEEVENT_PRESSING));
		}
	}
}