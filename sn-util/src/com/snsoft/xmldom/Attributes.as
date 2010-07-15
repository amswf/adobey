package com.snsoft.xmldom{
	import com.snsoft.util.HashVector;

	public class Attributes{
		
		public static const NAME:String = "name";
		/**
		 * 参数对像 
		 */		
		private var hv:HashVector = new HashVector();
		
		public function Attributes(){
		
		}
		
		/**
		 * 设置属性
		 * @param name
		 * @param value
		 * 
		 */		
		public function push(name:String,value:String):void{
			hv.put(name,value);
		}
		
		/**
		 * 获得属性 
		 * @param name
		 * @return 
		 * 
		 */		
		public function getByName(name:String):String{
			return hv.findByName(name) as String;
		}
		
		/**
		 * 获得属性 
		 * @param name
		 * @return 
		 * 
		 */		
		public function getByIndex(index:int):String{
			return hv.findByIndex(index) as String;
		}
	}
}