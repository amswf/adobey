package com.snsoft.util.pf {

	public class Dijkstra {

		public static const maxnum:int = 100;
		public static const maxint:int = 999999;

		// 各数组都从下标1开始
		private var dist:Vector.<int> = new Vector.<int>(maxnum); // 表示当前点到源点的最短路径长度
		private var prev:Vector.<int> = new Vector.<int>(maxnum); // 记录当前点的前一个结点
		private var c:Vector.<Vector.<int>>; // 记录图的两点间路径长度
		private var n:int, line:int;

		public function Dijkstra() {
			c = new Vector.<Vector.<int>>();
			for (var i:int = 0; i < maxnum; i++) {
				var v:Vector.<int> = new Vector.<int>();
				for (var j:int = 0; j < maxnum; j++) {
					v.push(maxint);
				}
				c.push(v);
			}

			c[0][1] = 10;
			c[0][2] = 10;
			c[0][3] = 10;
			c[1][4] = 10;
			c[4][5] = 10;

			dijkstra(5, 1, dist, prev, c);
			searchPath(prev, 1, 5);
		}

		public function dijkstra(n:int, v:int, dist:Vector.<int>, prev:Vector.<int>, c:Vector.<Vector.<int>>):void {
			var s:Vector.<Boolean> = new Vector.<Boolean>(maxnum); // 判断是否已存入该点到S集合中
			for (var i:int = 1; i <= n; ++i) {
				dist[i] = c[v][i];
				s[i] = 0; // 初始都未用过该点
				if (dist[i] == maxint) {
					prev[i] = 0;
				}
				else {
					prev[i] = v;
				}
			}
			dist[v] = 0;
			s[v] = 1;

			// 依次将未放入S集合的结点中，取dist[]最小值的结点，放入结合S中
			// 一旦S包含了所有V中顶点，dist就记录了从源点到所有其他顶点之间的最短路径长度
			for (i = 2; i <= n; ++i) {
				var tmp:int = maxint;
				var u:int = v;
				// 找出当前未使用的点j的dist[j]最小值
				for (var j:int = 1; j <= n; ++j) {
					if ((!s[j]) && dist[j] < tmp) {
						u = j; // u保存当前邻接点中距离最小的点的号码
						tmp = dist[j];
					}
				}
				s[u] = 1; // 表示u点已存入S集合中

				// 更新dist
				for (j = 1; j <= n; ++j) {
					if ((!s[j]) && c[u][j] < maxint) {
						var newdist:int = dist[u] + c[u][j];
						if (newdist < dist[j]) {
							dist[j] = newdist;
							prev[j] = u;
						}
					}
				}
			}
		}

		public function searchPath(prev:Vector.<int>, v:int, u:int):void {
			var que:Vector.<int> = new Vector.<int>(maxnum);
			var tot:int = 1;
			que[tot] = u;
			tot++;
			var tmp:int = prev[u];
			while (tmp != v) {
				que[tot] = tmp;
				tot++;
				tmp = prev[tmp];
			}
			que[tot] = v;

			var path:Vector.<int> = new Vector.<int>();
			for (var i:int = tot; i >= 1; --i) {
				path.push(que[i]);
			}
			trace(path);
		}

	}
}
