package com.snsoft.util.pf {
	import flash.display.Sprite;

	public class Main extends Sprite {
		private var len:int = 0;
		private var NX:int = int.MAX_VALUE;
		private var P:Array = ["a", "b", "c", "d", "e", "f", "g", "h"];
		private var G:Array = [
			[NX, 5, NX, NX, NX, 3, NX, NX],
			[5, NX, 2, NX, NX, NX, 3, NX],
			[NX, 2, NX, 6, NX, NX, NX, 10],
			[NX, NX, 6, NX, 3, NX, NX, NX],
			[NX, NX, NX, 3, NX, 8, NX, 5],
			[3, NX, NX, NX, 8, NX, 7, NX],
			[NX, 3, NX, NX, NX, 7, NX, 2],
			[NX, NX, 10, NX, 5, NX, 2, NX]
			];

		public function Main():void {
			len = G.length

			trace("源点到指定一点的路径:::::::::::::::::::::::::::::");
			var findPath:Object = Dijkstra.getShortedPath(G, 0, 3, len); //地图数组,起点,终点,顶点数
			var dist:int = findPath.dist;
			var path:Array = findPath.path;
			trace("0>>3 路径:");
			var str:String = "";
			for (var i:int = 0; i < path.length; i++) {
				str += String(P[path[i]]) + " ";
			}
			trace(str);
			if (dist == int.MAX_VALUE) {
				trace("没路径");
			}
			else {
				trace("长度：" + dist);
			}

			//*******************************************************

			var findPathList:Object = Dijkstra.getShortedPathList(G, 0, len); //地图数组,起点,顶点数
			var pathdist:Array = findPathList.dist;
			var path2:Array = findPathList.path;
			trace("点0到任意点的路径::::::::::::::::::::::::::::::::");
			for (var j:int = 0; j < pathdist.length; j++) {
				trace("点a到" + P[j] + "的路径:");
				str = "";
				for (var q:int = 0; q < path2[j].length; q++) {
					str += String(P[path2[j][q]]) + " ";
				}
				trace(str);
				if (pathdist[j] == int.MAX_VALUE) {
					trace("没路径");
				}
				else {
					trace("长度:" + pathdist[j]);
				}
				trace("----------------");
			}
		}
	}

}
