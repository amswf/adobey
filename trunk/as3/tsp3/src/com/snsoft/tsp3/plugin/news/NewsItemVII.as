package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.ViewUtil;
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.tsp3.net.DataParam;
	import com.snsoft.tsp3.plugin.news.layout.Util;
	import com.snsoft.util.SkinsUtil;

	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 *    图片
	 *    标题
	 *    日期
	 *
	 *   可点击图片播放，点击文字进入
	 * @author Administrator
	 *
	 */
	public class NewsItemVII extends NewsItemBase {

		private var hMax:int = 180;

		private var wMax:int = 180;

		private var tft:TextFormat = new TextFormat(null, 12, 0xffffff);

		private var isPlayMouseDown:Boolean = false;

		private var isInfoMouseDown:Boolean = false;

		public function NewsItemVII(data:DataDTO) {
			super();
			_autoRow = true;
			this._data = data;
		}

		override public function draw():void {
			boader = 20;

			var ndp:NewsDataParam = new NewsDataParam(data.params);

			itemHeight = hMax;
			itemWidth = wMax;

			addBack("VII");

			var dp:DataParam = ndp.getIntrParam(NewsDataParam.PARAM_DATE);
			var date:Sprite = Util.lineItem(dp.text, dp.content, texttft, ctnttft, 0);
			this.addChild(date);
			date.x = boader;
			date.y = itemHeight - boader - date.height;

			var tp:DataParam = ndp.getIntrParam(NewsDataParam.PARAM_TITLE);
			var title:TextField = Util.ctnt(tp.content, ctnttft, itemWidth - boader - boader);
			this.addChild(title);
			title.x = boader;
			title.y = date.y - title.height;

			var infoH:int = itemHeight - title.y - boader;
			var infoBtn:Sprite = ViewUtil.creatRect(itemWidth, infoH);
			this.addChild(infoBtn);
			infoBtn.x = boader;
			infoBtn.y = title.y;
			infoBtn.buttonMode = true;
			infoBtn.addEventListener(MouseEvent.MOUSE_DOWN, handlerInfoMouseDown);
			infoBtn.addEventListener(MouseEvent.MOUSE_UP, handlerInfoMouseUp);

			var imgspr:Sprite = new Sprite();
			this.addChild(imgspr);
			imgspr.x = boader;
			imgspr.y = boader;

			var img:Bitmap = new Bitmap(_data.img, "auto", true);
			imgspr.addChild(img);
			img.width = itemWidth - boader - boader;
			img.height = title.y - boader;
			imgspr.addChild(img);

			var play:MovieClip = SkinsUtil.createSkinByName("NewsItemsVII_playDefSkin");
			imgspr.addChild(play);
			play.x = (img.width - play.width) / 2;
			play.y = (img.height - play.height) / 2;

			play.buttonMode = true;
			play.addEventListener(MouseEvent.MOUSE_DOWN, handlerPlayMouseDown);
			play.addEventListener(MouseEvent.MOUSE_UP, handlerPlayMouseUp);

			this.addEventListener(MouseEvent.MOUSE_DOWN, handlerThisMouseDown);
		}

		private function handlerThisMouseDown(e:Event):void {
			_clickType = null;
		}

		private function handlerInfoMouseDown(e:Event):void {
			isInfoMouseDown = true;
		}

		private function handlerInfoMouseUp(e:Event):void {
			if (isInfoMouseDown) {
				_clickType = CLICK_TYPE_INFO;
				isInfoMouseDown = false;
			}
		}

		private function handlerPlayMouseDown(e:Event):void {
			isPlayMouseDown = true;
		}

		private function handlerPlayMouseUp(e:Event):void {
			if (isPlayMouseDown) {
				_clickType = CLICK_TYPE_PLAY;
				isPlayMouseDown = false;
			}

		}
	}
}
