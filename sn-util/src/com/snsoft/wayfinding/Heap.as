package com.snsoft.wayfinding{
	import com.snsoft.util.HashVector;
	
	import flash.geom.Point;
	
	
	/**
	 * 堆排序 
	 * @author Administrator
	 * 
	 */	
	public class Heap{
				
		private var nodeList:HashVector = new HashVector();
		
		private var rootNode:HeapNode = new HeapNode();
		
		public function Heap(){
		}
		
		public function push(current:Point,parent:Point = null):void{
			var heapNode:HeapNode = new HeapNode();
			var parentNode:HeapNode = null;
			if(parent != null){
				var pname:String = creatPointName(parent);
				parentNode = nodeList.findByName(pname) as HeapNode;
			}
			else{
				parentNode = this.rootNode;
			}
			heapNode.parentNode = parentNode;
			heapNode.value = current;
			var cname:String = creatPointName(current);
			nodeList.push(heapNode,cname);
		}
		
		public function getSort(p:Point):Vector.<Point>{
			var name:String = creatPointName(p);
			var pv:Vector.<Point> = new Vector.<Point>();
			var node:HeapNode = nodeList.findByName(name) as HeapNode;
			for(;node != null && node.value != null;){
				pv.push(node.value);
				node = node.parentNode;
			}
			var len:int = pv.length;
			var npv:Vector.<Point> = new Vector.<Point>(len);
			for(var i:int = 0;i<len;i++){
				npv[len - 1 - i] = pv[i];
			}
			return npv;
		}
		
		private function creatPointName(p:Point):String{
			return p.x + "_" + p.y;
		}
	}
}