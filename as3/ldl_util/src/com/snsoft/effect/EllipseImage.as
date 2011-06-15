package com.snsoft.effect {

	import com.snsoft.util.SkinsUtil;

	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.Regular;
	import fl.transitions.easing.Strong;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;

	/**
	 * 组件基本范例
	 * @author Administrator
	 *
	 */
	public class EllipseImage extends UIComponent {

		private var elliPoints:Vector.<Point>;

		private var images:Vector.<MovieClip> = new Vector.<MovieClip>();

		private static const MOVIE_INDEX:String = "movieIndex";

		private static const MOVIE_HELP_INDEX:String = "movieCurrentIndex";

		private var currentIndex:int = 0;

		private var lock:Boolean = false;

		private var a:int = 300;

		private var b:int = 100;

		private var moveFinished:int = 0;

		public function EllipseImage(a:int, b:int, images:Vector.<MovieClip>) {
			this.a = a;
			this.b = b;
			this.images = images;
			super();
		}

		/**
		 *
		 * 绘制组件显示
		 */
		override protected function draw():void {
			if (images != null) {
				var el:Ellipse = new Ellipse(a, b);
				elliPoints = el.getPoints();
				var elen:int = elliPoints.length;

				var n:int = images.length;

				for (var i:int = 0; i < images.length; i++) {
					var mc:MovieClip = images[i] as MovieClip;
					var m:int = (elen * i) / (n);
					mc[MOVIE_INDEX] = m;
					mc[MOVIE_HELP_INDEX] = 0;
					mc.x = elliPoints[m].x;
					mc.y = elliPoints[m].y;
					var scale:Number = (mc.y + b * 3) / (b * 4);
					mc.scaleX = scale;
					mc.scaleY = scale;
					this.addChild(mc);
					mc.addEventListener(MouseEvent.CLICK, handler);
				}
			}
		}

		private function handler(e:Event):void {
			if (!lock) {
				lock = true;

				var elen:int = elliPoints.length;
				var mc:MovieClip = e.currentTarget as MovieClip;
				var tfd:TextField = mc.getChildByName("tfd") as TextField;
				var n:int = getIndex(int(mc[MOVIE_INDEX]), elen);
				if (n * 2 > elen) {
					n = n - elen;
				}
				moveFinished = images.length;
				currentIndex = n;
				var tw:Tween = new Tween(mc, MOVIE_HELP_INDEX, Regular.easeOut, n, 0, 50);
				tw.addEventListener(TweenEvent.MOTION_CHANGE, handlerChange);
				tw.addEventListener(TweenEvent.MOTION_FINISH, handlerFinish);
			}
		}

		private function handlerChange(e:TweenEvent):void {
			var tw:Tween = e.currentTarget as Tween;
			var mc:MovieClip = tw.obj as MovieClip;
			var m:int = int(mc[MOVIE_INDEX]);
			var n:int = int(e.position);
			for (var i:int = 0; i < images.length; i++) {
				var img:MovieClip = images[i];
				var index:int = int(img[MOVIE_INDEX]) - m + n;
				var nindex:int = getIndex(index, elliPoints.length);
				img.x = elliPoints[nindex].x;
				img.y = elliPoints[nindex].y;
				var scale:Number = (img.y + b * 3) / (b * 4);
				img.scaleX = scale;
				img.scaleY = scale;
			}
		}

		private function handlerFinish(e:TweenEvent):void {
			var tw:Tween = e.currentTarget as Tween;
			var mc:MovieClip = tw.obj as MovieClip;
			var m:int = int(mc[MOVIE_INDEX]);
			for (var i:int = 0; i < images.length; i++) {
				var img:MovieClip = images[i];
				var index:int = int(img[MOVIE_INDEX]) - m;
				var nindex:int = getIndex(index, elliPoints.length);
				img[MOVIE_INDEX] = nindex;
			}
			lock = false;
		}

		private function getIndex(index:int, length:int):int {
			var i:int = 0;
			if (index >= length) {
				i = index - length;
			}
			else if (index < 0) {
				i = index + length;
			}
			else {
				i = index;
			}
			return i;
		}

		/**
		 *
		 */
		private static var defaultStyles:Object = {};

		/**
		 *
		 * @return
		 *
		 */
		public static function getStyleDefinition():Object {
			return UIComponent.mergeStyles(UIComponent.getStyleDefinition(), defaultStyles);
		}

		/**
		 *
		 *
		 */
		override protected function configUI():void {
			this.invalidate(InvalidationType.ALL, true);
			this.invalidate(InvalidationType.SIZE, true);
			super.configUI();
		}

	}
}
