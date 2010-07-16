package com.snsoft.tvc2.dataObject{
	import com.snsoft.util.HashVector;
	
	/**
	 * 变量对象
	 * @author Administrator
	 * 
	 */
	public class VarDO{
		
		public static const NAME:String = "name";
		
		//变量属性和值列表
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