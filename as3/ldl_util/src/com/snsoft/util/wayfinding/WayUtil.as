package com.snsoft.util.wayfinding {
	import flash.geom.Point;

	/**
	 * 工具类
	 * @author Administrator
	 *
	 */
	public class WayUtil {
		public function WayUtil() {
		}

		/**
		 * 拐弯最少的点列表
		 * @param pvv
		 * @return
		 *
		 */
		public static function findMinCornerV(pvv:Vector.<Vector.<Point>>):Vector.<Point> {
			var minBend:int = int.MAX_VALUE;
			var rpv:Vector.<Point> = new Vector.<Point>();
			for (var k:int = 0; k < pvv.length; k++) {
				var minpv:Vector.<Point> = pvv[k];
				var bendNum:int =  findBendNum(minpv);
				if (bendNum < minBend) {
					minBend = bendNum;
					rpv = minpv;
				}
			}
			return rpv;
		}

		public static function findBendNum(minpv:Vector.<Point>):int {
			var bendNum:int = -1;
			var prevp:Point = null;
			var ADDX:int = 1;
			var ADDY:int = 2;
			var add:int = 0;

			for (var i2:int = 0; i2 < minpv.length; i2++) {
				if (i2 > 0) {
					var p:Point = minpv[i2];
					var n:int = 0;
					if (p.x == prevp.x) {
						n = ADDY;
					}
					else if (p.y == prevp.y) {
						n = ADDX;
					}
					if (add > 0 && add != n) {
						bendNum++;
					}
					add = n;
				}
				prevp = minpv[i2];
			}
			return bendNum;
		}

		/**
		 * 查找长度最短的点列表
		 * @param pvv
		 * @return
		 *
		 */
		public static function findMinLenV(pvv:Vector.<Vector.<Point>>):Vector.<Vector.<Point>> {
			//长度最短的
			var minpvv:Vector.<Vector.<Point>> = new Vector.<Vector.<Point>>();

			var minl:int = int.MAX_VALUE;
			for (var i:int = 0; i < pvv.length; i++) {
				var pv:Vector.<Point> = pvv[i];
				if (pv.length < minl) {
					minl = pv.length;
				}
			}

			for (var j:int = 0; j < pvv.length; j++) {
				var mpv:Vector.<Point> = pvv[j];
				if (mpv.length == minl) {
					minpvv.push(mpv);
				}
			}
			return minpvv;
		}

		/**
		 * 克隆  Vector.<Point>
		 * @param pv
		 * @return
		 *
		 */
		public static function copyVectorPoint(fpv:Vector.<Point>, tpv:Vector.<Point>):void {
			for (var i:int = 0; i < fpv.length; i++) {
				tpv.push(fpv[i]);
			}
		}

		/**
		 * 相邻四点
		 * @param p
		 * @return
		 *
		 */
		public static function adjacency4Point(p:Point, ivv:Vector.<Vector.<Boolean>>):Vector.<Point> {
			var vp:Vector.<Point> = new Vector.<Point>();

			if (p.y > 0) {
				//trace("上面");
				var tp:Point = new Point();
				tp.x = p.x;
				tp.y = p.y - 1;
				vp.push(tp);
			}
			//下面
			if (p.y < ivv.length - 1) {
				//trace("下面");
				var bp:Point = new Point();
				bp.x = p.x;
				bp.y = p.y + 1;
				vp.push(bp);
			}
			//左面
			if (p.x > 0) {
				//trace("左面");
				var lp:Point = new Point();
				lp.x = p.x - 1;
				lp.y = p.y;
				vp.push(lp);
			}
			//右面
			if (p.x < ivv[p.y].length - 1) {
				//trace("右面");
				var rp:Point = new Point();
				rp.x = p.x + 1;
				rp.y = p.y;
				vp.push(rp);
			}

			return vp;
		}

		/**
		 *  克隆  Vector.<Vector.<Boolean>>
		 * @param ivv
		 * @return
		 *
		 */
		public static function copyVectorVectorBoolean(ivv:Vector.<Vector.<Boolean>>):Vector.<Vector.<Boolean>> {
			var civv:Vector.<Vector.<Boolean>> = new Vector.<Vector.<Boolean>>();
			for (var i:int = 0; i < ivv.length; i++) {
				var iv:Vector.<Boolean> = ivv[i];
				var civ:Vector.<Boolean> = copyVectorBoolean(iv);
				civv.push(civ);
			}
			return civv;
		}

		/**
		 * 克隆  Vector.<Boolean>
		 * @param pv
		 * @return
		 *
		 */
		public static function copyVectorBoolean(pv:Vector.<Boolean>):Vector.<Boolean> {
			var cpv:Vector.<Boolean> = new Vector.<Boolean>();
			for (var i:int = 0; i < pv.length; i++) {
				cpv.push(pv[i]);
			}
			return cpv;
		}
	}
}
