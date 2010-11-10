package com.snsoft.util
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class TextFieldUtil
	{
		public function TextFieldUtil()
		{
		}
		
		/**
		 * 获得TextField单行显示最适合宽度 
		 * @param textField TextField
		 * @return 宽度
		 * 
		 */		
		public static function calculateWidth(textField:TextField):Number{
			var width:Number = 0;
			if(textField != null && textField.text != null){
				var tft:TextFormat = textField.getTextFormat();
				var size:int = tft.size as int;
				var text:String = textField.text;
				var len:int = StringUtil.getByteLen(text);
				width = 0.5 * size * len + 6;
			}
			return width;
		}
		
		public static function calculateBoldWidth(textField:TextField):Number{
			var width:Number = 0;
			if(textField != null && textField.text != null){
				var tft:TextFormat = textField.getTextFormat();
				var size:int = tft.size as int;
				var text:String = textField.text;
				var len:int = StringUtil.getByteLen(text);
				width = 0.5 * (size + 1) * len + 6;
			}
			return width;
		}
		
		public static function fitSize(textField:TextField):void{
			if(textField != null && textField.text != null){
				textField.width = calculateWidth(textField);
				var tft:TextFormat = textField.getTextFormat();
				textField.height = tft.size + 6;
			}
		}
		
		public static function fitText(textField:TextField):void{
			var tft:TextFormat = textField.getTextFormat();
			var n:int = int((textField.width - 6) * 2 / int(tft.size));
			var txt:String = textField.text;
			if(StringUtil.getByteLen(txt) > n){
				txt = StringUtil.subCNStr(txt,n - 1)+"...";
				textField.text = txt;
			}
		}
	}
}