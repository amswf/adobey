package com.snsoft.ensview {
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class McEffect {

		//光影三角形颜色
		private static const LIGHT_FILL_COLOR:uint = 0xf4eec9;

		private static const LIGHT_FILL_ALPHA:Number = 0.3;

		//光影线框颜色
		private static const LIGHT_LINE_COLOR:uint = 0xf4eec9;

		private static const LIGHT_LINE_ALPHA:Number = 0.6;

		private static const LIGHT_LINE_BOADER:int = 1;

		public function McEffect() {
		}

		//通过县区的按钮位置及大小计算出县信息标签显示位置
		public static function getCuntryLablePoint(cl:Rectangle, btn:Rectangle, btns:Rectangle):Point {
			var xb:Number = btn.x;
			var yb:Number = btn.y;
			var xbs:Number = btns.width / 2;
			var ybs:Number = btns.height / 2;
			var p:Point = new Point();
			if (xb > xbs) {
				p.x = xb - cl.width - cl.width / 2;
			}
			else {
				p.x = xb + cl.width / 2;
			}
			if (yb > ybs) {
				p.y = yb - cl.height - cl.height / 2;
			}
			else {
				p.y = yb + cl.height / 2;
			}
			return p;
		}

		//画两个光影三角形 cl是信息标签 btn是当前县区块透明按钮，btns是全部按钮所在MC
		public static function createLightFace(cl:Rectangle, btn:Rectangle, btns:Rectangle, pnt:Point):MovieClip {

			var xb:Number = btn.x + pnt.x;

			var yb:Number = btn.y + pnt.y;

			var xbs:Number = btns.width / 2;

			var ybs:Number = btns.height / 2;

			var bp:Point = new Point(xb, yb);

			var cp1:Point = new Point();

			var cp2:Point = new Point();

			var cp3:Point = new Point();

			if (xb <= xbs && yb <= ybs) {
				cp1.x = cl.x + cl.width;
				cp1.y = cl.y;
				cp2.x = cl.x;
				cp2.y = cl.y;
				cp3.x = cl.x;
				cp3.y = cl.y + cl.height;
			}
			else if (xb >= xbs && yb <= ybs) {
				cp1.x = cl.x + cl.width;
				cp1.y = cl.y + cl.height;
				cp2.x = cl.x + cl.width;
				cp2.y = cl.y;
				cp3.x = cl.x;
				cp3.y = cl.y;
			}
			else if (xb <= xbs && yb >= ybs) {
				cp1.x = cl.x;
				cp1.y = cl.y;
				cp2.x = cl.x;
				cp2.y = cl.y + cl.height;
				cp3.x = cl.x + cl.width;
				cp3.y = cl.y + cl.height;
			}
			else if (xb >= xbs && yb >= ybs) {
				cp1.x = cl.x;
				cp1.y = cl.y + cl.height;
				cp2.x = cl.x + cl.width;
				cp2.y = cl.y + cl.height;
				cp3.x = cl.x + cl.width;
				cp3.y = cl.y;
			}

			var sps:MovieClip = new MovieClip();
			sps.addChild(drawLightFill(bp, cp1, cp2));
			sps.addChild(drawLightFill(bp, cp2, cp3));
			sps.addChild(drawLightLine(bp, cp2));
			return sps;
		}

		//画线
		private static function drawLightLine(p1:Point, p2:Point):Shape {
			var sp:Shape = new Shape();
			var gra:Graphics = sp.graphics;
			gra.lineStyle(LIGHT_LINE_BOADER, LIGHT_LINE_COLOR, LIGHT_LINE_ALPHA);
			gra.moveTo(p1.x, p1.y);
			gra.lineTo(p2.x, p2.y);
			return sp;
		}

		//画三角形
		private static function drawLightFill(bp:Point, cp1:Point, cp2:Point):Shape {
			var sp:Shape = new Shape();
			var gra:Graphics = sp.graphics;
			gra.beginFill(LIGHT_FILL_COLOR, LIGHT_FILL_ALPHA);
			gra.moveTo(bp.x, bp.y);
			gra.lineTo(cp1.x, cp1.y);
			gra.lineTo(cp2.x, cp2.y);
			gra.lineTo(bp.x, bp.y);
			gra.endFill();
			return sp;
		}
	}
}
