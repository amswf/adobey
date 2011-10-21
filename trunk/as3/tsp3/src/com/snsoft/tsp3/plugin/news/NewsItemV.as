package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.tsp3.net.DataParam;
	import com.snsoft.tsp3.plugin.news.layout.Util;
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

		private var boader2:int = 5;

		private var hMax:int = 110;

		private var tft:TextFormat = new TextFormat(null, 12, 0xffffff);

		private var defBack:MovieClip;

		private var selBack:MovieClip;

		public function NewsItemV(data:DataDTO) {
			super();
			this._data = data;
		}

		override public function draw():void {
			boader = 15;
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
			v.push(ndp.getIntrParam(NewsDataParam.PARAM_EBUY_TYPE));

			var title:Sprite = Util.twsLeft(texttft, ctnttft, itemWidth - img.getRect(this).right - boader - boader - boader, 10, tp, v);
			this.addChild(title);
			title.x = img.getRect(this).right + boader;
			title.y = boader;

			var kp:DataParam = ndp.getIntrParam(NewsDataParam.PARAM_KEYWORDS);
			var keywords:Sprite = Util.lineItem(kp.text, kp.content, texttft, ctnttft, 0);
			this.addChild(keywords);
			keywords.x = img.getRect(this).right + boader;
			keywords.y = title.getRect(this).bottom;

			var dp:DataParam = ndp.getIntrParam(NewsDataParam.PARAM_DIGEST);
			var dw:int = itemWidth - boader - img.width - boader - boader;
			var dh:int = itemHeight - keywords.getRect(this).bottom - boader;
			var digest:TextField = Util.contentItem(dp, texttft, ctnttft, dw, dh);
			this.addChild(digest);
			digest.x = title.x;
			digest.y = keywords.getRect(this).bottom;

		}
	}
}
