package com.snsoft.util.xmldom{
	import ascb.util.StringUtilities;
	
	import com.snsoft.util.HashVector;
	
	/**
	 * 解析XML为基本树，数据持久化
	 *  
	 * @author Administrator
	 * 
	 */	
	public class XMLDom{
		
		private var xml:XML
		
		public function XMLDom(xml:XML){
			this.xml = xml;
		}
		
		/**
		 * 解析XML为树对象 
		 * @return 
		 * 
		 */		
		public function parse():Node{
			//trace("parse",xml);
			var xdNode:Node = parseXML(xml);
			return xdNode;
		}
		
		/**
		 * 解析结点下的子结点 
		 * @param xml
		 * @return 
		 * 
		 */		
		private function parseXMLList(xml:XML):HashVector{
			//trace("parseXMLList",xml);
			var childNodeLists:HashVector = new HashVector();
			var xmlChildNames:HashVector = new HashVector();
			
			var xmlChildren:XMLList = xml.children();
			for(var i:int = 0;i<xmlChildren.length();i++){
				var xmlChild:XML = xmlChildren[i];
				var name:String = xmlChild.name();
				if(xmlChildNames.findByName(name) == null){
					xmlChildNames.push(name,name);
				}
			}
			
			for(var i2:int = 0;i2<xmlChildNames.length;i2++){
				var nodeList:NodeList = new NodeList();
				var childName:String = xmlChildNames.findByIndex(i2) as String;
				var xmlElements:XMLList = xml.elements(childName);
				//trace(xmlElements.length(),childName,xmlElements);
				for(var j2:int = 0;j2 < xmlElements.length();j2++){
					var cxml:XML = xmlElements[j2];
					
					var node:Node = parseXML(cxml);
					nodeList.pushNode(node);
				}
				childNodeLists.push(nodeList,childName);
			}
			return childNodeLists;
		}
		
		/**
		 * 解析获得结点 
		 * @param xml
		 * @return 
		 * 
		 */		
		private function parseXML(xml:XML):Node{
			//trace("parseXML",xml);
			var node:Node = new Node();
			node.name = xml.name();
			node.text = xml.text();
			var atts:HashVector = getXMLAttributes(xml);
			for(var i:int = 0;i<atts.length;i++){
				var name:String = atts.findNameByIndex(i);
				var value:String = atts.findByIndex(i) as String;
				node.pushAttribute(name,value);
			}
			
			var childNodeLists:HashVector;
			if(xml.hasComplexContent()){
				childNodeLists = parseXMLList(xml);
			}
			else {
				childNodeLists = new HashVector();
			}
			node.childNodeLists = childNodeLists;
			return node;
		}
		
		/**
		 * 获得属性结点列表
		 * @param xml
		 * @return 
		 * 
		 */		
		private function getXMLAttributes(xml:XML):HashVector{
			//trace("getXMLAttributes",xml);
			var hv:HashVector = new HashVector();
			var attributeXMLList:XMLList = xml.attributes();
			for(var i:int = 0;i < attributeXMLList.length();i++){
				var varAttributeXML:XML = attributeXMLList[i];
				var name:String = varAttributeXML.name();
				var value:String = varAttributeXML.toString();
				if(!isEffective(value)){
					value = null;
				}
				if(isEffective(name)){
					hv.push(value,name);
				}
			}
			return hv;
		}
		
		private function isEffective(...str):Boolean{
			if(str != null){
				if(str.length > 0){
					var n:int = 0;
					for(var i:int = 0;i < str.length;i++){
						var s:Object = str[i];
						if(s != null && StringUtilities.trim(String(s)).length > 0){
							n ++;
						}
					}
					if(n == str.length){
						return true;
					}
				}
			} 
			return false;
		}
	}
}