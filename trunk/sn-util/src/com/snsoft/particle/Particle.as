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
		
		public function Particle(bmd:BitmapData,defColor:uint = 0x00000000){
			this.bmd = bmd;
			this.defColor = defColor;
		}
		
		/**
		 * 设置新的粒子点 
		 * @param x
		 * @param y
		 * 
		 */		
		public function setPixel32(x:int,y:int,color:uint):void{
			setOldPixel32();
			var pp:PtcPoint = new PtcPoint(x,y,true);
			pv.push(pp);
			bmd.setPixel32(x,y,color);
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
		private function setOldPixel32():void{
			if(sign){
				sign = false;
				for(var i:int = pv.length -1;i >= 0;i--){
					var pp:PtcPoint = pv[i];
					var color:uint = bmd.getPixel32(pp.x,pp.y);
					
					var pc:uint = 0x08 * 0x1000000;
					var c:uint;
					if( color <= pc){
						c = color & 0x00ffffff;
						pp.u = false;
					}
					else {
						c = color - pc;
					}
					bmd.setPixel32(pp.x,pp.y,c);
				}
				
				var len:int = pv.length;
				
				var sign:Boolean = true;
				
				while(pv.length > 0 && !(sign = pv[0].u)){
					pv.splice(0,1);
				}
				sign = true;
			}
		}
	}
}