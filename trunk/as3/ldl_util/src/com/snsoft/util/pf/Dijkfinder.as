package com.snsoft.util.pf {
	import com.snsoft.util.HashVector;

	public class Dijkfinder {

		private static const MAX_VALUE:int = int.MAX_VALUE;

		private var G:Array;

		private var startNodeIndex:int = 0;

		private var nodeNum:int = 100;

		private var path:Vector.<Node>;

		private var borders:Vector.<Border>;

		private var len:int;

		public function Dijkfinder(borders:Vector.<Border>, startNodeIndex:int) {

			if (borders == null) {
				throw new Error("Pathfinder(borders,startNodeIndex): borders is null ");
			}
			else {
				this.borders = borders;
				this.startNodeIndex = startNodeIndex;

				//初始化矩阵
				G = new Array();
				for (var i:int = 0; i < nodeNum; i++) {
					var g:Array = new Array();
					for (var j:int = 0; j < nodeNum; j++) {
						g.push(MAX_VALUE);
					}
					G.push(g);
				}

				var hv:HashVector = new HashVector();

				//设置结点路径
				for (i = 0; i < borders.length; i++) {
					var b:Border = borders[i];
					var n1:int = b.i;
					var n2:int = b.j;
					var v:int = b.value;
					G[n1][n2] = v;
					G[n2][n1] = v;
					hv.push(n1, String(n1));
					hv.push(n2, String(n2));
				}
				len = hv.length;
			}
		}

		public function getPath(endNodeIndex:int):Vector.<int> {
			var findPath:Object = Dijkstra.getShortedPath(G, startNodeIndex, endNodeIndex, len); //地图数组,起点,终点,顶点数
			var dist:int = findPath.dist;
			var path:Array = findPath.path;

			var v:Vector.<int> = new Vector.<int>();
			for (var i:int = 0; i < path.length; i++) {
				v.push(path[i]);
			}
			return v;
		}
	}
}

