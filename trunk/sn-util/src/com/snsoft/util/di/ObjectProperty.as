package com.snsoft.util.di{
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
		
		/**
		 * 对象固有属性 
		 */		
		private var _propertyNames:Vector.<String>;
		
		/**
		 * 对象动态属性 
		 */
		private var _dynamicPropertyNames:Vector.<String>;
		
		/**
		 * 静态属性信息描述文件的属性标签 
		 */		
		public static const DESCRIBE_TAG_ACCESSOR:String = "accessor";
		
		/**
		 * 描述标签名称 
		 */		
		public static const DESCRIBE_TAG_NAME:String = "name";
		
		/**
		 * 构造方法 
		 * @param obj
		 * 
		 */		
		public function ObjectProperty(obj:Object){
			getPropertys(obj);
		}
		
		/**
		 * 创建对象后，调用此方法，获得某个对象的属性 
		 * @param obj 要获得属性的对象
		 * 
		 */		
		private function getPropertys(obj:Object):void{
			this._propertyNames = new Vector.<String>();
			this._dynamicPropertyNames = new Vector.<String>();
			
			//动态属性
			for (var pn:* in obj){
				var dname:String= String(pn);
				this._dynamicPropertyNames.push(dname);
			}
			
			//静态属性
			var xml:XML = describeType(obj);
			//trace(xml);
			var xmldom:XMLDom = new XMLDom(xml);
			var node:Node = xmldom.parse();
			var nodeList:NodeList = node.getNodeList(DESCRIBE_TAG_ACCESSOR);
			for(var i:int = 0;i < nodeList.length();i ++){
				var cnode:Node = nodeList.getNode(i);
				var sname:String = cnode.getAttributeByName(DESCRIBE_TAG_NAME);
				this._propertyNames.push(sname);
			}
		}

		public function get propertyNames():Vector.<String>
		{
			return _propertyNames;
		}

		/**
		 * 对象动态属性 
		 */
		public function get dynamicPropertyNames():Vector.<String>
		{
			return _dynamicPropertyNames;
		}

	}
}