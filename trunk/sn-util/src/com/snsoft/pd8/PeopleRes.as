package com.snsoft.pd8{
	import com.snsoft.util.images.ImageLoader;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 八方向图片 
	 * @author Administrator
	 * 
	 */	
	public class PeopleRes extends EventDispatcher{
		
		/**
		 * 八方向图片存储 
		 */		
		private var dvv:Vector.<Vector.<BitmapData>>;
		
		/**
		 * 外部图片 
		 */		
		private var imageUrl:String;
		
		/**
		 * 
		 * 
		 */		
		public function PeopleRes(imageUrl:String){
			this.imageUrl = imageUrl;
		}
		
		/**
		 * 加载图片
		 * 
		 */		
		public function load():void{
			//初始化八方向图片存储
			dvv = new Vector.<Vector.<BitmapData>>();
			for(var i:int = 0;i<8;i++){
				dvv.push(new Vector.<BitmapData>());
			}
			
			//加载图片
			var il:ImageLoader = new ImageLoader();
			il.addEventListener(Event.COMPLETE,handlerLoadImgCmp);
			il.loadImage(imageUrl);
		}
		
		/**
		 * 事件  加载图片成功
		 * @param e
		 * 
		 */		
		private function handlerLoadImgCmp(e:Event):void{
			var il:ImageLoader = e.currentTarget as ImageLoader;
			var ilbmd:BitmapData = il.bitmapData;
			
			var mw:int = ilbmd.width;
			var mh:int = ilbmd.height;
			
			var w:int = mw / 8;
			var h:int = mh / 8;
			for(var i:int = 0;i < 8;i ++){
				for(var j:int = 0;j < 8;j ++){
					var x:int = j * w;
					var y:int = i * h;
					var bmd:BitmapData = new BitmapData(w,h,true,0x00000000);
					var rect:Rectangle = new Rectangle(x,y,w,h);
					var destPoint:Point = new Point();
					bmd.copyPixels(ilbmd,rect,destPoint,null,null,true);
					dvv[i].push(bmd);
				}
			}
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * 获得动作图片
		 * @param direction
		 * @param index
		 * @return 
		 * 
		 */		
		public function getImage(direction:int,index:int):BitmapData{
			return dvv[direction][index];
		}
	}
}