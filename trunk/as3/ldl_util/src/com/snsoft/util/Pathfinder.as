package com.snsoft.util {
	import flash.geom.Point;

	public class Pathfinder {

		private static const MAX_VERTS:int    = 20;
		private static const INFINITY:int   = 1000000;
		private var vertexList:Vector.<Vertex>; // list of vertices

		private var adjMat:Vector.<Vector.<int>>; // adjacency matrix

		private var nVerts:int; // current number of vertices

		private var nTree:int; // number of verts in tree

		private var shortestPath:Vector.<DistanceParent>; // array for shortest-path data

		private var currentVertex:int; // current vertex

		private var startToCurrentDistance:int; // distance to currentVert

		public function Pathfinder() {
			vertexList = new Vector.<Vertex>(MAX_VERTS);
			// adjacency matrix

			nVerts = 0;
			nTree = 0;

			adjMat = new Vector.<Vector.<int>>;
			for (var j:int = 0; j < MAX_VERTS; j++) {
				// set adjacency
				var v:Vector.<int> = new Vector.<int>(MAX_VERTS);
				for (var k:int = 0; k < MAX_VERTS; k++) {
					v[k] = INFINITY;
				}
				adjMat.push(v);
			}

			shortestPath = new Vector.<DistanceParent>(MAX_VERTS); // shortest paths

		}

		/**
		 * 求最短路径算法：Dijkstra算法。
		 */
		public function findShortestPath():void {
			var startTree:int = 0; //从0节点开始

			vertexList[startTree].isInTree = true; //将该节点放入树中

			nTree = 1;

			//初始化最短路径表，以邻接矩阵中的 startTree 行数据初始化

			for (var i:int = 0; i < nVerts; i++) {
				shortestPath[i] = new DistanceParent(startTree, adjMat[startTree][i]);
			}

			while (nTree < nVerts) {
				var indexMin:int = getMinFromShortestPath(); // 从最短路径表中得到目前的最小值

				var minDist:int = shortestPath[indexMin].distance;

				if (minDist == INFINITY) // 如果为 INFINITY ，表明不可达，或者都在树中了。

				{
					break; // sPath is complete

				}
				else {
					currentVertex = indexMin; // 将最小的赋值给currentVert，为即将进入树中作准备

					startToCurrentDistance = shortestPath[indexMin].distance; //路径权重最小

				}
				// 将当前节点放入树中

				vertexList[currentVertex].isInTree = true;
				nTree++;
				adjust_sPath(); // 更新最短路径表

			} //end while

			displayPaths(); // display sPath[] contents

			nTree = 0; // clear tree

			for (var j:int = 0; j < nVerts; j++) {
				vertexList[j].isInTree = false;
			}
		}

		/**
		 * 显示最短路径
		 */
		public function displayPaths():void {
			for (var j:int = 0; j < nVerts; j++) // display contents of sPath[]

			{
				trace(vertexList[j].label + "="); // B=

				if (shortestPath[j].distance == INFINITY) {
					trace("inf"); // inf

				}
				else {
					trace(shortestPath[j].distance); // 50

				}
				var parent:String = vertexList[shortestPath[j].parentVert].label;
				trace("(" + parent + ") "); // (A)

			}
			trace("");
		}

		/**
		 * 更新最短路径表
		 */
		public function adjust_sPath():void {
			for (var column:int = 1; column < nVerts; column++) //跳过自身，从1开始

			{
				if (false == vertexList[column].isInTree) //如果不在树中

				{
					// calculate distance for one sPath entry

					var currentToFringe:int = adjMat[currentVertex][column]; // 当前点到column的距离

					var startToFringe:int = startToCurrentDistance + currentToFringe; //计算起始点到column的距离

					// 与原来最短路径表中的权重值进行比较

					if (startToFringe < shortestPath[column].distance) // 如果新值更小，就更新最短路径表

					{
						shortestPath[column].parentVert = currentVertex;
						shortestPath[column].distance = startToFringe;
					} //end if

				} //end if

			} //end for

		}

		/**
		 * 从最短路径表中得到目前的最小值
		 * @return 返回最小值的index
		 */
		public function getMinFromShortestPath():int {

			var minDist:int = INFINITY; // assume minimum

			var indexMin:int = 0;
			for (var j:int = 1; j < nVerts; j++) // for each vertex,

			{ // if it's in tree and

				if (!vertexList[j].isInTree && // smaller than old one

					shortestPath[j].distance < minDist) {
					minDist = shortestPath[j].distance;
					indexMin = j; // update minimum

				}
			} // end for

			return indexMin;
		}

		/**
		 * 添加一条边
		 * @param start 边的起点
		 * @param end 边的终点
		 * @param weight 边的权重
		 */
		public function addEdge(start:int, end:int, weight:int):void {
			adjMat[start][end] = weight; //有方向

		}

		/**
		 * 添加一个节点
		 *
		 * @param lab
		 */
		public function addVertex(lab:String):void {
			vertexList[nVerts++] = new Vertex(lab);
		}

	}
}

