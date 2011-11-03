package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.ViewUtil;
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.tsp3.net.DataParam;
	import com.snsoft.tsp3.plugin.news.layout.Util;
	import com.snsoft.util.SkinsUtil;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextFormat;

	/**
	 *  标题、日期、关键字、
	 *
	 *       概要信息
	 * @author Administrator
	 *
	 */
	public class NewsItemII extends NewsItemBase {

		private var hMax:int = 100;

		private var tft:TextFormat = new TextFormat(null, 12, 0xffffff);

		public function NewsItemII(data:DataDTO) {
			super();
			this._data = data;
			itemHeight = hMax;
		}

		override public function draw():void {
			var ndp:NewsDataParam = new NewsDataParam(data.params);

			addBack("II");

			var imgh:int = itemHeight - boader - boader;
			var imgw:int = imgh * 1.33;

			var tp:DataParam = ndp.getIntrParam(NewsDataParam.PARAM_TITLE);

			var v:Vector.<DataParam> = new Vector.<DataParam>();
			v.push(ndp.getIntrParam(NewsDataParam.PARAM_KEYWORDS));
			v.push(ndp.getIntrParam(NewsDataParam.PARAM_DATE));

			var icon:Sprite = SkinsUtil.createSkinByName("NewsItemIcon");
			this.addChild(icon);
			ViewUtil.filterSprite(icon);
			icon.x = boader;

			var title:Sprite = Util.twsLeft(titletft, texttft, ctnttft, itemWidth - icon.width - boader - boader - boader - boader, 10, tp, v);
			this.addChild(title);
			title.x = icon.getRect(this).right + boader;
			title.y = boader;

			icon.y = boader + (title.height - icon.height) / 2;

			var dp:DataParam = ndp.getIntrParam(NewsDataParam.PARAM_DIGEST);
			var dw:int = itemWidth - boader - boader - boader;
			var dh:int = itemHeight - title.getRect(this).bottom - boader - boader;
			var digest:Sprite = Util.digestText(dp, texttft, ctnttft, dw, dh);
			this.addChild(digest);
			digest.x = boader;
			digest.y = title.getRect(this).bottom + boader;
		}
	}
}
