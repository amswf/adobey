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
	
	/**
	 * 礼花主类 
	 * @author Administrator
	 * 
	 */	
	public class Fireworks extends Sprite{
		
		/**
		 * 物理引擎 
		 */		
		private var physics:Physics;
		
		/**
		 * 物理运动区域
		 */		
		private var bmd:BitmapData;
		
		/**
		 * 刷新炮弹互斥标记
		 */		
		private var sign:Boolean = true;
		
		public function Fireworks()
		{
			init();
			super();
		}
		
		/**
		 * 初始化 
		 * 
		 */		
		private function init():void{
			//创建物理引擎
			physics = new Physics();
			this.addChild(physics);
			//创建物理运动区域
			bmd = new BitmapData(800,600,true,0x00000000);
			var bm:Bitmap = new Bitmap(bmd,"auto",true);
			this.addChild(bm);
			
			//创建炮弹计时器
			var timer:Timer = new Timer(100,0);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER,handler);
		}
		
		/**
		 * 创建炮弹 
		 * @param e
		 * 
		 */		
		private function handler(e:Event):void {
			
			//加速度
			var a1:Acceleration = new Acceleration(0,0,100,Acceleration.TYPE_GRAVITATION);
			//创建随机颜色
			var blue:uint = uint(Math.random() * 0xff);
			var green:uint = uint(Math.random() * 0xff) << (2 * 4);
			var red:uint = uint(Math.random() * 0xff) << (4 * 4);
			var color:uint = 0xff000000 + red + green + blue;
			//创建随机礼花的最大高度
			var maxHeight:Number = 200 * Math.random();
			//创建一个粒子运动特效
			var ptc:SparkParticle = new SparkParticle(bmd,color,0);
			//创建物理运动单元的链接对象
			var fwlo:FireWorksLinkObject = new FireWorksLinkObject(ptc,maxHeight);
			//创建物理运动单元
			var po:PhysicsObject = new PhysicsObject(fwlo);
			po.x = bmd.width * Math.random();
			po.y = bmd.height;
			po.vx = -30 + 60 * Math.random();
			po.vy = -400 - 100 * Math.random();
			po.pushAcce(a1);
			
			//刷新粒子位置
			ptc.moveTo(po.x,po.y);
			//把物理单元添加到物理引擎中
			physics.addPhysicsObject(po);
			//注册运动事件
			po.addEventListener(PhysicsObjectEvent.REFRESH,handlerShellRefresh);	
		}
		
		/**
		 * 当炮弹刷新了位置 
		 * @param e
		 * 
		 */		
		private function handlerShellRefresh(e:Event):void{
			if(sign){
				sign = false;
				var po:PhysicsObject = e.currentTarget as PhysicsObject;
				var fwlo:FireWorksLinkObject = po.linkObj as FireWorksLinkObject;
				var maxHeight:Number = fwlo.maxHeight;
				var ptc:SparkParticle = fwlo.particle;
				ptc.moveTo(po.x,po.y);
				//当炮弹到达指定高度，炮弹消失,然后创建爆炸后的火花
				if(po.y <= maxHeight && !ptc.isStop){
					var color:uint = ptc.color;
					ptc.isStop = true;
					createSparks(po.x,po.y,color);
				}
				sign = true;
			}
		}
		
		/**
		 * 创建爆炸后的火花 
		 * @param x
		 * @param y
		 * @param color
		 * 
		 */		
		private function createSparks(x:Number,y:Number,color:uint):void{
			//重力加速度
			var a1:Acceleration = new Acceleration(0,0,100,Acceleration.TYPE_GRAVITATION);
			//空气阻力加速度
			var a2:Acceleration = new Acceleration(50,0,0,Acceleration.TYPE_FRICTION);
			//360 分成 20份，每隔18度方向创建粒子运动
			for(var i:int = 0;i< 20;i++){
				var rate:Number = ( i * 18 * Math.PI ) / 180;
				var ptc:SparkParticle = new SparkParticle(bmd,color,50);
				var po:PhysicsObject = new PhysicsObject(ptc);
				po.x = x;
				po.y = y;
				po.vx = 70 * Math.cos(rate);
				po.vy = 70 * Math.sin(rate);
				po.pushAcce(a1);
				po.pushAcce(a2);
				ptc.moveTo(po.x,po.y);
				physics.addPhysicsObject(po);
				po.addEventListener(PhysicsObjectEvent.REFRESH,handlerSparksRefresh);	
			}
		}
		
		/**
		 * 当火花刷新了位置 
		 * @param e
		 * 
		 */		
		private function handlerSparksRefresh(e:Event):void {
			var po:PhysicsObject = e.currentTarget as PhysicsObject;
			var ptc:SparkParticle = po.linkObj as SparkParticle;
			ptc.moveTo(po.x,po.y);
			if(ptc.isCmp){
				//当火花完成运动和特效，删除火花物理运动单元，及去除物理运动单元的事件侦听
				ptc = null;
				po.isDel = true;
				po.removeEventListener(PhysicsObjectEvent.REFRESH,handlerSparksRefresh);
			}
			
		}
	}
}