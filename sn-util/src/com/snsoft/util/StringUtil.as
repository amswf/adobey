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
		
		/**
		 * 编码转换 
		 * @param str
		 * @return 
		 * 
		 */		
		public static function EncodeUtf8(str:String):String {
			if (str != null) {
				var oriByteArr:ByteArray = new ByteArray  ;
				oriByteArr.writeUTFBytes(str);
				var needEncode:Boolean = false;
				for (var i:int=0; i < oriByteArr.length; i+= 2) {
					if (oriByteArr[i]==195||oriByteArr[i]==194) {
						needEncode=true;
						break;
					}
					if (oriByteArr[i]==32) {
						i--;
					}
				}
				if (needEncode) {
					var tempByteArr:ByteArray=new ByteArray  ;
					for (i=0; i < oriByteArr.length; i++) {
						if (oriByteArr[i]==194) {
							tempByteArr.writeByte(oriByteArr[i + 1]);
							i++;
						}
						else if (oriByteArr[i] == 195) {
							tempByteArr.writeByte(oriByteArr[i + 1] + 64);
							i++;
						}
						else {
							tempByteArr.writeByte(oriByteArr[i]);
						}
					}
					tempByteArr.position=0;
					return tempByteArr.readMultiByte(tempByteArr.bytesAvailable,"GBK");
				}
				else {
					return str;
				}
			}
			else {
				return "";
			}
		}
	}
}