package com.snsoft.util
{
	import flash.utils.ByteArray;
	
	public class StringUtil
	{
		public function StringUtil()
		{
		}
		
		/**
		 * 修复文本化的转意字符
		 * @param str
		 * @return 
		 * 
		 */		
		public static function replaceAll(str:String,pattern:String,repl:String):String{
			var ctext:String = null;
			if(str != null){
				ctext = "";
				var array:Array = str.split(pattern);
				for (var i:int = 0; i<array.length; i++) {
					var str:String = String(array[i]);
					if (i != 0) {
						ctext += repl;
					}
					ctext += str;
				}
			}
			return ctext;
		}
		
		/**
		 * 修复文本化的回车换行转意字符
		 * @param str
		 * @return 
		 * 
		 */		
		public static function replaceAllCRLF(str:String):String{
			var crlf:String = replaceAll(str,"\\r","\r");
			crlf = replaceAll(crlf,"\\n","\n");
			return crlf;
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
		 * 截取中文字符串，按照字节长度截取，汉字双字节截取，截取后长度可能小于指定长度一位。 
		 * @param str
		 * @param byteLength
		 * @return 
		 * 
		 */		
		public static function subCNStr(str:String,byteLength:int):String {
			var n:int = 0;
			
			var subStr:String = null;
			if(str != null){
				subStr = "";
				for(var i:int =0;i<byteLength;i++){
					var code:int = str.charCodeAt(i);
					if(code >= 256 && n + 2 <= byteLength){
						n += 2;
						subStr += str.charAt(i);
					}
					else if(code < 256 && n + 1 <= byteLength)  {
						n += 1;
						subStr += str.charAt(i);
					}
					else {
						break;
					}
				}
			}
			return subStr;
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