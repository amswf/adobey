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
		
		private var _color:uint;
		
		private var count:uint = 0;
		
		private var maxCount:uint = 0;
		
		private var alpha:uint;
		
		private var _isStop:Boolean = false;
		
		private var _isCmp:Boolean = false;
		
		public function Particle(bmd:BitmapData,color:uint = 0x00000000,maxCount:uint = 50){
			this.bmd = bmd;
			this.color = color;
			this.maxCount = maxCount;
		}
		
		/**
		 * 设置新的粒子点 
		 * @param x
		 * @param y
		 * 
		 */		
		public function setPixel32(x:int,y:int):void{
			if(sign){
				sign = false;
				count ++;
				var pc:uint = 0x0f;
				
				if(count >= maxCount && maxCount > 0){
					isStop = true;
				}
				
				if(isStop){
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
				
				if(!isStop){
					var pp:PtcPoint = new PtcPoint(x,y,true);
					pv.push(pp);
					bmd.setPixel32(x,y,c);
				}
				else {
					if(pv.length == 0){
						isCmp = true;
					}
				}
				setOldPixel32(c);
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
			if(pv.length == 0){
				isStop = true;
			}
		}
		
		public function get color():uint
		{
			return _color;
		}
		
		public function set color(value:uint):void
		{
			_color = value;
		}
		
		public function get isStop():Boolean
		{
			return _isStop;
		}
		
		public function set isStop(value:Boolean):void
		{
			_isStop = value;
		}

		public function get isCmp():Boolean
		{
			return _isCmp;
		}

		public function set isCmp(value:Boolean):void
		{
			_isCmp = value;
		}

		
	}
}