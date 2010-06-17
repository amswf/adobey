package com.snsoft.tvc2.util{
	import ascb.util.StringUtilities;

	public class NumberUtil{
		public function NumberUtil()
		{
		}
		
		/**
		 * 数值是否有效 
		 * @return 
		 * 
		 */		
		public static function isEffective(num:Object):Boolean{
			if(num == null){
				return false;
			}
			var str:String = StringUtilities.trim(String(num));
			if(str.length <=0){
				return false;
			}
			
			var n:Number = Number(num);
			if(isNaN(n)){
				return false;
			}
			return true;
		}
	}
}