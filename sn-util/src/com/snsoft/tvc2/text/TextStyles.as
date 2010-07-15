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
		
		//底部文字
		public static const STYLE_MAIN_BOTTOM:String = "mainBottom";
		
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
		
		//伴音文字显示
		public static const STYLE_SOUND_TEXT:String = "soundText";
		
		
		/**
		 * 此类不能  new 创建 
		 * 
		 */		
		public function TextStyles(){
			styleHV = new HashVector();
		}
		
		public static function getTextStyle(name:String):TextStyle{
			return styleHV.findByName(name) as TextStyle;
		}
		
		public static function pushTextStyle(name:String,textStyle:TextStyle):void{
			styleHV.put(name,textStyle);
		}
	}
}