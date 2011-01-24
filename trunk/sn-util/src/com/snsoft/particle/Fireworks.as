package com.snsoft.particle{
	import com.snsoft.physics.Acceleration;
	import com.snsoft.physics.Physics;
	import com.snsoft.physics.PhysicsObject;
	import com.snsoft.physics.PhysicsObjectEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	public class Fireworks extends Sprite{
		
		private var physics:Physics;
		
		private var bmd:BitmapData;
		
		private var sign:Boolean = true;
		
		public function Fireworks()
		{
			init();
			super();
		}
		
		private function init():void{
			physics = new Physics();
			this.addChild(physics);
			bmd = new BitmapData(800,600,true,0x00000000);
			var bm:Bitmap = new Bitmap(bmd,"auto",true);
			this.addChild(bm);
			
			var sign:Boolean = false;
			
			var timer:Timer = new Timer(100,0);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER,handler);
		}
		
		private function handler(e:Event):void {
			
			var a1:Acceleration = new Acceleration(0,0,100,Acceleration.TYPE_GRAVITATION);
			
			var x:Number = this.mouseX;
			var y:Number = this.mouseY;
			
			var blue:uint = uint(Math.random() * 0xff);
			var green:uint = uint(Math.random() * 0xff) << (2 * 4);
			var red:uint = uint(Math.random() * 0xff) << (4 * 4);
			var color:uint = 0xff000000 + red + green + blue;
			
			
			var maxHeight:Number = 200 * Math.random();
			var ptc:Particle = new Particle(bmd,color,0);
			var fwlo:FireWorksLinkObject = new FireWorksLinkObject(ptc,maxHeight);
			var po:PhysicsObject = new PhysicsObject(fwlo);
			po.x = bmd.width * Math.random();
			po.y = bmd.height;
			po.vx = -15 + 30 * Math.random();
			po.vy = -300 - 100 * Math.random();
			po.pushAcce(a1);			
			ptc.setPixel32(po.x,po.y);
			physics.addPhysicsObject(po);
			po.addEventListener(PhysicsObjectEvent.REFRESH,handlerShellRefresh);	
			
		}
		
		private function handlerShellRefresh(e:Event):void{
			if(sign){
				sign = false;
				var po:PhysicsObject = e.currentTarget as PhysicsObject;
				var fwlo:FireWorksLinkObject = po.linkObj as FireWorksLinkObject;
				var maxHeight:Number = fwlo.maxHeight;
				var ptc:Particle = fwlo.particle;
				ptc.setPixel32(po.x,po.y);
				if(po.y <= maxHeight){
					ptc = null;
					po.isDel = true;
					po.removeEventListener(PhysicsObjectEvent.REFRESH,handlerRefresh);	
					var blue:uint = uint(Math.random() * 0xff);
					var green:uint = uint(Math.random() * 0xff) << (2 * 4);
					var red:uint = uint(Math.random() * 0xff) << (4 * 4);
					var color:uint = 0xff000000 + red + green + blue;
					shell(po.x,po.y,color);
				}
				sign = true;
			}
		}
		
		private function shell(x:Number,y:Number,color:uint):void{
			var a1:Acceleration = new Acceleration(0,0,100,Acceleration.TYPE_GRAVITATION);
			var a2:Acceleration = new Acceleration(50,0,0,Acceleration.TYPE_FRICTION);
			
			for(var i:int = 0;i< 20;i++){
				var rate:Number = ( i * 18 * Math.PI ) / 180;
				var ptc:Particle = new Particle(bmd,color);
				var po:PhysicsObject = new PhysicsObject(ptc);
				po.x = x;
				po.y = y;
				po.vx = 70 * Math.cos(rate);
				po.vy = 70 * Math.sin(rate);
				po.pushAcce(a1);
				po.pushAcce(a2);
				
				ptc.setPixel32(po.x,po.y);
				physics.addPhysicsObject(po);
				po.addEventListener(PhysicsObjectEvent.REFRESH,handlerRefresh);	
			}
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerRefresh(e:Event):void {
			var po:PhysicsObject = e.currentTarget as PhysicsObject;
			
			var ptc:Particle = po.linkObj as Particle;
			ptc.setPixel32(po.x,po.y);
			
			var p:Point = ptc.getLastPlace();
			if(p == null || p.x < 0 || p.x > bmd.width || p.y < 0 || p.y > bmd.height){
				ptc = null;
				po.isDel = true;
				po.removeEventListener(PhysicsObjectEvent.REFRESH,handlerRefresh);	
			}
		}
	}
}