package com.snsoft.physics{
	import flash.display.Sprite;
	import flash.events.Event;

	public class Physics extends Sprite{
		
		/**
		 * 一像素的距离换算成米
		 */		
		private static const PIXEL_SIZE:Number = 0.28 * 0.001;
		
		private var frame_time:Number;
		
		
		
		public function Physics(){
			this.addEventListener(Event.ENTER_FRAME,handlerEnterFrame);	
		}
		
		private function handlerEnterFrame(e:Event):void{
			frame_time = 1 / stage.frameRate;
			
			var fd2:Number = frame_time * frame_time;
			for(var i:int = 0;i<this.numChildren;i++){
				var po:PhysicsObject = this.getChildAt(i) as PhysicsObject;
				var c:Number = Math.sqrt(po.vx * po.vx + po.vy * po.vy);
				var a:Number = 0;
				var b:Number = 0;
				if(c > 0){
					a = -po.vx / c;
					b = -po.vy / c;
				}
				var ax:Number = 0;
				var ay:Number = 0;
				
				var sign:Boolean = false;
				for(var j:int = 0;j<po.acceLen();j ++){
					var acce:Acceleration = po.getAcceByIndex(j);
					if(acce.type == Acceleration.TYPE_GRAVITATION){
						ax += acce.ax;
						ay += acce.ay;
					}
					else if(acce.type == Acceleration.TYPE_FRICTION){
						ax += acce.a * a;
						ay += acce.a * b;
					}
				}
				
				
				var px:Number = frame_time * po.vx + ax * fd2 / 2;
				var py:Number = frame_time * po.vy + ay * fd2 / 2;
				if(Math.abs(px) < 1){
					px = 0;
				}
				if(Math.abs(py) < 1){
					py = 0;
				}
				po.x += px;
				po.y += py;
				
				po.vx += ax * frame_time;
				po.vy += ay * frame_time;
				if(Math.abs(po.vx * frame_time) < 1){
					po.vx = 0;
				}
				if(Math.abs(po.vy * frame_time) < 1){
					po.vy = 0;
				}
			}
		}
		
		public function addPhysicsChild(po:PhysicsObject):void{
			this.addChild(po);
		}
	}
}