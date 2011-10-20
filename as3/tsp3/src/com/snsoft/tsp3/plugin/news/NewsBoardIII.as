﻿package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.ViewUtil;
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.tsp3.net.DataParam;
	import com.snsoft.tsp3.touch.TouchDrag;
	import com.snsoft.util.SpriteUtil;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.html.HTMLLoader;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class NewsBoardIII extends NewsBoardBase {

		private var hMax:int = 100;

		private var timgW:int = 320;
		private var timgH:int = 240;

		public function NewsBoardIII(infoSize:Point, data:DataDTO) {
			this.infoSize = infoSize;
			this._data = data;
			super();
		}

		override protected function configMS():void {
			this.addChild(titleLayer);
			this.addChild(scrollLayer);
			this.addChild(maskLayer);
		}

		override protected function draw():void {
			ctntWidth = infoSize.x - boader - boader;
			var ndp:NewsDataParam = new NewsDataParam(data.params);

			SpriteUtil.deleteAllChild(titleLayer);
			SpriteUtil.deleteAllChild(scrollLayer);
			SpriteUtil.deleteAllChild(maskLayer);

			//基础信息，标题，日期，关键词
			addBaseItems(ndp);

			//图片
			addTitleImg(data.img, timgW, timgH);

			var tp:DataParam = ndp.getIntrParam(NewsDataParam.PARAM_EBUY_TYPE);
			var pp:DataParam = ndp.getIntrParam(NewsDataParam.PARAM_EBUY_PUBLISH_DATE);
			var filmItems:Sprite = creatItemsLine(tp, pp);
			scrollLayer.addChild(filmItems);
			filmItems.x = boader + timgW;
			filmItems.y = boader;

			//附件、图片、音乐、影片
			addSrcs(data);
			//其它数据项输出
			addExpItems(ndp);
			//内容单独输出，并且在最后
			addDigest(ndp);
		}

		protected function addTitleImg(bmd:BitmapData, width:int, height:int):void {
			if (data != null && data.img != null) {
				var img:Sprite = creatImage(bmd, width, height);
				scrollLayer.addChild(img);
				img.y = nextY;
				nextY = img.getRect(scrollLayer).bottom + boader;
			}
		}

	}
}
