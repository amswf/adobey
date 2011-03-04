package com.snsoft.jsondom{
	import com.snsoft.util.HashVector;

	public class Attributes{
		
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
		public function push(name:String,value:Object):void{
			hv.push(value,name);
		}
		
		/**
		 * 获得属性 
		 * @param name
		 * @return 
		 * 
		 */		
		public function getByName(name:String):Object{
			return hv.findByName(name);
		}
		
		/**
		 * 获得属性 
		 * @param name
		 * @return 
		 * 
		 */		
		public function getByIndex(index:int):Object{
			return hv.findByIndex(index);
		}
		
		/**
		 * 获得属性 
		 * @param name
		 * @return 
		 * 
		 */		
		public function getNameByIndex(index:int):String{
			return hv.findNameByIndex(index) as String;
		}
		
		public function length():int{
			return hv.length;
		}
	}
}