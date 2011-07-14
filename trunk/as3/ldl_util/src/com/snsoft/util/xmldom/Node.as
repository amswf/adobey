package com.snsoft.util.xmldom {
	import com.snsoft.util.HashVector;
	import com.snsoft.util.di.DependencyInjection;
	import com.snsoft.util.xmldom.Attributes;

	import flash.utils.getDefinitionByName;

	public class Node {

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

		/**
		 * 标签名称
		 */
		private var _name:String;

		/**
		 * 标签文本
		 */
		private var _text:String;

		/**
		 * 构造方法
		 *
		 */
		public function Node() {
		}

		/**
		 * 属性
		 * @param name
		 * @param value
		 *
		 */
		internal function pushAttribute(name:String, value:String):void {
			attribute.push(name, value);
		}

		public function attrToObj(obj:Object):void {
			if (obj != null) {
				for (var i:int = 0; i < attribute.length(); i++) {
					var name:String = attribute.getNameByIndex(i);
					obj[name] = attribute.getByIndex(i);
				}
			}
		}

		/**
		 * 当前结点的属性值用子文本结点表示时适用
		 * @param obj
		 *
		 */
		public function childNodeTextTObj(obj:Object):void {
			if (obj != null) {
				for (var i:int = 0; i < childNodeLists.length; i++) {
					var name:String = childNodeLists.findNameByIndex(i);
					var cNode:Node = this.getNodeListFirstNode(name);
					obj[name] = cNode.text;
				}
			}
		}

		/**
		 * 根据类，把 XML属性映射 (ORM)对象数据
		 * @param OrmClass
		 *
		 */
		public function ormAttribute(OrmClass:Class = null):Object {
			var obj:Object;
			var judgeProperty:Boolean = false;
			try {
				if (OrmClass != null) {
					obj = new OrmClass();
					judgeProperty = true;
				}
				else {
					obj = new Object();
					judgeProperty = false;
				}
				for (var i:int = 0; i < attribute.length(); i++) {
					var aName:String = attribute.getNameByIndex(i);
					var aValue:String = attribute.getByIndex(i);
					if (aValue != null) {
						DependencyInjection.diValueToObj(obj, aName, aValue, judgeProperty);
					}
				}
			}
			catch (e:Error) {

			}
			return obj;
		}

		/**
		 * 属性
		 * @param name
		 * @return
		 *
		 */
		public function getAttributeByName(name:String):String {
			return attribute.getByName(name);
		}

		/**
		 * 属性
		 * @param index
		 * @return
		 *
		 */
		public function getAttributeByIndex(index:int):String {
			return attribute.getByIndex(index);
		}

		/**
		 * 名为name子结点列表
		 * @param name
		 * @return
		 *
		 */
		public function getNodeList(name:String):NodeList {
			return childNodeLists.findByName(name) as NodeList;
		}

		/**
		 * 名为name子结点列表的第一个结点
		 * @param name
		 * @return
		 *
		 */
		public function getNodeListFirstNode(name:String):Node {
			var list:NodeList = getNodeList(name);
			if (list != null && list.length() > 0) {
				return list.getNode(0);
			}
			return null;
		}

		/**
		 * 子结点
		 * @param name
		 * @param nodeList
		 *
		 */
		internal function pushNodeList(name:String, nodeList:NodeList):void {
			childNodeLists.push(nodeList, name);
		}

		public function get name():String {
			return _name;
		}

		public function set name(value:String):void {
			_name = value;
		}

		public function get text():String {
			return _text;
		}

		public function set text(value:String):void {
			_text = value;
		}

		/**
		 * NodeList 的列表
		 *
		 * HashVector.<NodeList>
		 */
		internal function get childNodeLists():HashVector {
			return _childNodeLists;
		}

		/**
		 * @private
		 */
		internal function set childNodeLists(value:HashVector):void {
			_childNodeLists = value;
		}

	}
}
