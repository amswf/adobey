package com.snsoft.util.pf {

	public class Pathfinder {

		private var adjmatrix:Vector.<Vector.<int>>

		private static const MaxVerNum:int = 20;

		private static const MaxValue:int = 10000;

		public function Pathfinder() {
			main();
		}

		private function main():void

		{

			var i:int, n:int;

			//cout << "输入你所输入的有向带权图的顶点个数: ";

			n = 5;

			adjmatrix = new Vector.<Vector.<int>>();
			for (var j:int = 0; j < n; j++) {
				var v:Vector.<int> = new Vector.<int>();
				for (var k:int = 0; k < n; k++) {
					v.push(MaxValue);
				}
				adjmatrix.push(v);
			}

			var g:Vector.<Vector.<int>> = adjmatrix;

			var d:Vector.<int> = new Vector.<int>(n);

			var path:Vector.<Node> = new Vector.<Node>(n);

			//cout << "请输入你要输入的源点: ";

			i = 0;

			adjmatrix[0][1] = 10;
			adjmatrix[1][0] = 10;
			adjmatrix[1][2] = 20;
			adjmatrix[2][1] = 20;

			dijkstra(g, d, path, i, n);
			printPath(d, path, i, n);
		}

		//指针数组path[]基类型定义

		private function dijkstra(adjmatrix:Vector.<Vector.<int>>, dist:Vector.<int>, path:Vector.<Node>, i:int, n:int):void {

			var j:int = 0;
			var k:int = 0;
			var w:int = 0;
			var m:int = 0;

			var s:Vector.<Boolean> = new Vector.<Boolean>(n);

			for (j = 0; j < n; j++)

			{

				if (j == i) {

					s[j] = true;
				}

				else {

					s[j] = false;
				}

				dist[j] = adjmatrix[i][j];

				if (dist[j] < MaxValue && j != i)

				{

					var p1:Node = new Node();

					var p2:Node = new Node();

					p1.adjvex = i;

					p2.adjvex = j;

					p2.next = null;

					p1.next = p2;

					path[j] = p1;

				}

				else {

					path[j] = null;
				}

			}

			for (k = 1; k <= n - 2; k++)

			{

				w = MaxValue;

				m = i;

				for (j = 0; j < n; j++) {

					if (s[j] == false && dist[j] < w)

					{

						w = dist[j];

						m = j;

					}
				}

				if (m != i) {

					s[m] = true;
				}

				else {

					break;
				}

				for (j = 0; j < n; j++) {

					if (s[j] == false && dist[m] + adjmatrix[m][j] < dist[j])

					{

						dist[j] = dist[m] + adjmatrix[m][j];

						creatPath(path, m, j);

					}
				}

			}

		}

		public function creatPath(path:Vector.<Node>, m:int, j:int):void

		{

			var p:Node = null;
			var q:Node = null;
			var s:Node = null;

			p = path[j];

			while (p != null)

			{

				path[j] = p.next;

				p = path[j];

			}

			p = path[m];

			while (p != null)

			{

				q = new Node();

				q.adjvex = p.adjvex;

				if (path[j] == null) {

					path[j] = q;
				}

				else {

					s.next = q;
				}

				s = q;

				p = p.next;

			}

			q = new Node;

			q.adjvex = j;

			q.next = null;

			s.next = q;

		}

		private function printPath(dist:Vector.<int>, path:Vector.<Node>, i:int, n:int):void {

			var j:int;

			for (j = 0; j < n; j++)

			{

				if (i != j)

				{

					trace("顶点v", i, "到顶点v", j, "的最短路径的长度为 ")

					trace(dist[j], ", 最短路径为: ");

					var p:Node = path[j];

					while (p != null) {
						trace(p.adjvex);
						p = p.next;
					}
				}
			}
		}

	}
}

