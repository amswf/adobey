package com.snsoft.tvc2.text{
	import com.snsoft.util.HashVector;

	public class TextStyles{
		
		public static const HZGBYS:String = "HZGBYS";
		
		public static const SIMHEI:String = "SimHei";
		
		public static const MICROSOFTYAHEI:String = "MicrosoftYaHei";
		
		private static var ts:TextStyles = new TextStyles();
		
		private static var styleHV:HashVector;
		
		//主标题
		public static const STYLE_MAIN_TITLE:String = "mainTitle";
		
		//业务标题
		public static const STYLE_TITLE:String = "title";
		
		//业务农产品名称
		public static const STYLE_GOODS:String = "goods";
		
		//业务日期
		public static const STYLE_DATE_TEXT:String = "dateText";
		
		//坐标系文字
		public static const STYLE_COOR_TEXT:String = "coorText";
		
		//图例文字
		public static const STYLE_CUTLINE_TEXT:String = "cutLineText";
		
		//显示数值文字
		public static const STYLE_DATA_TEXT:String = "dataText";
		
		//显示类型文字
		public static const STYLE_LIST_TYPE_TEXT:String = "listTypeText";
		
		
		public function TextStyles(){
			styleHV = new HashVector();
			styleHV.put(STYLE_MAIN_TITLE,new TextStyle(HZGBYS,40,0xC33137,0xffffff,0x000000,true));
			styleHV.put(STYLE_TITLE,new TextStyle(HZGBYS,28,0xC33137,0xffffff,0x000000,true));
			styleHV.put(STYLE_GOODS,new TextStyle(SIMHEI,20,0x000000,0xffffff,0x000000,true));	
			styleHV.put(STYLE_DATE_TEXT,new TextStyle(SIMHEI,20,0x000000,0xffffff,0x000000,true));
			styleHV.put(STYLE_COOR_TEXT,new TextStyle(SIMHEI,18,0x000000,0xffffff,0x000000,true));
			styleHV.put(STYLE_CUTLINE_TEXT,new TextStyle(SIMHEI,18,0x000000,0xffffff,0x000000,true));
			styleHV.put(STYLE_DATA_TEXT,new TextStyle(SIMHEI,18,0x000000,0xffffff,0x000000,true));
			styleHV.put(STYLE_LIST_TYPE_TEXT,new TextStyle(SIMHEI,20,0x000000,0xffffff,0x000000,true));
		}
		
		public static function getTextStyle(name:String):TextStyle{
			return styleHV.findByName(name) as TextStyle;
		}
	}
}