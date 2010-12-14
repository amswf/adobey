package com.snsoft.jsondom{
	import com.snsoft.util.HashVector;

	/**
	 * 结点名称相同的一组子结点 
	 * @author Administrator
	 * 
	 */	
	public class JSONNodeList{
		
		/**
		 * 同名结点结点列表 
		 */		
		private var nodes:Vector.<JSONNode> = new Vector.<JSONNode>();
		
		
		public function JSONNodeList(){
		}
		
		/**
		 * 结点 
		 * @param name
		 * @param node
		 * 
		 */		
		internal function pushNode(node:JSONNode):void{
			nodes.push(node);
		}
		
		/**
		 * 结点
		 * @param index
		 * @return 
		 * 
		 */		
		public function getNode(index:int):JSONNode{
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