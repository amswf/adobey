package com.snsoft.map {
	import com.snsoft.util.PointUtil;
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.images.ImageLoader;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;

	public class MapBackImage extends MapComponent {
		//边框
		private var MAIN_FRAME_SKIN:String = "BaseBack";

		//图片加载器
		private var imageLoader:ImageLoader = new ImageLoader();

		//图片位图数据
		private var mapImage:BitmapData = null;

		//图片地址
		private var _imageUrl:String = null;

		//图片MC
		private var imageMc:MovieClip = new MovieClip();

		//图片
		private var imageBm:Bitmap;

		//背景
		private var backMc:MovieClip = SkinsUtil.createSkinByName(MAIN_FRAME_SKIN);

		private var sizePoint:Point = new Point();

		//缩放系数
		private var _scalePoint:Point = new Point(1, 1);

		public function MapBackImage(sizePoint:Point, imageUrl:String = null, scalePoint:Point = null) {
			super();
			this.imageUrl = imageUrl;
			if (scalePoint != null) {
				this.scalePoint = scalePoint;
			}
			this.sizePoint = sizePoint;
			imageLoader.addEventListener(Event.COMPLETE, handlerLoadImageComplete);
			imageLoader.addEventListener(IOErrorEvent.IO_ERROR, handlerLoadImageIOError);
			 
		}

		private function handlerLoadImageIOError(e:Event):void {
			this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		}

		private function handlerLoadImageComplete(e:Event):void {
			imageBm = new Bitmap(imageLoader.bitmapData);
			imageMc = new MovieClip();
			imageMc.addChild(imageBm);
			this.refresh();
			this.dispatchEvent(new Event(Event.COMPLETE));
		}

		/**
		 * 加载图片
		 *
		 */
		public function loadImage():void {
			imageLoader.loadImage(this.imageUrl);
		}

		/**
		 * 重写方法
		 * @return
		 *
		 */
		override protected function draw():void {
			PointUtil.deleteAllChild(this);
			this.addChild(backMc);
			this.addChild(imageMc);

			var bmP:Point = new Point();
			if (this.imageBm != null) {
				bmP = PointUtil.getSpriteSize(this.imageBm);
			}
			var backP:Point = sizePoint;

			var bmsP:Point = PointUtil.creatSaclePoint(bmP, this.scalePoint);
			var backsP:Point = PointUtil.creatSaclePoint(backP, this.scalePoint);

			var px:Number = bmsP.x > backsP.x ? bmsP.x : backsP.x;
			var py:Number = bmsP.y > backsP.y ? bmsP.y : backsP.y;
			var p:Point = new Point(px, py);
			PointUtil.setSpriteSize(this.imageMc, bmsP);
			PointUtil.setSpriteSize(this.backMc, p);
			PointUtil.setSpriteSize(this, p);
		}

		public function get imageUrl():String {
			return _imageUrl;
		}

		public function set imageUrl(value:String):void {
			_imageUrl = value;
		}

		public function get scalePoint():Point {
			return _scalePoint;
		}

		public function set scalePoint(value:Point):void {
			_scalePoint = value;
		}

	}
}
