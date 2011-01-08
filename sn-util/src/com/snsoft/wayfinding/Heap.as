package com.snsoft.wayfinding{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	
	/**
	 * 堆排序 
	 * @author Administrator
	 * 
	 */	
	public class Heap{
				
		private var nodevv:Vector.<Vector.<HeapNode>>= new Vector.<Vector.<HeapNode>>();
		
		private var rootNode:HeapNode = new HeapNode();
		
		public function Heap(ivv:Vector.<Vector.<Boolean>>){
			for (var i:int = 0; i< ivv.length; i++) {
				var ivlen:int = ivv[i].length;
				var nv:Vector.<HeapNode> = new Vector.<HeapNode>(ivlen);
				nodevv.push(nv);
			}
		}
		
		public function push(current:Point,parent:Point = null):void{
			var heapNode:HeapNode = new HeapNode();
			var parentName:String = null;			 
			heapNode.parentPoint = parent;
			heapNode.value = current;
			nodevv[current.y][current.x] = heapNode;
			
			//trace(getSort(current));
		}
		
		public function getSort(p:Point):Vector.<Point>{
			var pv:Vector.<Point> = new Vector.<Point>();
			var np:Point = p.clone();
			for(;np != null;){
				var node:HeapNode = nodevv[np.y][np.x];
				pv.push(node.value);
				np = node.parentPoint;
			}
			var len:int = pv.length;
			var npv:Vector.<Point> = new Vector.<Point>(len);
			for(var i:int = 0;i<len;i++){
				npv[len - 1 - i] = pv[i];
			}
			return npv;
		}
	}
}