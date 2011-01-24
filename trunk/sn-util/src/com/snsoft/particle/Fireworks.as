package com.snsoft.particle{
	import com.snsoft.physics.Acceleration;
	import com.snsoft.physics.Physics;
	import com.snsoft.physics.PhysicsObject;
	import com.snsoft.physics.PhysicsObjectEvent;
	
	import fl.controls.Button;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class Fireworks extends Sprite{
		
		private var physics:Physics;
		
		private var bmd:BitmapData;
		
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
			
			var btn:Button = new Button();
			btn.x = 400;
			this.addChild(btn);
			var sign:Boolean = false;
			stage.addEventListener(MouseEvent.CLICK,handler);
		}
		
		private function handler(e:Event):void {
			var a1:Acceleration = new Acceleration(0,0,100,Acceleration.TYPE_GRAVITATION);
			var a2:Acceleration = new Acceleration(50,0,0,Acceleration.TYPE_FRICTION);
			
			var x:Number = this.mouseX;
			var y:Number = this.mouseY;
			
			for(var i:int = 0;i< 20;i++){
				var rate:Number = ( i * 18 * Math.PI ) / 180;
				var ptc:Particle = new Particle(bmd);
				var po:PhysicsObject = new PhysicsObject(ptc);
				po.x = x;
				po.y = y;
				po.vx = 70 * Math.cos(rate);
				po.vy = 70 * Math.sin(rate);
				po.pushAcce(a1);
				po.pushAcce(a2);
				ptc.setPixel32(po.x,po.y,0xffffffff);
				physics.addPhysicsObject(po);
				po.addEventListener(PhysicsObjectEvent.REFRESH,handlerRefresh);	
			}
		}
		
		private function handlerRefresh(e:Event):void {
			var po:PhysicsObject = e.currentTarget as PhysicsObject;
			
			var ptc:Particle = po.linkObj as Particle;
			ptc.setPixel32(po.x,po.y,0xffffffff);
			
			var p:Point = ptc.getLastPlace();
			if(p == null || p.x < 0 || p.x > bmd.width || p.y < 0 || p.y > bmd.height){
				ptc = null;
				po.isDel = true;
				po.removeEventListener(PhysicsObjectEvent.REFRESH,handlerRefresh);	
			}
		}
	}
}