package com.snsoft.tvc2.text{
	import com.snsoft.util.HashVector;

	public class TextStyles{
		
		public static const SONGTI:String = "宋体";
		
		public static const HEITI:String = "黑体";
		
		private static var ts:TextStyles = new TextStyles();
		
		private static var styleHV:HashVector;
		
		public static const STYLE_TITLE:String = "title";
		
		public static const STYLE_GOODS:String = "goods";
		
		public static const STYLE_DATE_TEXT:String = "dateText";
		
		
		public function TextStyles(){
			styleHV = new HashVector();
			styleHV.put(STYLE_TITLE,new TextStyle(HEITI,28,0xC33137));
			styleHV.put(STYLE_GOODS,new TextStyle(HEITI,20,0x131313));	
			styleHV.put(STYLE_DATE_TEXT,new TextStyle(HEITI,20,0x131313));
		}
		
		public static function getTextStyle(name:String):TextStyle{
			return styleHV.findByName(name) as TextStyle;
		}
	}
}