package com.snsoft.util.pf {

	public class Pathfinder {

		private static const MAX_VALUE:int = int.MAX_VALUE;

		private var adjmatrix:Vector.<Vector.<int>>

		private var startNodeIndex:int = 0;

		private var nodeNum:int = 0;

		private var path:Vector.<Node>;

		private var borders:Vector.<Border>;

		public function Pathfinder(borders:Vector.<Border>, startNodeIndex:int) {

			if (borders == null) {
				throw new Error("Pathfinder(borders,startNodeIndex): borders is null ");
			}
			else {
				this.borders = borders;
				this.startNodeIndex = startNodeIndex;
				init();
			}
		}

		private function init():void {

			this.nodeNum = getMaxIndex(borders);

			adjmatrix = new Vector.<Vector.<int>>();
			for (var i:int = 0; i < nodeNum; i++) {
				var v:Vector.<int> = new Vector.<int>();
				for (var j:int = 0; j < nodeNum; j++) {
					v.push(MAX_VALUE);
				}
				adjmatrix.push(v);
			}

			for (var k:int = 0; k < borders.length; k++) {
				var border:Border = borders[k];
				adjmatrix[border.i][border.j] = border.value;
				adjmatrix[border.j][border.i] = border.value;
			}

			var g:Vector.<Vector.<int>> = adjmatrix;
			var d:Vector.<int> = new Vector.<int>(nodeNum);
			path = new Vector.<Node>(nodeNum);

			dijkstra(g, d, path, startNodeIndex, nodeNum);
			//printPath(d, path, startNodeIndex, nodeNum);
		}

		private function getMaxIndex(borders:Vector.<Border>):int {
			var value:int = 0;
			for (var i:int = 0; i < borders.length; i++) {
				var border:Border = borders[i];
				if (border.i > value) {
					value = border.i;
				}
				if (border.j > value) {
					value = border.j;
				}
			}
			return value + 1;
		}

		public function getPath(endNodeIndex:int):Vector.<int> {
			var v:Vector.<int> = null;
			if (endNodeIndex != startNodeIndex) {
				v = new Vector.<int>();
				var p:Node = path[endNodeIndex];
				while (p != null) {
					v.push(p.adjvex);
					p = p.next;
				}
			}
			return v;
		}

		private function dijkstra(adjmatrix:Vector.<Vector.<int>>, dist:Vector.<int>, path:Vector.<Node>, i:int, n:int):void {

			var j:int = 0;
			var k:int = 0;
			var w:int = 0;
			var m:int = 0;

			var s:Vector.<Boolean> = new Vector.<Boolean>(n);

			for (j = 0; j < n; j++) {
				if (j == i) {
					s[j] = true;
				}
				else {
					s[j] = false;
				}
				dist[j] = adjmatrix[i][j];
				if (dist[j] < MAX_VALUE && j != i) {
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

			for (k = 1; k <= n - 2; k++) {
				w = MAX_VALUE;
				m = i;
				for (j = 0; j < n; j++) {
					if (s[j] == false && dist[j] < w) {
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
					if (s[j] == false && dist[m] + adjmatrix[m][j] < dist[j]) {
						dist[j] = dist[m] + adjmatrix[m][j];
						creatPath(path, m, j);
					}
				}
			}
		}

		public function creatPath(path:Vector.<Node>, m:int, j:int):void {

			var p:Node = null;
			var q:Node = null;
			var s:Node = null;

			p = path[j];

			while (p != null) {
				path[j] = p.next;
				p = path[j];
			}
			p = path[m];
			while (p != null) {
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
			for (j = 0; j < n; j++) {
				if (i != j) {
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

