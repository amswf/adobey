package com.snsoft.util{
	public class ComboBoxUtil{
		public function ComboBoxUtil()
		{
		}
		
		/**
		 * 创建列表项 
		 * @param name
		 * @param value
		 * @return 
		 * 
		 */		
		public static function creatCBIterm(name:String,value:Object):Object {
			var obj:Object = new Object();
			obj.label = name;
			obj.data = value;
			return obj;
		}
	}
}