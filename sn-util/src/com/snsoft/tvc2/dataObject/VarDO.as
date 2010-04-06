package com.snsoft.tvc2.dataObject{
	import com.snsoft.util.HashVector;

	public class VarDO{
		
		public static const NAME:String = "name";
		/**
		 * 参数对像 
		 */		
		private var hv:HashVector = new HashVector();
		
		public function VarDO(){
		
		}
		
		/**
		 * 设置属性
		 * @param name
		 * @param value
		 * 
		 */		
		public function setAttribute(name:String,value:Object):void{
			hv.put(name,value);
		}
		
		/**
		 * 获得属性 
		 * @param name
		 * @return 
		 * 
		 */		
		public function getAttribute(name:String):Object{
			return hv.findByName(name);
		}
	}
}