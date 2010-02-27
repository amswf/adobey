package com.snsoft.map
{
	import com.snsoft.util.ImageLoader;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	public class MapBackImage extends MapComponent
	{
		//图片加载器
		private var imageLoader:ImageLoader = new ImageLoader();
		
		//图片位图数据
		private var mapImage:BitmapData = null;
		
		//图片地址
		private var _imageUrl:String = null;
		
		public function MapBackImage(imageUrl:String)
		{
			this.imageUrl = imageUrl;
			super();
		}
		
		private function handlerLoadImageComplete(e:Event):void{
			var bm:Bitmap = new Bitmap(imageLoader.bitmapData);
			this.addChild(bm);
		}
		
		/**
		 * 重写方法
		 * @return 
		 * 
		 */		
		override protected function draw():void{
			if(this.imageUrl != null){
				imageLoader.loadImage(this.imageUrl);
				imageLoader.addEventListener(Event.COMPLETE,handlerLoadImageComplete);
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

	}
}