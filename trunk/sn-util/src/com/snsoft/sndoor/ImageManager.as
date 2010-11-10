package com.snsoft.sndoor{
	import com.snsoft.util.ImageLoader;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class ImageManager extends EventDispatcher{
		
		private var imageUrlV:Vector.<String>;
		
		public function ImageManager(imageUrlV:Vector.<String>){
			this.imageUrlV = imageUrlV;
		}
		
		public function loadImage():void{
			var imgl:ImageLoader = new ImageLoader();
			imgl.addEventListener(Event.COMPLETE,handlerCmp);
		}
		
		private function handlerCmp(e:Event):void{
			
		}
	}
}