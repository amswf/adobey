package com.snsoft.tvc2.util{
	import ascb.util.StringUtilities;

	/**
	 * 字符串工具 
	 * @author Administrator
	 * 
	 */	
	public class StringUtil{
		public function StringUtil()
		{
		}
		
		/**
		 * 字符串是否有效数据 
		 * @param str
		 * @return 
		 * 
		 */		
		public static function isEffective(...str):Boolean{
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