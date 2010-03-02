package com.snsoft.map
{
	import com.snsoft.map.util.MapUtil;
	import com.snsoft.util.ImageLoader;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class MapBackImage extends MapComponent
	{
		//图片加载器
		private var imageLoader:ImageLoader = new ImageLoader();
		
		//图片位图数据
		private var mapImage:BitmapData = null;
		
		//图片地址
		private var _imageUrl:String = null;
		
		//缩放系数
		private var _scalePoint:Point = new Point(1,1);
		
		public function MapBackImage(imageUrl:String = null,scalePoint:Point = null)
		{
			super();
			this.imageUrl = imageUrl;
			if(scalePoint != null){
				this.scalePoint = scalePoint;
			}
			imageLoader.addEventListener(Event.COMPLETE,handlerLoadImageComplete);
		}
		
		private function handlerLoadImageComplete(e:Event):void{
			var bm:Bitmap = new Bitmap(imageLoader.bitmapData);
			
			var bmP:Point = new Point(bm.width,bm.height);
			var sbmP:Point = MapUtil.creatSaclePoint(bmP,this.scalePoint);
			var mc:MovieClip = new MovieClip();
			mc.addChild(bm); 
			mc.width = sbmP.x;
			mc.height = sbmP.y;
			this.width = sbmP.x;
			this.height = sbmP.y;
			this.addChild(mc);
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * 重写方法
		 * @return 
		 * 
		 */		
		override protected function draw():void{
			if(this.imageUrl != null){
				imageLoader.loadImage(this.imageUrl);
			}
		}

		public function get imageUrl():String
		{
			return _imageUrl;
		}

		public function set imageUrl(value:String):void
		{
			_imageUrl = value;
		}

		public function get scalePoint():Point
		{
			return _scalePoint;
		}

		public function set scalePoint(value:Point):void
		{
			_scalePoint = value;
		}


	}
}