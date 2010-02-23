package com.snsoft.util
{
	import flash.utils.ByteArray;

	public class StringUtil
	{
		public function StringUtil()
		{
		}
		
		/**
		 * 获得字符串的字节 
		 * @return 
		 * 
		 */		
		public static function getByteLen(str:String ):int {
			var len:int = -1;
			if(str != null){
			var ba:ByteArray =new ByteArray;
			ba.writeMultiByte (str,"");
			len = ba.length;
			}
			return len;
		}
	}
}