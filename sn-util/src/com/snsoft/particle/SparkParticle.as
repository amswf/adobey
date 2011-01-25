package com.snsoft.particle{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	/**
	 * 火花粒子 
	 * @author Administrator
	 * 
	 */	
	public class SparkParticle{
		
		/**
		 * 粒子运动区域
		 */		
		private var bmd:BitmapData;
		
		/**
		 * 粒子拖影效果粒子位置列表
		 */		
		private var pv:Vector.<PtcPoint> = new Vector.<PtcPoint>();
		
		/**
		 * 粒子运动互斥标记 
		 */		
		private var sign:Boolean = true;
		
		/**
		 * 粒子颜色 
		 */		
		private var _color:uint;
		
		/**
		 * 刷新物理状态次数 ，和 maxCount 对应
		 */		
		private var count:uint = 0;
		
		/**
		 * 最大 刷新物理状态次数， 和 count 对应
		 */		
		private var maxCount:uint = 0;
		
		/**
		 * 透明度，透明度为0时，就说明这个粒子消失了 
		 */		
		private var alpha:uint;
		
		/**
		 * 是否停止，不再有新的物理状态 
		 */		
		private var _isStop:Boolean = false;
		
		/**
		 * 物理状态和特效是否全部完成 
		 */		
		private var _isCmp:Boolean = false;
		
		public function SparkParticle(bmd:BitmapData,color:uint = 0x00000000,maxCount:uint = 50){
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
		public function moveTo(x:int,y:int):void{
			if(sign){
				sign = false;
				count ++;
				var pc:uint = 0x0f;
				
				//当 刷新物理状态次数大于最大 刷新物理状态次数时，粒子运动停止
				if(count >= maxCount && maxCount > 0){
					isStop = true;
				}
				
				//当粒子运动停止后，粒子透明度渐变为0
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
				
				//计算渐变后的颜色值
				var c:uint = alpha << (6 * 4);
				c = c + (color & 0x00ffffff); 
				
				//粒子没有停止时刷新物理位置
				if(!isStop){
					var pp:PtcPoint = new PtcPoint(x,y,true);
					pv.push(pp);
					bmd.setPixel32(x,y,c);
				}
				else {
					if(pv.length == 0){
						//停止状态，并且粒子拖影效果粒子位置列表为空时，说明粒子运动完成要消失了
						isCmp = true;
					}
				}
				//粒子拖影效果粒子位置列表，更新显示
				setOldPixel32(c);
				sign = true;
			}
		}
		
		/**
		 * 粒子拖影效果粒子位置列表，更新显示
		 * 
		 */		
		private function setOldPixel32(color:uint):void{
			var alpha:uint = color >>> (6 * 4);
			var pc:uint = 0x08;
			
			//粒子拖影效果粒子位置列表，按先后顺序，设置递减透明度，就实现了拖影效果
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
			var sign:Boolean = true;
			//删除消失的拖影点
			while(pv.length > 0 && !(sign = pv[0].u)){
				pv.splice(0,1);
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