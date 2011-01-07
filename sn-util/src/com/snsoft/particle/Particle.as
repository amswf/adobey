package com.snsoft.particle{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Timer;
	
	public class Particle extends Sprite{
		
		private var bmd:BitmapData;
		
		private var i:int = 300;
		
		private var pv:Vector.<PtcPoint>;
		
		private var sign:Boolean = true;
		
		public function Particle(width:Number,height:Number){
			pv = new Vector.<PtcPoint>();
			bmd = new BitmapData(width,height,true,0x00000000);
			var bm:Bitmap = new Bitmap(bmd,"auto",true);
			this.addChild(bm);
			
			this.addEventListener(Event.ENTER_FRAME,handlerEnterFrame);
		}
		
		private function handlerEnterFrame(e:Event):void{
			var x:Number = 200;
			var y:Number = i;
			var pp:PtcPoint = new PtcPoint(x,y,true);
			setOldPixel32();
			bmd.setPixel32(x,y,0xffffffff);
			pv.push(pp);
			i --;
		}
		
		private function setOldPixel32():void{
			if(sign){
				sign = false;
				for(var i:int = 0;i<pv.length;i++){
					var pp:PtcPoint = pv[i];
					var color:uint = bmd.getPixel32(pp.x,pp.y);
					
					var pc:uint = 0x10 * 0x1000000;
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
				for(var i2:int = 0;i2<len;i2++){
					var dpp:PtcPoint = pv[i2];
					if(!dpp.u){
						pv.splice(i2,1);
						i2--;
						len --;
					}
				}
				sign = true;
			}
		}
	}
}