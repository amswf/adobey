package com.snsoft.xmldom{
	import com.snsoft.util.HashVector;

	/**
	 * 结点名称相同的一组子结点 
	 * @author Administrator
	 * 
	 */	
	public class NodeList{
		
		/**
		 * 同名结点结点列表 
		 */		
		private var nodes:Vector.<Node> = new Vector.<Node>();
		
		
		public function NodeList(){
		}
		
		/**
		 * 结点 
		 * @param name
		 * @param node
		 * 
		 */		
		public function pushNode(node:Node):void{
			nodes.push(node);
		}
		
		/**
		 * 结点
		 * @param index
		 * @return 
		 * 
		 */		
		public function getNode(index:int):Node{
			if(index >= 0 && index < nodes.length){
				return nodes[index];
			}
			return null;
		}
		
		/**
		 * 列表长度 
		 * @return 
		 * 
		 */		
		public function length():int{
			return nodes.length;
		}
	}
}