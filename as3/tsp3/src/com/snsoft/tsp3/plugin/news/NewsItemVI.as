package com.snsoft.tsp3.plugin.news {
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

		private var defBack:MovieClip;

		private var selBack:MovieClip;

		private var dateW:int = 100;

		public function NewsItemVI(data:DataDTO) {
			super();
			this._data = data;
		}

		override public function draw():void {
			boader = 20;

			var ndp:NewsDataParam = new NewsDataParam(data.params);
			itemHeight = hMax;

			defBack = SkinsUtil.createSkinByName("NewsItemsVI_backDefSkin");
			defBack.width = itemWidth;
			defBack.height = itemHeight;
			this.addChild(defBack);

			selBack = SkinsUtil.createSkinByName("NewsItemsVI_backSelSkin");
			selBack.width = itemWidth;
			selBack.height = itemHeight;
			selBack.visible = false;
			this.addChild(selBack);

			var tp:DataParam = ndp.getIntrParam(NewsDataParam.PARAM_TITLE);

			var v:Vector.<DataParam> = new Vector.<DataParam>();
			v.push(ndp.getIntrParam(NewsDataParam.PARAM_DATE));

			var title:Sprite = Util.twsRight(texttft, ctnttft, itemWidth - boader - boader, 10, tp, v);
			this.addChild(title);
			title.x = boader;
			title.y = boader;
		}
	}
}
