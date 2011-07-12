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

			var rpv:Vector.<Point> = new Vector.<Point>();
			if (from != to) {
				var pvv:Vector.<Vector.<Point>> = new Vector.<Vector.<Point>>();
				var ivv:Vector.<Vector.<Boolean>> = WayUtil.copyVectorVectorBoolean(this.ivv);
				var frompv:Vector.<Point> = new Vector.<Point>();
				frompv.push(from);
				var heap:Way = new Way(this.ivv);
				heap.push(from);
				var n1:Number = new Date().getTime();
				finding(frompv, to, ivv, heap, pvv);
				var n2:Number = new Date().getTime();

				//长度最短的
				var minpvv:Vector.<Vector.<Point>> =  WayUtil.findMinLenV(pvv);

				//拐弯最少的
				rpv = WayUtil.findMinCornerV(minpvv);
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
					var npv:Vector.<Point> = WayUtil.adjacency4Point(from, ivv);
					for (var j:int = 0; j < npv.length; j++) {
						var np:Point = npv[j];
						if (ivv[np.y][np.x] || (np.y == from.y && np.x == from.x) || (np.y == to.y && np.x == to.x)) {
							heap.push(np, from);
							if (np.equals(to)) {
								var fpv:Vector.<Point> = heap.getSort(np);
								var pv:Vector.<Point> = new Vector.<Point>();
								WayUtil.copyVectorPoint(fpv, pv);
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

	}
}
