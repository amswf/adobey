package com.snsoft.particle{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	/**
	 * 粒子运动 
	 * @author Administrator
	 * 
	 */	
	public class Particle{
		
		private var bmd:BitmapData;
		
		private var i:int = 300;
		
		private var pv:Vector.<PtcPoint> = new Vector.<PtcPoint>();
		
		private var sign:Boolean = true;
		
		private var defColor:uint;
		
		private var count:uint = 0;
		
		private var maxCount:uint = 0;
		
		private var alpha:uint;
		
		public function Particle(bmd:BitmapData,defColor:uint = 0x00000000,maxCount:uint = 50){
			this.bmd = bmd;
			this.defColor = defColor;
			this.maxCount = maxCount;
		}
		
		/**
		 * 设置新的粒子点 
		 * @param x
		 * @param y
		 * 
		 */		
		public function setPixel32(x:int,y:int,color:uint):void{
			if(sign){
				sign = false;
				count ++;
				
				
				var pc:uint = 0x0f;
				if(count >= maxCount){
					if(alpha < pc){
						alpha = 0x00;
					}
					else {
						alpha -= pc;
					}
				}
				else {
					alpha = color >>> (6 * 4);
				}
				 
				var c:uint = alpha << (6 * 4);
				c = c + (color & 0x00ffffff); 
				setOldPixel32(c);
				var pp:PtcPoint = new PtcPoint(x,y,true);
				pv.push(pp);
				bmd.setPixel32(x,y,c);
				sign = true;
			}
		}
		
		/**
		 * 获得最后一个点坐标 
		 * @return 
		 * 
		 */		
		public function getLastPlace():Point{
			var p:Point = null;
			if(pv.length >= 0){
				p = new Point(pv[0].x,pv[0].y); 
			}
			return p;
		}
		
		/**
		 * 设置历史粒子点 
		 * 
		 */		
		private function setOldPixel32(color:uint):void{
			var alpha:uint = color >>> (6 * 4);
			var pc:uint = 0x08;
			for(var i:int = pv.length -1;i >= 0;i--){
				var pp:PtcPoint = pv[i];
				if( alpha <= pc){
					alpha = 0x00;
					pp.u = false;
				}
				else {
					alpha -= pc;
				}
				var c:uint = alpha << (6 * 4);
				c = c + (color & 0x00ffffff);
				bmd.setPixel32(pp.x,pp.y,c);
			}
			var len:int = pv.length;
			var sign:Boolean = true;
			while(pv.length > 0 && !(sign = pv[0].u)){
				pv.splice(0,1);
			}
		}
	}
}