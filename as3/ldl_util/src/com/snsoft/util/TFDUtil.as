package com.snsoft.util {
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * Textfield 工具类
	 * @author Administrator
	 *
	 */
	public class TFDUtil {
		public function TFDUtil() {
		}

		/**
		 * 创建一个适合宽度的Textfield，字符超出时截断并以 endText结尾
		 * @param text
		 * @param tft
		 * @param maxWidth
		 * @param endText
		 * @return
		 *
		 */
		public static function creatTextInline(text:String, tft:TextFormat, maxWidth:int = 0, endText:String = "..."):TextField {
			var tfd:TextField = new TextField();
			tfd.defaultTextFormat = tft;
			tfd.autoSize = TextFieldAutoSize.LEFT;
			if (text != null) {
				if (maxWidth > 0 && text.length > 0) {
					var endtfd:TextField = new TextField();
					endtfd.defaultTextFormat = tft;
					endtfd.autoSize = TextFieldAutoSize.LEFT;
					endtfd.text = endText;
					var w:int = endtfd.textWidth;
					var x:int = 0;
					var ary:Array = text.split("");
					var sign:Boolean = false;
					var ct:String = "";
					for (var i:int = 0; i < ary.length; i++) {
						var str:String = ct + ary[i];
						tfd.text = str;
						if (w + tfd.textWidth <= maxWidth) {
							ct = str;
						}
						else {
							tfd.text = ct;
							sign = true;
							break;
						}
					}
					if (sign) {
						ct += endText;
						tfd.text = ct;
					}
				}
				else {
					tfd.text = text;
				}
			}
			return tfd;
		}

		
		/**
		 * 
		 * @param text
		 * @param tft
		 * @param maxWidth
		 * @param maxHeight
		 * @param endText
		 * @return 
		 * 
		 */		
		public static function creatTextMultiLine(text:String, tft:TextFormat, maxWidth:int, maxHeight:int, endText:String = "..."):TextField {
			var tfd:TextField = new TextField();
			tfd.defaultTextFormat = tft;
			tfd.autoSize = TextFieldAutoSize.LEFT;
			tfd.multiline = true;
			tfd.wordWrap = true;
			tfd.width = maxWidth;
			if (text != null) {
				if (maxWidth > 0 && text.length > 0) {
					var ary:Array = text.split("");
					var sign:Boolean = false;
					var ct:String = "";
					for (var i:int = 0; i < ary.length; i++) {
						var str:String = ct + ary[i] + endText;
						tfd.text = str;
						if (tfd.height <= maxHeight) {
							ct += ary[i];
						}
						else {
							sign = true;
							break;
						}
					}
					if (sign) {
						tfd.text = ct + endText;
					}
					else {
						tfd.text = ct;
					}
				}
				else {
					tfd.text = text;
				}
			}
			return tfd;
		}
	}
}
