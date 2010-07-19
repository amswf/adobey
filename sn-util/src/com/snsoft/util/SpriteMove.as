package com.snsoft.util{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	public class SpriteMove extends EventDispatcher{
		
		private var pointList:Vector.<Point>;
		
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
		
		public function SpriteMove(sprite:Sprite,time:int,...point){
			this.sprite = sprite;
			this.time = time;
			if(point != null){
				pointList = new Vector.<Point>();
				for(var i:int =0;i<point.length;i++){
					pointList.push(point[i]);
				}
			}
		}
		
		public function start():void{
			pIndex = 0;
			if(pointList != null && pointList.length > 0 && pIndex < pointList.length){
				var p:Point = pointList[pIndex];
				sprite.x = p.x;
				sprite.y = p.y;
				pIndex = 1;
				move();
			}
		}
		
		private function move():void{
			if(pointList != null && pointList.length > 0 && pIndex < pointList.length){
				endPoint = pointList[pIndex];
				startPoint = pointList[pIndex - 1];
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
		}
		
		private function handlerTimerCmp(e:Event):void{
			sprite.x = endPoint.x;
			sprite.y =  endPoint.y;
			pIndex ++;
			move();
		}
		
		private function handlerTimer(e:Event):void{
			moving();
		}
		
		private function moving():void{
			sprite.x += moveLengthX;
			sprite.y +=  moveLengthY;
		}
		
		
		private function getLineLength(p1:Point,p2:Point):Number{
			return Math.sqrt(Math.pow((p1.x - p2.x),2) + Math.pow((p1.y - p2.y),2));
		}
		
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