package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.Common;
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.tsp3.net.DataParam;
	import com.snsoft.tsp3.plugin.news.layout.Util;
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.SpriteUtil;
	import com.snsoft.util.rlm.rs.RSEmbedFonts;

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class NewsInfoTitle extends Sprite {

		private var titleWidth:int;

		private var boader:int = 10;

		private var titleBack:Sprite;

		private var textLayer:Sprite = new Sprite();

		protected var titletft:TextFormat = new TextFormat(RSEmbedFonts.findFontByName(Common.FONT_YH), 18, 0x0657b7);

		protected var subheadtft:TextFormat = new TextFormat(RSEmbedFonts.findFontByName(Common.FONT_YH), 13, 0x9f9f9f);

		protected var itemtft:TextFormat = new TextFormat(RSEmbedFonts.findFontByName(Common.FONT_YH), 14, 0x575757);

		public function NewsInfoTitle(titleWidth:int) {
			super();
			this.titleWidth = titleWidth;
			init();
		}

		private function init():void {
			titleBack = SkinsUtil.createSkinByName("NewsBoard_titleBackSkin");
			this.addChild(titleBack);
			titleBack.width = titleWidth;
			this.addChild(textLayer);
		}

		public function refresh(data:DataDTO):void {

			trace("refreshTitle");
			SpriteUtil.deleteAllChild(textLayer);
			var ndp:NewsDataParam = new NewsDataParam(data.params);
			var titledp:DataParam = ndp.getIntrParam(NewsDataParam.PARAM_TITLE);

			var th:int = 0;
			if (titledp != null) {
				var title:TextField = Util.ctntSameLine(titledp.content, titletft, titleWidth);
				textLayer.addChild(title);
				title.x = (titleWidth - title.width) / 2;
				title.y = boader;
				th = title.getRect(this).bottom;
			}

			var l2v:Vector.<DataParam> = new Vector.<DataParam>();
			l2v.push(ndp.getIntrParam(NewsDataParam.PARAM_COMEFROM));
			l2v.push(ndp.getIntrParam(NewsDataParam.PARAM_AUTHOR));
			l2v.push(ndp.getIntrParam(NewsDataParam.PARAM_KEYWORDS));
			l2v.push(ndp.getIntrParam(NewsDataParam.PARAM_DATE));
			var line2:Sprite =  Util.lineItemsSameLine(l2v, subheadtft, subheadtft, titleWidth, boader);
			textLayer.addChild(line2);
			line2.x = (titleWidth - line2.width) / 2;
			line2.y = th + boader;

			titleBack.height = line2.getRect(this).bottom + boader;
		}
	}
}
