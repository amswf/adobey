package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.tsp3.net.DataParam;
	import com.snsoft.tsp3.plugin.news.layout.Util;
	import com.snsoft.util.SkinsUtil;

	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextFormat;

	/**
	 *    供求信息
	 *
	 * @author Administrator
	 *
	 */
	public class NewsItemV extends NewsItemBase {

		private var boader2:int = 5;

		private var hMax:int = 110;

		private var tft:TextFormat = new TextFormat(null, 12, 0xffffff);

		public function NewsItemV(data:DataDTO) {
			super();
			this._data = data;
			itemHeight = hMax;
		}

		override public function draw():void {
			boader = 15;
			var ndp:NewsDataParam = new NewsDataParam(data.params);

			addBack("V");

			var imgh:int = itemHeight - boader - boader;
			var imgw:int = imgh * 1.33;

			var img:Bitmap = new Bitmap(_data.img, "auto", true);
			this.addChild(img);
			img.x = boader;
			img.y = boader;
			img.width = imgw;
			img.height = imgh;
			this.addChild(img);

			var tp:DataParam = ndp.getIntrParam(NewsDataParam.PARAM_TITLE);

			var v:Vector.<DataParam> = new Vector.<DataParam>();
			v.push(ndp.getIntrParam(NewsDataParam.PARAM_DATE));

			var th:int = 0;
			var title:Sprite = Util.twsLeft(titletft, texttft, ctnttft, itemWidth - img.getRect(this).right - boader - boader - boader, 10, tp, v);
			this.addChild(title);
			title.x = img.getRect(this).right + boader;
			title.y = boader;
			th = title.height;

			var ep:DataParam = ndp.getIntrParam(NewsDataParam.PARAM_EBUY_TYPE);
			var eskin:String = null;
			if (ep != null) {
				if (ep.content == NewsDataParam.EBUY_TYPE_SUPL) {
					eskin = "NewsEbuy_GSKin";
				}
				else if (ep.content == NewsDataParam.EBUY_TYPE_BUY) {
					eskin = "NewsEbuy_QSKin";
				}
			}
			if (eskin != null) {
				var ebuySpr:Sprite = SkinsUtil.createSkinByName(eskin);
				this.addChild(ebuySpr);
				ebuySpr.x = title.getRect(this).right + boader;
				ebuySpr.y = title.y;
				th = Math.max(th, ebuySpr.height);
			}

			var kp:DataParam = ndp.getIntrParam(NewsDataParam.PARAM_KEYWORDS);
			var keywords:Sprite = Util.lineItem(kp.text, kp.content, texttft, ctnttft, 0);
			this.addChild(keywords);
			keywords.x = img.getRect(this).right + boader;
			keywords.y = title.y + th;

			var dp:DataParam = ndp.getIntrParam(NewsDataParam.PARAM_DIGEST);
			var dw:int = itemWidth - boader - img.width - boader - boader;
			var dh:int = itemHeight - keywords.getRect(this).bottom - boader;
			var digest:Sprite = Util.digestText(dp, texttft, ctnttft, dw, dh);
			this.addChild(digest);
			digest.x = title.x;
			digest.y = keywords.getRect(this).bottom;

		}
	}
}
