package com.snsoft.tsp3.plugin.news.layout {
	import com.snsoft.tsp3.net.DataParam;

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Util {
		public function Util() {
		}

		public static function contentItem(dataParam:DataParam, textTft:TextFormat, ctntTft:TextFormat, width:int, height:int):Sprite {
			var spr:Sprite = new Sprite();
			if (dataParam != null && dataParam.text != null) {
				var text:String = dataParam.text + "：";
				var ctnt:String = text;
				if (dataParam.content != null) {
					ctnt = text + dataParam.content;
				}
				var tfd:TextField = creatTextMultiLine(ctnt, ctntTft, width, height);
				tfd.setTextFormat(textTft, 0, text.length);
				spr.addChild(tfd);
			}
			return spr;
		}

		/**
		 * 标题和其它信息显示
		 *
		 * 其它信息左对齐
		 * @param textTft
		 * @param ctntTft
		 * @param maxWidth
		 * @param titleParam
		 * @param expParams
		 * @return
		 *
		 */
		public static function twsLeft(textTft:TextFormat, ctntTft:TextFormat, maxWidth:int, boader:int, titleParam:DataParam, expParams:Vector.<DataParam>):Sprite {
			var spr:Sprite = new Sprite();
			if (titleParam != null) {
				var title:Sprite = lineItem(titleParam.text, titleParam.content, textTft, ctntTft, maxWidth / 2);
				spr.addChild(title);
				var exp:Sprite = lineItems(expParams, textTft, ctntTft, maxWidth / 2, boader);
				spr.addChild(exp);
				exp.x = title.width + boader;
			}
			return spr;
		}

		/**
		 * 标题和其它信息显示
		 *
		 * 其它信息右对齐
		 * @param textTft
		 * @param ctntTft
		 * @param maxWidth
		 * @param titleParam
		 * @param expParams
		 * @return
		 *
		 */
		public static function twsRight(textTft:TextFormat, ctntTft:TextFormat, maxWidth:int, boader:int, titleParam:DataParam, expParams:Vector.<DataParam>):Sprite {
			var spr:Sprite = new Sprite();
			if (titleParam != null) {
				var title:Sprite = lineItem(titleParam.text, titleParam.content, textTft, ctntTft, maxWidth / 2);
				spr.addChild(title);
				var exp:Sprite = lineItems(expParams, textTft, ctntTft, maxWidth / 2, boader);
				spr.addChild(exp);
				exp.x = maxWidth - exp.width;
			}
			return spr;
		}

		/**
		 *
		 * @param v
		 * @param textTft
		 * @param ctntTft
		 * @param maxWidth
		 * @return
		 *
		 */
		public static function lineItems(v:Vector.<DataParam>, textTft:TextFormat, ctntTft:TextFormat, maxWidth:int, boader:int):Sprite {
			var spr:Sprite = new Sprite();
			var x:int = 0;
			if (v != null) {
				for (var i:int = 0; i < v.length; i++) {
					var dp:DataParam = v[i];
					if (dp != null) {
						var item:Sprite = lineItem(dp.text, dp.content, textTft, ctntTft, maxWidth);
						if (x + item.width + boader <= maxWidth) {
							spr.addChild(item);
							item.x = x;
							x += item.width + boader;
						}
						else {
							break;
						}
					}
				}
			}
			return spr;
		}

		/**
		 *
		 * @param text
		 * @param ctnt
		 * @param textTft
		 * @param ctntTft
		 * @param maxWidth
		 * @return
		 *
		 */
		public static function lineItem(text:String, ctnt:String, textTft:TextFormat, ctntTft:TextFormat, maxWidth:int):Sprite {
			var spr:Sprite = new Sprite();
			if (text != null && ctnt != null) {
				var t:TextField = Util.text(text, textTft);
				t.mouseEnabled = false;
				spr.addChild(t);

				var c:TextField = Util.ctnt(ctnt, ctntTft, maxWidth);
				c.mouseEnabled = false;
				spr.addChild(c);
				c.x = t.width;
			}
			return spr;
		}

		/**
		 *
		 * @param text
		 * @param tft
		 * @return
		 *
		 */
		public static function text(text:String, tft:TextFormat):TextField {
			var txt:TextField = new TextField();
			txt.mouseEnabled = false;
			txt.defaultTextFormat = tft;
			txt.autoSize = TextFieldAutoSize.LEFT;
			if (text != null) {
				txt.text = text + "：";
			}
			return txt;
		}

		/**
		 *
		 * @param text
		 * @param tft
		 * @param maxWidth
		 * @return
		 *
		 */
		public static function ctnt(text:String, tft:TextFormat, maxWidth:int = 0):TextField {
			if (maxWidth > 0) {
				return creatTextInline(text, tft, maxWidth);
			}
			else {
				var txt:TextField = new TextField();
				txt.mouseEnabled = false;
				txt.defaultTextFormat = tft;
				txt.autoSize = TextFieldAutoSize.LEFT;
				if (text != null) {
					txt.text = text;
				}
				return txt;
			}
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
			tfd.mouseEnabled = false;
			tfd.defaultTextFormat = tft;
			tfd.autoSize = TextFieldAutoSize.LEFT;
			if (text != null) {
				var fs:int = int(tft.size);
				var fw:int = fs;
				var n:int = (maxWidth - 5) / fw;
				var et:String = n < text.length ? endText : "";
				tfd.text = text.substring(0, n - endText.length) + et;
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
			tfd.mouseEnabled = false;
			tfd.defaultTextFormat = tft;
			tfd.autoSize = TextFieldAutoSize.LEFT;
			tfd.multiline = true;
			tfd.wordWrap = true;
			tfd.width = maxWidth;
			if (text != null) {
				if (maxWidth > 0 && text.length > 0) {
					var fs:int = int(tft.size);
					var fw:int = fs;
					var fh:int = fs + 2;
					var n:int = (maxWidth - 5) / fw;
					var m:int = (maxHeight - 1) / fh;
					var et:String = n * m < text.length ? endText : "";
					tfd.text = text.substring(0, n * m - endText.length) + et;
				}
				else {
					tfd.text = text;
				}
			}
			return tfd;
		}

	}
}
