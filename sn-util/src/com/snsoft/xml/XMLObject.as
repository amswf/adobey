package com.snsoft.xml
{
	/**
	 * XML数据对象 
	 * @author Administrator
	 * 
	 */	
	public class XMLObject
	{
		/**
		 * 类的属性，基本数据类型String 
		 */		
		private var propertyArray:Array = new Array();
		
		/**
		 * 状态数据，当前XML的状态描述信息 
		 */		
		private var stateArray:Array = new Array();
		
		/**
		 * 类的列表数据，对应 Array 或 List
		 */		
		private var listArray:Array = new Array();
		
		/**
		 * XML数据对象的子XML数据对象 
		 */		
		private var objectArray:XMLObject = new XMLObject();
		
		public function XMLObject()
		{
		}
		
		/**
		 * 添加类的属性
		 * @param name
		 * @param value
		 * 
		 */		
		public function addProperty(name:String,value:String):void{
			if(name != null && name.length > 0){
				this.propertyArray["name"] = value;
			}
		}
		
		/**
		 * 读取类的属性 
		 * @param name
		 * @return 
		 * 
		 */		
		public function getPropertyByName(name:String):String{
			if(name != null && name.length > 0){
				return this.propertyArray["name"];
			}	
			return null;
		}
		
		public 
	}
}