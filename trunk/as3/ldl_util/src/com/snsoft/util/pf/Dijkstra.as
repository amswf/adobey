package com.snsoft.util.pf {

	/**
	 * @Description    : Dijkstra'Algorithm By AS3
	 * @author        : fysheji@yahoo.com.cn
	 * @date         : 2009/02/06
	 */
	public class Dijkstra {
		private static var MaxSize:int = 1000;
		private static var noPath:int = int.MAX_VALUE;

		public function Dijkstra() {
		}

		//从某一源点出发，找到到某一结点的最短路径
		public static function getShortedPath(G:Array, star:int, end:int, len:int):Object {
			var s:Array = new Array();
			var min:int;
			var curNode:int = 0;
			var dist:Array = new Array();
			var prev:Array = new Array();

			var path:Array = new Array();

			for (var v:int = 0; v < len; v++) {
				s[v] = false;
				dist[v] = G[star][v];
				if (dist[v] > MaxSize) {
					prev[v] = 0;
				}
				else {
					prev[v] = star;
				}
			}
			path[0] = end;
			dist[star] = 0;
			s[star] = true;

			for (var i:int = 1; i < len; i++) {
				min = MaxSize;
				for (var w:int = 0; w < len; w++) {
					if ((!s[w]) && (dist[w] < min)) {
						curNode = w;
						min = dist[w];
					}
				}
				s[curNode] = true;
				for (var j:int = 0; j < len; j++) {
					if ((!s[j]) && ((min + G[curNode][j]) < dist[j])) {
						dist[j] = min + G[curNode][j];
						prev[j] = curNode;
					}
				}
			}
			;

			var e:int = end;
			var step:int = 0;
			while (e != star) {
				step++;
				path[step] = prev[e];
				e = prev[e];
			}
			for (var q:int = step; q > (step / 2); q--) {
				var temp:int = path[step - q];
				path[step - q] = path[q];
				path[q] = temp;
			}
			return {dist: dist[end], path: path};
		}

		//从某一源点出发,找出到所有节点的最短路径
		public static function getShortedPathList(G:Array, star:int, len:int):Object {
			var pathID:Array = new Array(len);
			var s:Array = new Array(len);
			var min:int;
			var curNode:int = 0;
			var dist:Array = new Array(len);
			var prev:Array = new Array(len);

			var path:Array = new Array();
			for (var n:int = 0; n < len; n++) {
				path.push(new Array);
			}

			for (var v:int = 0; v < len; v++) {
				s[v] = false;
				dist[v] = G[star][v];
				if (dist[v] > MaxSize) {
					prev[v] = 0;
				}
				else {
					prev[v] = star;
				}
				path[v][0] = v;
			}
			dist[star] = 0;
			s[star] = true;

			for (var i:int = 1; i < len; i++) {
				min = MaxSize;
				for (var w:int = 0; w < len; w++) {
					if ((!s[w]) && (dist[w] < min)) {
						curNode = w;
						min = dist[w];
					}
				}
				s[curNode] = true;
				for (var j:int = 0; j < len; j++) {
					if ((!s[j]) && ((min + G[curNode][j]) < dist[j])) {
						dist[j] = min + G[curNode][j];
						prev[j] = curNode;
					}
				}
			}

			for (var k:int = 0; k < len; k++) {
				var e:int = k;
				var step:int = 0;
				while (e != star) {
					step++;
					path[k][step] = prev[e];
					e = prev[e];
				}
				for (var p:int = step; p > (step / 2); p--) {
					var temp:int = path[k][step - p];
					path[k][step - p] = path[k][p];
					path[k][p] = temp;
				}
			}
			return {dist: dist, path: path};
		}
	}
}
