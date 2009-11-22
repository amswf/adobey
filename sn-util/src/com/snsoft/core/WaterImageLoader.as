package com.snsoft.core
{
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	import fl.events.ComponentEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	/**
	 * 
	 */	
	public class WaterImageLoader extends UIComponent
	{
		/**
		 * 图片URL地址 
		 */		
		private var _url:String = null;
		
		/**
		 * 加载器 
		 */		
		private var loader:Loader = null;
		
		/**
		 * URL请求
		 */		
		private var req:URLRequest = null;
		
		/**
		 * 图片 
		 */		
		private var image:Bitmap = new Bitmap();
		
		/**
		 * 图片遮罩效果 
		 */		
		private var imageMask:Sprite = new Sprite();
		
		/**
		 * 边框 
		 */		
		private var waterFrame:Sprite = new Sprite();
		
		private static var IMAGE_LAYER:int = 0;
		
		private static var IMAGE_MASK_LAYER:int = 1;
		
		private static var WATER_FRAME_LAYER:int = 2;
		
		/**
		 * 构造方法 
		 * 
		 */				
		public function WaterImageLoader()
		{
			super();
			this.invalidate(InvalidationType.SIZE);
			this.addEventListener(ComponentEvent.RESIZE,handlerResize);
			this.addEventListener(Event.ENTER_FRAME,handlerEnterFrame);
			loadImage();
		}
		
		/**
		 * 当前项目改变宽高事件 
		 * @param e
		 * 
		 */		
		private function handlerResize(e:Event):void{
			
			this.addChildAt(image,IMAGE_LAYER);
			this.addChildAt(imageMask,IMAGE_MASK_LAYER);
			this.addChildAt(waterFrame,WATER_FRAME_LAYER);
			
			//设置图片宽高
			if(this.image != null){
				image.width = this.width;
				image.height = this.height;
			}
			
			//刷新遮罩层
			if(imageMask != null){
				imageMask = this.createImageMask(this.width,this.height);
				this.addChildAt(imageMask,IMAGE_MASK_LAYER);
				image.mask = imageMask;
			}
			
			//设置边框宽高
			if(waterFrame != null ){
				waterFrame.width = this.width;
				waterFrame.height = this.height;
			}
		}
		
		/**
		 * 当前项目进跳入帧事件 
		 * @param e
		 * 
		 */		
		private function handlerEnterFrame(e:Event):void{
			
			//删除监听器
			try{
				this.removeEventListener(Event.ENTER_FRAME,handlerEnterFrame);
			}
			catch(e:Error){
				
			}
			
			this.addChildAt(image,IMAGE_LAYER);
			this.addChildAt(imageMask,IMAGE_MASK_LAYER);
			this.addChildAt(waterFrame,WATER_FRAME_LAYER);
			
			//加载图片
			loadImage();
			
			//遮罩层用来遮罩图片
			imageMask = this.createImageMask(this.width,this.height);
			this.addChildAt(imageMask,IMAGE_MASK_LAYER);
			
			//添加边框样式
			waterFrame = Sprite(this.getDisplayObjectInstance("WaterFrameMask")); 
			waterFrame.width = this.width;
			waterFrame.height = this.height;
			this.addChildAt(waterFrame,WATER_FRAME_LAYER);
			
			
		}
		
		/**
		 * 加载图片 
		 * 
		 */		
		private function loadImage():void{
			if(url != null){
				req = new URLRequest(url);
				loader = new Loader();
				loader.load(req);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,handlerLoaderComplete);
			}
			
		}
		
		/**
		 * 加载图片完成事件 
		 * @param e
		 * 
		 */		
		private function handlerLoaderComplete(e:Event):void{
			
			//创建并图片
			var info:LoaderInfo = LoaderInfo(e.currentTarget);
			if(info != null){
				var bm:Bitmap = Bitmap(info.content);
				var data:BitmapData = bm.bitmapData;
				image = new Bitmap(data,"auto",true);
				image.width = this.width;
				image.height = this.height;
				this.addChildAt(image,IMAGE_LAYER);
				image.mask = imageMask;
			}
		}
		
		/**
		 * 
		 * @param url
		 * 
		 */					
		public function set url(url:String):void{
			this._url = url
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get url():String{
			return _url;
		}
		
		/**
		 * 创建一个遮罩 
		 * @param width
		 * @param height
		 * @return 
		 * 
		 */		
		private function createImageMask(width:Number,height:Number):Sprite{
			var mask:Sprite = new Sprite();
			var shape:Shape = new Shape();
			var gra:Graphics = shape.graphics;
			gra.beginFill(0x000000,0);
			gra.drawRoundRect(0,0,width,height,20,20);
			gra.endFill();
			mask.addChild(shape);
			return mask;
		}
	}
}