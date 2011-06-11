package com.snsoft.effect {

	import com.snsoft.util.SkinsUtil;

	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.Strong;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * 组件基本范例
	 * @author Administrator
	 *
	 */
	public class EllipseImage extends UIComponent {

		private var elliPoints:Vector.<Point>;

		private var imags:Vector.<MovieClip> = new Vector.<MovieClip>();

		private static const MOVIE_INDEX:String = "movieIndex";

		public function EllipseImage() {
			super();
		}

		/**
		 *
		 * 绘制组件显示
		 */
		override protected function draw():void {

			var el:Ellipse = new Ellipse(200, 100);
			elliPoints = el.getPoints();
			var elen:int = elliPoints.length;
			for (var i:int = 0; i < 3; i++) {
				imags.push(SkinsUtil.createSkinByName("MC") as MovieClip);
			}

			var n:int = imags.length;

			for (i = 0; i < imags.length; i++) {
				var mc:MovieClip = imags[i] as MovieClip;
				var m:int = (elen * i) / (n);
				mc[MOVIE_INDEX] = m;
				mc.x = elliPoints[m].x;
				mc.y = elliPoints[m].y;
				this.addChild(mc);
				mc.addEventListener(MouseEvent.CLICK, handler);
			}
		}

		private function handler(e:Event):void {
			var elen:int = elliPoints.length;
			var mc:MovieClip = e.currentTarget as MovieClip;
			var n:int = getIndex(int(mc[MOVIE_INDEX]), elen);
			if(n * 2 > elen){
				n = n - elen;
			}
			for (var i:int = 0; i < imags.length; i++) {
				var imc:MovieClip = imags[i];
				var m:int = getIndex(int(imc[MOVIE_INDEX]), elen);
				var tw:Tween = new Tween(imc, MOVIE_INDEX, Strong.easeOut, m, m - n, 50);
				tw.addEventListener(TweenEvent.MOTION_CHANGE, handlerChange);
					//tw.addEventListener(TweenEvent.MOTION_FINISH, handlerFinish);
			}
		}

		private function handlerChange(e:TweenEvent):void {
			var tw:Tween = e.currentTarget as Tween;
			var mc:MovieClip = tw.obj as MovieClip;
			var i:int = getIndex(int(mc[MOVIE_INDEX]), elliPoints.length);
			mc.x = elliPoints[i].x;
			mc.y = elliPoints[i].y;

		}

		private function handlerFinish(e:TweenEvent):void {
			var tw:Tween = e.currentTarget as Tween;
			var mc:MovieClip = tw.obj as MovieClip;
			var i:int = int(mc[MOVIE_INDEX] % elliPoints.length);
			mc[MOVIE_INDEX] = i;
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
