package com.snsoft.tvc2.util{
	import ascb.util.StringUtilities;

	public class StringUtil{
		public function StringUtil()
		{
		}
		
		public static function isEffective(...str):Boolean{
			if(str != null){
				if(str.length > 0){
					var n:int = 0;
					for(var i:int = 0;i < str.length;i++){
						var s:String = String(str[i]);
						if(StringUtilities.trim(s).length > 0){
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