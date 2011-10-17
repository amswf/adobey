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
	 * 图片、标题、日期、关键字、概要信息
	 * @author Administrator
	 *
	 */
	public class NewsItemIII extends NewsItemBase {

		private var boader:int = 20;

		private var hMax:int = 150;

		private var wMax:int = 150;

		private var tft:TextFormat = new TextFormat(null, 12, 0xffffff);

		private var defBack:MovieClip;

		private var selBack:MovieClip;

		public function NewsItemIII(data:DataDTO) {
			super();
			_autoRow = true;
			this._data = data;
		}

		override public function draw():void {
			var ndp:NewsDataParam = new NewsDataParam(data.params);

			itemHeight = hMax;
			itemWidth = wMax;
			defBack = SkinsUtil.createSkinByName("NewsItemsIII_backDefSkin");
			defBack.width = itemWidth;
			defBack.height = itemHeight;
			this.addChild(defBack);

			selBack = SkinsUtil.createSkinByName("NewsItemsIII_backSelSkin");
			selBack.width = itemWidth;
			selBack.height = itemHeight;
			selBack.visible = false;
			this.addChild(selBack);

			var title:TextField = new TextField();
			title.mouseEnabled = false;
			title.defaultTextFormat = tft;
			title.autoSize = TextFieldAutoSize.LEFT;
			title.text = ndp.titleParam.content;
			this.addChild(title);
			title.x = (itemWidth - title.width) / 2;
			title.y = itemHeight - boader - title.height;

			var img:Bitmap = new Bitmap(_data.img, "auto", true);
			this.addChild(img);
			img.x = boader;
			img.y = boader;
			img.width = itemWidth - boader - boader;
			img.height = title.y - boader;
			this.addChild(img);

		}
	}
}
