package com.snsoft.xmldom{
	import com.snsoft.util.HashVector;
	import com.snsoft.xmldom.Attributes;

	public class Node{
		
		/**
		 * 属性
		 * 
		 * HashVector.<VarDO>
		 */		
		private var attribute:Attributes = new Attributes();
		
		/**
		 * NodeList 的列表
		 * 
		 * HashVector.<NodeList>
		 */		
		private var _childNodeLists:HashVector = new HashVector();
		
		public function Node()
		{
		}
		
		/**
		 * 属性
		 * @param name
		 * @param value
		 * 
		 */		
		public function pushAttribute(name:String,value:String):void{
			attribute.push(name,value);
		}
		
		/**
		 * 属性
		 * @param name
		 * @return 
		 * 
		 */		
		public function getAttributeByName(name:String):String{
			return attribute.getByName(name);
		}
		
		/**
		 * 属性
		 * @param index
		 * @return 
		 * 
		 */		
		public function getAttributeByIndex(index:int):String{
			return attribute.getByIndex(index);
		}
		
		/**
		 * 子结点
		 * @param name
		 * @return 
		 * 
		 */		 	
		public function getNodeList(name:String):NodeList{
			return childNodeLists.findByName(name) as NodeList;
		}
		
		/**
		 * 子结点
		 * @param name
		 * @param nodeList
		 * 
		 */		
		public function pushNodeList(name:String,nodeList:NodeList):void{
			childNodeLists.put(name,nodeList);
		}

		/**
		 * 子结点
		 *  
		 * HashVector.<NodeList>
		 */
		public function get childNodeLists():HashVector
		{
			return _childNodeLists;
		}

		/**
		 * @private
		 */
		public function set childNodeLists(value:HashVector):void
		{
			_childNodeLists = value;
		}

	}
}