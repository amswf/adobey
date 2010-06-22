package com.snsoft.tvc2.util{
	import ascb.util.StringUtilities;

	public class StringUtil{
		public function StringUtil()
		{
		}
		
		public static function isEffective(str:String):Boolean{
			if(str != null){
				if(StringUtilities.trim(str).length > 0){
					return true;
				}
			} 
			return false;
		}
	}
}