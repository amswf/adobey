package com.snsoft.util.wayfinding{
	import flash.geom.Point;
	
	
	/**
	 * 树排序 
	 * @author Administrator
	 * 
	 */	
	public class Way{
				
		/**
		 * 树里面所有结点列表 
		 */		
		private var nodevv:Vector.<Vector.<WayNode>>= new Vector.<Vector.<WayNode>>();
		
		/**
		 * 初始化 
		 * @param ivv
		 * 
		 */		
		public function Way(ivv:Vector.<Vector.<Boolean>>){
			//初始化结点列表
			for (var i:int = 0; i< ivv.length; i++) {
				var ivlen:int = ivv[i].length;
				var nv:Vector.<WayNode> = new Vector.<WayNode>(ivlen);
				nodevv.push(nv);
			}
		}
		
		/**
		 * 树增加结点 
		 * @param current
		 * @param parent
		 * 
		 */		
		public function push(current:Point,parent:Point = null):void{
			var wayNode:WayNode = new WayNode();
			var parentName:String = null;			 
			wayNode.parentPoint = parent;
			wayNode.point = current;
			nodevv[current.y][current.x] = wayNode;
		}
		
		/**
		 * 获得某个页点到根结点的路径 
		 * @param p
		 * @return 
		 * 
		 */		
		public function getSort(p:Point):Vector.<Point>{
			var pv:Vector.<Point> = new Vector.<Point>();
			var np:Point = p.clone();
			
			//从叶结点搜索父结点，根结点结束
			for(;np != null;){
				var node:WayNode = nodevv[np.y][np.x];
				pv.push(node.point);
				np = node.parentPoint;
			}
			var len:int = pv.length;
			var npv:Vector.<Point> = new Vector.<Point>(len);
			
			//pv是倒序的，反序一下，根结点下标为0
			for(var i:int = 0;i<len;i++){
				npv[len - 1 - i] = pv[i];
			}
			return npv;
		}
	}
}