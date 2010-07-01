package com.snsoft.util{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	public class SpriteMove extends EventDispatcher{
		
		private var pointList:Vector.<Point>;
		
		private var time:int;
		
		private var sprite:Sprite;
		
		private var lineRate:Number;
		
		private var lineLength:Number;
		
		private var moveLength:Number = 2;
		
		private var timer:Timer;
		
		private var timerDelay:int;
		
		private var timerRepeatCount:int;
		
		private var pIndex:int;
		
		public function SpriteMove(sprite:Sprite,time:int,...point){
			this.sprite = sprite;
			this.time = time;
			if(point != null){
				for(var i:int =0;i<point.length;i++){
					pointList.push(point[i]);
				}
			}
		}
		
		private function start():void{
			pIndex = 0;
			if(pointList != null && pointList.length > 0 && pIndex < pointList.length){
				var p:Point = pointList[pIndex];
				sprite.x = p.x;
				sprite.y = p.y;
			}
			pIndex = 1;
			move();
		}
		
		private function move():void{
			if(pointList != null && pointList.length > 0 && pIndex < pointList.length){
				var p:Point = pointList[pIndex];
				sprite.x = p.x;
				sprite.y = p.y;
			}
		}
		
		
		private function getLineLength(p1:Point,p2:Point):Number{
			return Math.sqrt(Math.pow((p1.x - p2.x),2) + Math.pow((p1.y - p2.y),2));
		}
		
		private function getLineRate(p1:Point,p2:Point):Number{
			var rate:Number = 0;
			
			if(p2.x - p1.x == 0){
				rate = p2.y - p1.y > 0 ? 90 : -90;
			}
			else {
				rate = Math.atan((p2.y - p1.y) / (p2.x - p1.x)) * 180 / Math.PI;
			}
			return rate;
		}
	}
}