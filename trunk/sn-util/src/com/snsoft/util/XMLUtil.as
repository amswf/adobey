package com.snsoft.util
{
	public class XMLUtil
	{
		public function XMLUtil()
		{
		}
		
		public static function formatXML(xml:XML):String {
			var tagNum:int = 0;
			var fstr:String = "";
			var str:String = xml.toString();
			var alist:Array = str.split("");
			for (var i:int = 0; i < alist.length; i++) {
				var item:String = alist[i];
				var tagStr:String = "";
				if (item == ">") {
					var ls:String = getLeftTagType(alist, i);
					var rs:String = getRightTagType(alist, i);
					if (ls == "< >" && rs == "< >") {
						tagNum++;
						tagStr = getTagStr(tagNum);
					}
					else if (ls == "</ >" && rs == "</ >") {
						tagNum--;
						tagStr = getTagStr(tagNum);
					}
					else if (ls == "</ >" && rs == "< >") {
						tagStr = getTagStr(tagNum);
					}
					else if (ls == "< >" && rs == "< />") {
						tagNum++;
						tagStr = getTagStr(tagNum);
					}
					else if (ls == "< />" && rs == "</ >") {
						tagNum--;
						tagStr = getTagStr(tagNum);
					}
					else if (ls == "< >" && rs == "</ >") {
						tagStr = "";
					}
				}
				fstr = fstr + item + tagStr;
			}
			return fstr;
		}
		
		
		//生成回车，空格
		private static function getTagStr(tageNum:int):String {
			var str:String = "";
			for (var i:int = 0; i < tageNum; i++) {
				str = str + "  ";
			}
			return "\r\n" + str;
		}
		
		//获得当前字符之前的最后标签
		private static function getLeftTagType(list:Array, index:Number):String {
			if (index >= 0 && index <= list.length) {
				for (var i:int = index; i >= 0; i--) {
					if (list[i] == "<") {
						if ((i + 1) <= list.length && list[i + 1] == "/") {
							return "</ >";
						}
						if ((i + 1) <= list.length && list[i + 1] == "!") {
							return "<! >";
						}
						if ((index - 1) >= 0 && list[index - 1] == "/") {
							return "< />";
						}
						else {
							return "< >";
						}
					}
				}
			}
			return null;
		}
		
		
		//获得当前字符之后的第一个标签
		private static function getRightTagType(list:Array, index:Number):String {
			
			if (index + 1 <= list.length) {
				for (var i:int = index + 1; i < list.length; i++) {
					if (list[i] == ">") {
						return getLeftTagType(list, i);
					}
				}
			}
			return null;
		}
	}
}