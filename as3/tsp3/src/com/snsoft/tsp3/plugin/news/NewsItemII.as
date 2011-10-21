package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.tsp3.net.DataParam;
	import com.snsoft.util.SkinsUtil;

	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
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

		private var defBack:MovieClip;

		private var selBack:MovieClip;

		public function NewsItemII(data:DataDTO) {
			super();
			this._data = data;
		}

		override public function draw():void {
			var ndp:NewsDataParam = new NewsDataParam(data.params);
			itemHeight = hMax;

			defBack = SkinsUtil.createSkinByName("NewsItemsII_backDefSkin");
			defBack.width = itemWidth;
			defBack.height = itemHeight;
			this.addChild(defBack);

			selBack = SkinsUtil.createSkinByName("NewsItemsII_backSelSkin");
			selBack.width = itemWidth;
			selBack.height = itemHeight;
			selBack.visible = false;
			this.addChild(selBack);

			var imgh:int = itemHeight - boader - boader;
			var imgw:int = imgh * 1.33;

			var title:TextField = new TextField();
			title.defaultTextFormat = tft;
			title.autoSize = TextFieldAutoSize.LEFT;
			title.mouseEnabled = false;
			var tp:DataParam = ndp.getIntrParam(NewsDataParam.PARAM_TITLE);
			title.text = tp.text + "：" + tp.content;
			this.addChild(title);
			title.x = boader;
			title.y = boader;

			var date:TextField = new TextField();
			date.defaultTextFormat = tft;
			date.autoSize = TextFieldAutoSize.LEFT;
			date.mouseEnabled = false;
			var cp:DataParam = ndp.getIntrParam(NewsDataParam.PARAM_DATE);
			date.text = cp.text + "：" + cp.content;
			this.addChild(date);
			date.x = title.getRect(this).right + boader;
			date.y = boader;

			var keywords:TextField = new TextField();
			keywords.defaultTextFormat = tft;
			keywords.autoSize = TextFieldAutoSize.LEFT;
			keywords.mouseEnabled = false;
			var kp:DataParam = ndp.getIntrParam(NewsDataParam.PARAM_KEYWORDS);
			keywords.text = kp.text + "：" + kp.content;
			this.addChild(keywords);
			keywords.x = date.getRect(this).right + boader;
			keywords.y = boader;

			var digest:TextField = new TextField();
			digest.defaultTextFormat = tft;
			digest.mouseEnabled = false;
			digest.multiline = true;
			digest.wordWrap = true;
			var dgp:DataParam = ndp.getIntrParam(NewsDataParam.PARAM_DIGEST);
			digest.text = dgp.text + "：" + dgp.content;
			this.addChild(digest);
			digest.x = title.x;
			digest.y = title.getRect(this).bottom + boader;
			digest.width = itemWidth - boader - digest.x;
			digest.height = itemHeight - boader - digest.y;
		}
	}
}
