package com.snsoft.util{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	/**
	 * 把一个元件按指定的点列表折线移动位置
	 * 
	 * 移动完成后触发完成事件 Event.COMPLETE
	 *  
	 * @author Administrator
	 * 
	 */	
	public class SpriteMove extends EventDispatcher{
		
		private var points:Vector.<Point>;
		
		private var time:int;
		
		private var sprite:Sprite;
		
		private var lineRate:Number;
		
		private var lineLength:Number;
		
		private var moveLength:Number = 2;
		
		private var moveLengthX:Number = 0;
		
		private var moveLengthY:Number = 0;
		
		private var timer:Timer;
		
		private var timerDelay:int;
		
		private var timerRepeatCount:int;
		
		private var pIndex:int;
		
		private var startPoint:Point;
		
		private var endPoint:Point;
		
		public function SpriteMove(sprite:Sprite,time:int,points:Vector.<Point>){
			this.sprite = sprite;
			this.time = time;
			this.points = points
		}
		
		/**
		 * 开始移动 
		 * 
		 */		
		public function start():void{
			pIndex = 0;
			if(points != null && points.length > 0 && pIndex < points.length){
				var p:Point = points[pIndex];
				sprite.x = p.x;
				sprite.y = p.y;
				pIndex = 1;
				move();
			}
			else{
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		/**
		 * 移动到下一个点的数据设置和启动移动 
		 * 
		 */		
		private function move():void{
			if(points != null && points.length > 0 && pIndex < points.length){
				endPoint = points[pIndex];
				startPoint = points[pIndex - 1];
				lineRate = this.getLineRate(startPoint,endPoint);
				lineLength = this.getLineLength(startPoint,endPoint);
				this.moveLengthX = moveLength * Math.cos(lineRate);
				this.moveLengthY = moveLength * Math.sin(lineRate);
				var repeatCount:int = lineLength / moveLength;
				this.timer = new Timer(this.time,repeatCount);
				this.timer.addEventListener(TimerEvent.TIMER,handlerTimer);
				this.timer.addEventListener(TimerEvent.TIMER_COMPLETE,handlerTimerCmp);
				this.timer.start();
				moving();
			}
			else{
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		/**
		 * 移动完成
		 * @param e
		 * 
		 */		
		private function handlerTimerCmp(e:Event):void{
			sprite.x = endPoint.x;
			sprite.y =  endPoint.y;
			pIndex ++;
			this.timer.removeEventListener(TimerEvent.TIMER,handlerTimer);
			this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE,handlerTimerCmp);
			move();
		}
		
		/**
		 * 移动事件 
		 * @param e
		 * 
		 */		
		private function handlerTimer(e:Event):void{
			moving();
		}
		
		/**
		 * 移动物体 
		 * 
		 */		
		private function moving():void{
			sprite.x += moveLengthX;
			sprite.y +=  moveLengthY;
		}
		
		/**
		 * 计算移动初始点到结束点的距离 
		 * @param p1
		 * @param p2
		 * @return 
		 * 
		 */		
		private function getLineLength(p1:Point,p2:Point):Number{
			return Math.sqrt(Math.pow((p1.x - p2.x),2) + Math.pow((p1.y - p2.y),2));
		}
		
		/**
		 * 计算移动初始点到结束点的斜率 
		 * @param p1
		 * @param p2
		 * @return 
		 * 
		 */		
		private function getLineRate(p1:Point,p2:Point):Number{
			var rate:Number = 0;
			
			if(p2.x - p1.x == 0){
				rate = p2.y - p1.y > 0 ? Math.PI / 2 : -Math.PI / 2;
			}
			else {
				rate = Math.atan((p2.y - p1.y) / (p2.x - p1.x));
			}
			return rate;
		}
	}
}