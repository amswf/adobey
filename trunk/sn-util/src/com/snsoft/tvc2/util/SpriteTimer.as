package com.snsoft.tvc2.util{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	public class SpriteTimer extends EventDispatcher{
		
		private var px:uint;
		
		private var sprite:Sprite;
		
		private var points:Vector.<Point>;
		
		private var time:uint;
		
		private var repeatCount:int;
		
		private var currentIdex:int;
		
		private var currentLength:Number;
		
		private var currentRate:Number;
		
		private var timer:Timer;
		
		private var forwardPoint:Point;
		
		public function SpriteTimer(sprite:Sprite,points:Vector.<Point>,px:uint = 1,time:uint = 1000){
			this.sprite = sprite;
			this.points = points;
			this.px = px;
			this.time = time;
			
		}
		
		public function start():void{
			currentIdex = 0;
			forwardPoint = new Point(sprite.x,sprite.y);
			moveTo();
		}
		
		public function moveTo():void{
			if(currentIdex < points.length){
				var p1:Point = forwardPoint;
				var p2:Point = points[currentIdex];
				currentLength = lineLength(p1,p2);
				currentRate = lineRate(p1,p2);
				repeatCount = int(currentLength / px);
				var delay:int = int(time / repeatCount);
				timer = new Timer(delay,repeatCount);
				timer.addEventListener(TimerEvent.TIMER,handlerTimer);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE,handlerTimerCmp);
				timer.start();
				forwardPoint = p2;
			}
			else {
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function handlerTimer(e:Event):void{
			sprite.y += px * Math.sin(currentRate);
			sprite.x += px * Math.cos(currentRate);
			trace(sprite.x,sprite.y);
		}
		
		private function handlerTimerCmp(e:Event):void{
			if(timer != null){
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER,handlerTimer);
				timer.removeEventListener(TimerEvent.TIMER,handlerTimerCmp);
			}
			currentIdex ++;
			moveTo();
		}
		
		/**
		 * 计算线长 
		 * @param p1
		 * @param p2
		 * @return 
		 * 
		 */		
		private function lineLength(p1:Point,p2:Point):Number{
			return Math.sqrt(Math.pow((p1.x - p2.x),2) + Math.pow((p1.y - p2.y),2));
		}
		
		/**
		 * 计算旋转角度 
		 * @param p1
		 * @param p2
		 * @return 
		 * 
		 */		
		private function lineRate(p1:Point,p2:Point):Number{
			var rate:Number = 0;
			
			if(p2.x - p1.x == 0){
				rate = p2.y - p1.y > 0 ? Math.PI /2 : -Math.PI /2;
			}
			else {
				rate = Math.atan((p2.y - p1.y) / (p2.x - p1.x));
			}
			return rate;
		}
	}
}