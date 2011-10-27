package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.tsp3.net.DataParam;
	import com.snsoft.tsp3.plugin.news.layout.Util;
	import com.snsoft.util.SpriteUtil;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 * 供求
	 * @author Administrator
	 *
	 */
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

			var ebuyv:Vector.<DataParam> = new Vector.<DataParam>();
			ebuyv.push(ndp.getIntrParam(NewsDataParam.PARAM_EBUY_TYPE));
			ebuyv.push(ndp.getIntrParam(NewsDataParam.PARAM_EBUY_PUBLISH_DATE));
			var ebuyItems:Sprite = Util.rowItemsMultiLine(ebuyv, itemtft, itemtft, infoSize.x - boader - boader);
			scrollLayer.addChild(ebuyItems);
			ebuyItems.x = boader + timgW;
			ebuyItems.y = boader;

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
