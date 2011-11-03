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
	 * 标题、日期
	 *
	 * @author Administrator
	 *
	 */
	public class NewsItemVI extends NewsItemBase {

		private var hMax:int = 60;

		private var tft:TextFormat = new TextFormat(null, 12, 0xffffff);

		private var dateW:int = 100;

		public function NewsItemVI(data:DataDTO) {
			super();
			this._data = data;
			itemHeight = hMax;
		}

		override public function draw():void {
			boader = 20;

			var ndp:NewsDataParam = new NewsDataParam(data.params);

			addBack("VI");

			var tp:DataParam = ndp.getIntrParam(NewsDataParam.PARAM_TITLE);

			var v:Vector.<DataParam> = new Vector.<DataParam>();
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
		}
	}
}
