package com.snsoft.physics{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * 物理运动引擎 
	 * @author Administrator
	 * 
	 */	
	public class Physics extends Sprite{
		
		/**
		 * 一像素的距离换算成米
		 */		
		private static const PIXEL_SIZE:Number = 0.28 * 0.001;
		
		/**
		 * 一帧的时间 
		 */		
		private var frame_time:Number;
		
		/**
		 * 物理运动单元列表
		 */		
		private var pov:Vector.<PhysicsObject> = new Vector.<PhysicsObject>();
		
		/**
		 * 刷新运动时的多线程互斥标记 
		 */		
		private var sign:Boolean = true;
		
		/**
		 * 
		 * 
		 */		
		public function Physics(){
			this.addEventListener(Event.ENTER_FRAME,handlerEnterFrame);	
		}
		
		/**
		 * 主方法
		 * @param e
		 * 
		 */		
		private function handlerEnterFrame(e:Event):void{
			if(sign){
				sign = false;
				
				frame_time = 1 / stage.frameRate;
				var fd2:Number = frame_time * frame_time;
				trace(pov.length);
				//刷新物理单元运动状态
				for(var i:int = 0;i<this.pov.length;i++){
					var po:PhysicsObject = getPhysicsObject(i);
					if(!po.isDel){
						var c:Number = Math.sqrt(po.vx * po.vx + po.vy * po.vy);
						var a:Number = 0;
						var b:Number = 0;
						if(c > 0){
							a = -po.vx / c;
							b = -po.vy / c;
						}
						var ax:Number = 0;
						var ay:Number = 0;
						
						for(var j:int = 0;j<po.acceLen();j ++){
							var acce:Acceleration = po.getAcceByIndex(j);
							if(acce.type == Acceleration.TYPE_GRAVITATION){
								ax += acce.ax;
								ay += acce.ay;
							}
							else if(acce.type == Acceleration.TYPE_FRICTION){
								var signx:Number = 0;
								if(po.vx > 0){
									signx = -1;
								}
								else if(po.vx < 0){
									signx = 1;
								}
								
								var signy:Number = 0;
								if(po.vy > 0){
									signy = -1;
								}
								else if(po.vy < 0){
									signy = 1;
								}
								
								ax += acce.a * a;
								ay += acce.a * b;
							}
						}
						var px:Number = frame_time * po.vx + ax * fd2 / 2;
						var py:Number = frame_time * po.vy + ay * fd2 / 2;
						
						po.x += px;
						po.y += py;
						
						po.vx += ax * frame_time;
						po.vy += ay * frame_time;
						po.dispatchEvent(new Event(PhysicsObjectEvent.REFRESH));
					}
				}
				
				//把已删除的物理单元从列表中去掉
				for(var i2:int = 0;i2 < this.pov.length;i2 ++){
					var po2:PhysicsObject = getPhysicsObject(i2);
					if(po2.isDel){
						this.pov.splice(i2,1);
						i2 --;
					}
				}
				sign = true;
			}
		}
		
		/**
		 * 添加物理运动单元  
		 * @param po
		 * 
		 */		
		public function addPhysicsObject(po:PhysicsObject):void{
			pov.push(po);
		}
		
		/**
		 * 获得物理运动单元 
		 * @param i
		 * @return 
		 * 
		 */		
		public function getPhysicsObject(i:int):PhysicsObject{
			return pov[i];
		}

	}
}