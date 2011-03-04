package com.snsoft.jsondom{
	import com.adobe.serialization.json.JSON;
	import com.snsoft.util.di.DependencyInjection;
	import com.snsoft.util.di.ObjectProperty;
	
	public class JSONDom{
		
		private static const DATA_TYPE_BASE:String = "base";
		
		private static const DATA_TYPE_OBJECT:String = "object";
		
		private static const DATA_TYPE_LIST:String = "list";
		
		private var jsonStr:String;
		
		private var rootNode:JSONNode;
		
		private var jsonObject:Object;
		
		public function JSONDom(jsonStr:String){
			this.jsonStr = jsonStr;
		}
		
		public function parse():JSONNodeList{
			jsonObject = JSON.decode(jsonStr);
			
			var nodeList:JSONNodeList;
			if(dataType(jsonObject) == DATA_TYPE_LIST){
				nodeList = parseNodeList(jsonObject as Array);
			}
			else if(dataType(jsonObject) == DATA_TYPE_OBJECT){
				nodeList = new JSONNodeList();
				var node:JSONNode = parseNode(jsonObject);
				nodeList.pushNode(node);
			}
			return nodeList;
		}
		
		
		private function parseNodeList(obj:Array):JSONNodeList{
			
			var nodeList:JSONNodeList = new JSONNodeList();
			
			return nodeList;
		}
		
		private function parseNode(obj:Object):JSONNode{
			var node:JSONNode = new JSONNode();
			var op:ObjectProperty = new ObjectProperty(obj);
			var names:Vector.<String> = op.dynamicPropertyNames;
			trace(names.length);
			for(var i:int = 0;i < names.length;i ++){
				var name:String = names[i];
				var value:Object = obj[name];
				trace(name,value,dataType(value));
				if(dataType(value) == DATA_TYPE_BASE){
					node.pushAttribute(name,value);
				}
				else if(dataType(value) == DATA_TYPE_LIST){
					var array:Array = value as Array;
					node.pushNodeList(name,parseNodeList(array));
				}
				else {
					var cnode:JSONNode = parseNode(value);
					node.pushAttribute(name,cnode);
				}
			}
			return node;
		}
		
		
		private function dataType(obj:Object):String{
			if(obj is Array){
				return DATA_TYPE_LIST;
			}
			else if(obj is int || obj is uint || obj is Number || obj is String || obj is Boolean){
				return DATA_TYPE_BASE;
			}
			else{
				return DATA_TYPE_OBJECT;
			}
		}
		
	}
}