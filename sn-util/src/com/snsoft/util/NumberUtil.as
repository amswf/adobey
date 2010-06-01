package com.snsoft.util{
	public class NumberUtil{
		public function NumberUtil()
		{
		}
		
		/**
		 * 格式化小数保留N位小数,并四舍五入
		 * @param num 要格式化的数字
		 * @param smallDigital 格式化后的小数位数
		 * @return 
		 * 
		 */		
		public static function formatStr(num:Number,smallDigital:int = 0):String {
			var numStr:String = String(num);
			if(!isNaN(num)){
				if(smallDigital < 0 ){
					smallDigital = 0;
				}
				
				var newNum:Number = Math.round( num * Math.pow(10,smallDigital));
				var str:String = String(newNum);
				if(smallDigital > 0){
					var integerStr:String = str.substring(0,str.length - smallDigital);
					var decimalStr:String = str.substring(str.length - smallDigital,str.length);
					numStr = integerStr + "." + decimalStr;
				}
				else{
					numStr = str; 
				}
			}
			return numStr;
		}
	}
}