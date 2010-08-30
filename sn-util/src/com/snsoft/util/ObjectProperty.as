package com.snsoft.util{
	import com.snsoft.xmldom.Node;
	import com.snsoft.xmldom.NodeList;
	import com.snsoft.xmldom.XMLDom;
	import flash.utils.describeType;

	/**
	 * 获得一个类对象的属性名称，包括动态属性名称和静态属性名称 
	 * @author Administrator
	 * 
	 */	
	public class ObjectProperty{
		
		private var _propertyNames:Vector.<String>;
		
		public function ObjectProperty()
		{
		}
		
		/**
		 * 创建对象后，调用此方法，获得某个对象的属性 
		 * @param obj
		 * 
		 */		
		public function getPropertys(obj:Object):void{
			this.propertyNames = new Vector.<String>();
			
			for (var pn:* in obj){
				var dname:String= String(pn);
				this.propertyNames.push(dname);
			}
			
			var xml:XML = describeType(obj);
			trace(xml);
			var xmldom:XMLDom = new XMLDom(xml);
			var node:Node = xmldom.parse();
			var nodeList:NodeList = node.getNodeList("accessor");
			for(var i:int = 0;i < nodeList.length();i ++){
				var cnode:Node = nodeList.getNode(i);
				var sname:String = cnode.getAttributeByName("name");
				this.propertyNames.push(sname);
			}
		}

		public function get propertyNames():Vector.<String>
		{
			return _propertyNames;
		}

		public function set propertyNames(value:Vector.<String>):void
		{
			_propertyNames = value;
		}

	}
}