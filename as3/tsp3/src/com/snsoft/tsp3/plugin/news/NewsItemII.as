package com.snsoft.tsp3.plugin.news {
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
		}

		override public function draw():void {
			var ndp:NewsDataParam = new NewsDataParam(data.params);
			itemHeight = hMax;

			addBack("II");

			var imgh:int = itemHeight - boader - boader;
			var imgw:int = imgh * 1.33;

			var tp:DataParam = ndp.getIntrParam(NewsDataParam.PARAM_TITLE);

			var v:Vector.<DataParam> = new Vector.<DataParam>();
			v.push(ndp.getIntrParam(NewsDataParam.PARAM_KEYWORDS));
			v.push(ndp.getIntrParam(NewsDataParam.PARAM_DATE));

			var title:Sprite = Util.twsLeft(titletft, texttft, ctnttft, itemWidth - boader - boader - boader, 10, tp, v);
			this.addChild(title);
			title.x = +boader;
			title.y = boader;

			var dp:DataParam = ndp.getIntrParam(NewsDataParam.PARAM_DIGEST);
			var dw:int = itemWidth - boader - boader - boader;
			var dh:int = itemHeight - title.getRect(this).bottom - boader - boader;
			var digest:Sprite = Util.contentItem(dp, texttft, ctnttft, dw, dh);
			this.addChild(digest);
			digest.x = title.x;
			digest.y = title.getRect(this).bottom + boader;
		}
	}
}
