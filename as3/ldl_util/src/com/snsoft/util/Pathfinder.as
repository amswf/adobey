package com.snsoft.util {
	import flash.geom.Point;

	public class Pathfinder {

		private var maxvex:int;

		/**
		 * Empty Constructor (Nothing to do here)
		 */
		public function Pathfinder(maxvex:int) {
			this.maxvex = maxvex;

			this.maxvex = 5;

			var cost:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();
			for (var i:int = 0; i < maxvex; i++) {
				var c:Vector.<int> = new Vector.<int>();
				for (var j:int = 0; j < maxvex; j++) {
					c.push(int.MAX_VALUE);
				}
				cost.push(c);
			}

			var dist:Vector.<int> = new Vector.<int>();
			for (i = 0; i < maxvex; i++) {
				dist.push(0);
			}
			var path:Vector.<int> = new Vector.<int>();
			for (i = 0; i < maxvex; i++) {
				path.push(0);
			}
			var n:int = 3;
			var v0:int = 0;

			cost[0][1] = 10;
			cost[1][0] = 10;

			cost[1][2] = 10;
			cost[2][1] = 10;

			cost[2][3] = 10;
			cost[3][2] = 10;

			var s:Vector.<int> = shortPath(cost, dist, path, n, v0);
			printPath(dist, path, s, n, v0);
		}

		private function shortPath(cost:Vector.<Vector.<int>>, dist:Vector.<int>, path:Vector.<int>, n:int, v0:int):Vector.<int> {
			var s:Vector.<int> = new Vector.<int>();
			for (var i:int = 0; i < maxvex; i++) {
				s.push(0);
			}

			var u:int = 0;
			var vnum:int = 0;
			var w:int = 0;
			var wm:int = 0;

			for (w = 1; w <= n; w++) {
				dist[w] = cost[v0][w];
				if (cost[v0][w] < int.MAX_VALUE) {
					path[w] = v0;
				}
			}

			for (w = 1; w <= n; w++) {
				s[w] = 0;
			}
			s[v0] = 1;
			vnum = 1;
			while (vnum < n - 1) {
				wm = int.MAX_VALUE;
				u = v0;
				for (w = 1; w <= n; w++) {
					if (s[w] == 0 && dist[w] < wm) {
						u = w;
						wm = dist[w];
					}
				}
				s[u] = 1;
				vnum++;
				
				for (w = 1; w <= n; w++) {
					if (s[w] == 0 && dist[u] + cost[u][w] < dist[w]) {
						dist[w] = dist[u] + cost[u][w];
					}
				}
				vnum++;
			}
			return s;
		}

		private function printPath(dist:Vector.<int>, path:Vector.<int>, s:Vector.<int>, n:int, v0:int):void {
			trace(s);
			var i:int = 0;
			var k:int = 0;
			for (i = 1; i <= n; i++) {
				if (s[i] == 1) {
					k = i;
					while (k != v0) {
						trace(k);
						k = path[k];
					}
					trace(k);
					trace(dist[i]);
				}
				else {
					trace(i, v0);
					trace("∞");
				}
			}
		}
	}
}

