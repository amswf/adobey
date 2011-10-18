﻿package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.util.SkinsUtil;

	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 *    供求信息
	 *
	 * @author Administrator
	 *
	 */
	public class NewsItemV extends NewsItemBase {

		private var boader:int = 15;

		private var boader2:int = 5;

		private var hMax:int = 100;

		private var tft:TextFormat = new TextFormat(null, 12, 0xffffff);

		private var defBack:MovieClip;

		private var selBack:MovieClip;

		public function NewsItemV(data:DataDTO) {
			super();
			this._data = data;
		}

		override public function draw():void {

			var ndp:NewsDataParam = new NewsDataParam(data.params);

			itemHeight = hMax;

			defBack = SkinsUtil.createSkinByName("NewsItemsV_backDefSkin");
			defBack.width = itemWidth;
			defBack.height = itemHeight;
			this.addChild(defBack);

			selBack = SkinsUtil.createSkinByName("NewsItemsV_backSelSkin");
			selBack.width = itemWidth;
			selBack.height = itemHeight;
			selBack.visible = false;
			this.addChild(selBack);

			var title:TextField = new TextField();
			title.defaultTextFormat = tft;
			title.autoSize = TextFieldAutoSize.LEFT;
			title.mouseEnabled = false;
			title.text = ndp.titleParam.content;
			this.addChild(title);
			title.x = boader;
			title.y = boader;

			var date:TextField = new TextField();
			date.defaultTextFormat = tft;
			date.autoSize = TextFieldAutoSize.LEFT;
			date.mouseEnabled = false;
			date.text = ndp.dateParam.content;
			this.addChild(date);
			date.x = title.getRect(this).right + boader;
			date.y = boader;

			var ebuyType:TextField = new TextField();
			ebuyType.defaultTextFormat = tft;
			ebuyType.autoSize = TextFieldAutoSize.LEFT;
			ebuyType.mouseEnabled = false;

			var ett:String = "";
			if (ndp.ebuyTypeParam.content == NewsDataParam.EBUY_TYPE_SUPL) {
				ett = "[供]";
			}
			else if (ndp.ebuyTypeParam.content == NewsDataParam.EBUY_TYPE_BUY) {
				ett = "[应]";
			}
			ebuyType.text = ett;
			this.addChild(ebuyType);
			ebuyType.x = date.getRect(this).right + boader;
			ebuyType.y = boader;

			var keywords:TextField = new TextField();
			keywords.defaultTextFormat = tft;
			keywords.autoSize = TextFieldAutoSize.LEFT;
			keywords.mouseEnabled = false;
			keywords.text = ndp.keywordsParam.text + "：" + ndp.keywordsParam.content;
			this.addChild(keywords);
			keywords.x = boader;
			keywords.y = title.getRect(this).bottom;

			var digest:TextField = new TextField();
			digest.defaultTextFormat = tft;
			digest.mouseEnabled = false;
			digest.multiline = true;
			digest.wordWrap = true;
			digest.text = ndp.digestParam.text + "：" + ndp.digestParam.content;
			this.addChild(digest);
			digest.x = boader;
			digest.y = keywords.getRect(this).bottom;
			digest.width = itemWidth - boader - digest.x;
			digest.height = itemHeight - boader - digest.y;
		}
	}
}