package com.snsoft.util.wayfd {

	import flash.geom.Point;

	public class WayFinding {

		private var wayPointVV:Vector.<Vector.<Boolean>>;

		public function WayFinding(wayPointVV:Vector.<Vector.<Boolean>>) {
			this.wayPointVV = wayPointVV;
		}

		public function findWay(from:Point, to:Point):Vector.<Point> {
			var pvv:Vector.<Vector.<Point>> = new Vector.<Vector.<Point>>();
			var minLen:int = int.MAX_VALUE;

			var priorityPoint:Point = new Point();
			priorityPoint.x = to.x > from.x ? 1 : -1;
			priorityPoint.y = to.y > from.y ? 1 : -1;

			var fwp:WayPoint = new WayPoint(from);
			fwp.length = 1;
			find(fwp, to, priorityPoint, pvv, minLen, wayPointVV);

			var pv:Vector.<Point> = new Vector.<Point>();
			return pv;
		}

		private function find(from:WayPoint, to:Point, priorityPoint:Point, pvv:Vector.<Vector.<Point>>, minLen:int, wayPointVV:Vector.<Vector.<Boolean>>):void {

			var wpvv:Vector.<Vector.<Boolean>> =  WayUtil.copyVectorVectorBoolean(wayPointVV);
			wpvv[from.point.y][from.point.x] = false;
			fillNext4WayPoint(from, wpvv);

			var nwpv:Vector.<WayPoint> = getWayNextPoints(from, priorityPoint);

//			var str:String = "";
//			for (var k:int = 0; k < nwpv.length; k++) {
//				str += nwpv[i].point;
//			}
//			trace(str);

			var cminlen:int = minLen;
			if (from.length < cminlen) {
				var fwpv:Vector.<WayPoint> = new Vector.<WayPoint>();
				for (var i:int = 0; i < nwpv.length; i++) {
					var nwp:WayPoint = nwpv[i];
					if (nwp != null) {
						if (nwp.point.equals(to)) {
							var pv:Vector.<Point> = getPath(nwp);
							trace(pv);
							if (pv.length < cminlen) {
								cminlen = pv.length;
							}
						}
						else {
							fwpv.push(nwp);
						}
					}
				}
				for (var j:int = 0; j < fwpv.length; j++) {
					var fwp:WayPoint = fwpv[j];
					find(fwp, to, priorityPoint, pvv, cminlen, wpvv);
				}
			}
		}

		private function getPath(wp:WayPoint):Vector.<Point> {

			var pwp:WayPoint = wp;

			var pv:Vector.<Point> = new Vector.<Point>();
			while (pwp != null) {
				pv.push(pwp.point);
				pwp = pwp.prev;
			}
			return pv;
		}

		private function getWayNextPoints(fwp:WayPoint, priorityPoint:Point):Vector.<WayPoint> {
			var wpv:Vector.<WayPoint> = new Vector.<WayPoint>();
			if (priorityPoint.x > 0) {
				if (fwp.right != null) {
					wpv.push(fwp.right);
				}
				if (fwp.left != null) {
					wpv.push(fwp.left);
				}
			}
			else {
				if (fwp.left != null) {
					wpv.push(fwp.left);
				}
				if (fwp.right != null) {
					wpv.push(fwp.right);
				}
			}
			if (priorityPoint.y > 0) {
				if (fwp.bottom != null) {
					wpv.push(fwp.bottom);
				}
				if (fwp.top != null) {
					wpv.push(fwp.top);
				}
			}
			else {
				if (fwp.top != null) {
					wpv.push(fwp.top);
				}
				else if (fwp.bottom != null) {
					wpv.push(fwp.bottom);
				}
			}
			return wpv;
		}

		private function fillNext4WayPoint(fwp:WayPoint, wpvv:Vector.<Vector.<Boolean>>):void {
			var p:Point = fwp.point;
			var len:int = fwp.length + 1;
			var prevp:Point = new Point(-1, -1);
			if (fwp.prev != null) {
				prevp = fwp.prev.point;
			}
			if (p.x - 1 >= 0) {
				var lp:Point = new Point(p.x - 1, p.y);
				if (wpvv[lp.y][lp.x] && prevp.x != lp.x && prevp.y != lp.y) {
					fwp.left = new WayPoint(lp, fwp);
					fwp.left.length = len;
				}
			}
			if (p.x + 1 < wpvv[0].length) {
				var rp:Point = new Point(p.x + 1, p.y);
				if (wpvv[rp.y][rp.x] && prevp.x != rp.x && prevp.y != rp.y) {
					fwp.right = new WayPoint(rp, fwp);
					fwp.right.length = len;
				}
			}
			if (p.y - 1 >= 0) {
				var tp:Point = new Point(p.x, p.y - 1);
				if (wpvv[tp.y][tp.x] && prevp.x != tp.x && prevp.y != tp.y) {
					fwp.top = new WayPoint(tp, fwp);
					fwp.top.length = len;
				}
			}
			if (p.y + 1 < wpvv.length) {
				var bp:Point = new Point(p.x, p.y + 1);
				if (wpvv[bp.y][bp.x] && prevp.x != bp.x && prevp.y != bp.y) {
					fwp.bottom = new WayPoint(bp, fwp);
					fwp.bottom.length = len;
				}
			}
		}
	}
}
