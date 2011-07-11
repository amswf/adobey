package com.snsoft.util.wayfinding {
	import flash.geom.Point;

	/**
	 * 矩阵寻路
	 * @author Administrator
	 *
	 */
	public class WayFinding {

		/**
		 * 寻路矩阵
		 */
		private var ivv:Vector.<Vector.<Boolean>>;

		/**
		 * 找到的路径
		 */

		public function WayFinding(ivv:Vector.<Vector.<Boolean>>) {
			this.ivv = ivv;
		}

		/**
		 * 找路径
		 * @param from
		 * @param to
		 * @return
		 *
		 */
		public function find(from:Point, to:Point):Vector.<Point> {
			//拐弯最少的
			var rpv:Vector.<Point> = new Vector.<Point>();
			if (from != to) {
				var pvv:Vector.<Vector.<Point>> = new Vector.<Vector.<Point>>();
				var ivv:Vector.<Vector.<Boolean>> = copyVectorVectorBoolean(this.ivv);
				var frompv:Vector.<Point> = new Vector.<Point>();
				frompv.push(from);
				var heap:Way = new Way(this.ivv);
				heap.push(from);
				var n1:Number = new Date().getTime();
				finding(frompv, to, ivv, heap, pvv);
				var n2:Number = new Date().getTime();

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

				var minBend:int = int.MAX_VALUE;

				for (var k:int = 0; k < minpvv.length; k++) {
					var minpv:Vector.<Point> = minpvv[k];

					var ADDX:int = 1;
					var ADDY:int = 2;

					var add:int = 0;
					var prevp:Point = null;
					var bendNum:int = 0;

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
					if (bendNum < minBend) {
						minBend = bendNum;
						rpv = minpv;
					}
				}
			}

			return rpv;
		}

		/**
		 * 找路径叠代主方法
		 * @param frompv
		 * @param to
		 * @param ivv
		 * @param heap
		 *
		 */
		private function finding(frompv:Vector.<Point>, to:Point, ivv:Vector.<Vector.<Boolean>>, heap:Way, pvv:Vector.<Vector.<Point>>):void {
			var nfromv:Vector.<Point> = new Vector.<Point>();
			for (var i:int = 0; i < frompv.length; i++) {
				var from:Point = frompv[i];
				if (ivv[from.y][from.x]) {
					ivv[from.y][from.x] = false;
					var npv:Vector.<Point> = adjacency4Point(from);
					for (var j:int = 0; j < npv.length; j++) {
						var np:Point = npv[j];
						if (ivv[np.y][np.x] || (np.y == from.y && np.x == from.x) || (np.y == to.y && np.x == to.x)) {
							heap.push(np, from);
							if (np.equals(to)) {
								var fpv:Vector.<Point> = heap.getSort(np);
								var pv:Vector.<Point> = new Vector.<Point>();
								copyVectorPoint(fpv, pv);
								pvv.push(pv);
							}
							else {
								nfromv.push(np);
							}
						}
					}
				}
			}
			if (nfromv.length > 0) {
				finding(nfromv, to, ivv, heap, pvv);
			}
		}

		/**
		 *  克隆  Vector.<Vector.<Boolean>>
		 * @param ivv
		 * @return
		 *
		 */
		private function copyVectorVectorBoolean(ivv:Vector.<Vector.<Boolean>>):Vector.<Vector.<Boolean>> {
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
		private function copyVectorBoolean(pv:Vector.<Boolean>):Vector.<Boolean> {
			var cpv:Vector.<Boolean> = new Vector.<Boolean>();
			for (var i:int = 0; i < pv.length; i++) {
				cpv.push(pv[i]);
			}
			return cpv;
		}

		/**
		 * 克隆  Vector.<Point>
		 * @param pv
		 * @return
		 *
		 */
		private function copyVectorPoint(fpv:Vector.<Point>, tpv:Vector.<Point>):void {
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
		private function adjacency4Point(p:Point):Vector.<Point> {
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
	}
}
