package com.snsoft.wayfinding{
	public class HeapNode{
		
		private var _parentNode:HeapNode;
		
		private var _value:Object;
		
		private var _childNodes:Vector.<HeapNode> = new Vector.<HeapNode>();
		
		public function HeapNode(){
			
		}
		
		
		public function pushChild(heapNode:HeapNode):void{
			_childNodes.push(heapNode);
		}

		public function get childNodes():Vector.<HeapNode>
		{
			return _childNodes;
		}

		public function get value():Object
		{
			return _value;
		}

		public function set value(value:Object):void
		{
			_value = value;
		}

		public function get parentNode():HeapNode
		{
			return _parentNode;
		}

		public function set parentNode(value:HeapNode):void
		{
			_parentNode = value;
		}
	}
}