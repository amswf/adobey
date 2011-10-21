package com.snsoft.tsp3.plugin.news.layout {
	import com.snsoft.tsp3.net.DataParam;
	import com.snsoft.util.TFDUtil;

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Util {
		public function Util() {
		}

		public static function contentItem(dataParam:DataParam, textTft:TextFormat, ctntTft:TextFormat, width:int, height:int):TextField {
			var text:String = dataParam.text + "：";
			var ctnt:String = dataParam.text + dataParam.content;
			var tfd:TextField = TFDUtil.creatTextMultiLine(text + ctnt, ctntTft, width, height);
			tfd.setTextFormat(textTft, 0, text.length);
			return tfd;
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
			var title:Sprite = lineItem(titleParam.text, titleParam.content, textTft, ctntTft, maxWidth / 2);
			spr.addChild(title);
			var exp:Sprite = lineItems(expParams, textTft, ctntTft, maxWidth / 2, boader);
			spr.addChild(exp);
			exp.x = title.width;
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
		public static function twsRight(textTft:TextFormat, ctntTft:TextFormat, maxWidth:int, titleParam:DataParam, expParams:Vector.<DataParam>, boader:int):Sprite {
			var spr:Sprite = new Sprite();
			var title:Sprite = lineItem(titleParam.text, titleParam.content, textTft, ctntTft, maxWidth / 2);
			spr.addChild(title);
			var exp:Sprite = lineItems(expParams, textTft, ctntTft, maxWidth / 2, boader);
			spr.addChild(exp);
			exp.x = maxWidth - spr.width;
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
			for (var i:int = 0; i < v.length; i++) {
				var dp:DataParam = v[i];
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
			var t:TextField = Util.text(text, textTft);
			t.mouseEnabled = false;
			spr.addChild(t);

			var c:TextField = Util.ctnt(ctnt, ctntTft, maxWidth);
			c.mouseEnabled = false;
			spr.addChild(c);
			c.x = t.width;
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
			txt.text = text + "：";
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
				return TFDUtil.creatTextInline(text, tft, maxWidth);
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

	}
}
