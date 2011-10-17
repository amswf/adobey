package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.MySprite;
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.tsp3.net.Params;
	import com.snsoft.tsp3.pagination.Pagination;
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.SpriteUtil;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class NewsPanel extends MySprite {

		private var panelSize:Point;

		private var backLayer:Sprite = new Sprite();

		private var infoLayer:Sprite = new Sprite();

		private var bookLayer:Sprite = new Sprite();

		private var btmBtnLayer:Sprite = new Sprite();

		private var topH:int = 50;

		private var btmH:int = 50;

		private var boader:int = 10;

		private var bookSize:Point;

		private var infoSize:Point;

		protected var closeBtn:MovieClip;

		public static const EVENT_CLOSE:String = "infoClose";

		private var newsState:NewsState;

		private var bookCtrler:NewsBookCtrler;

		private var infoCtrler:NewsInfoCtrler;

		private var infoUrl:String;

		private var itemsUrl:String;

		private var code:String;

		public function NewsPanel(panelSize:Point, infoUrl:String, itemsUrl:String, code:String) {
			this.panelSize = panelSize;
			this.infoUrl = infoUrl;
			this.itemsUrl = itemsUrl;
			this.code = code;
			this.infoSize = new Point(panelSize.x - boader - boader, panelSize.y - boader - boader - btmH - topH);
			this.bookSize = new Point(panelSize.x - boader - boader, panelSize.y - boader - boader - btmH - topH);

			super();
		}

		override protected function configMS():void {
			this.addChild(backLayer);
			this.addChild(infoLayer);
			this.addChild(bookLayer);
			this.addChild(btmBtnLayer);
		}

		override protected function draw():void {
			var back:MovieClip = SkinsUtil.createSkinByName("NewsPanel_backSkin");
			backLayer.addChild(back);
			back.width = panelSize.x;
			back.height = panelSize.y;

			closeBtn = SkinsUtil.createSkinByName("News_closeBtnSkin");
			closeBtn.x = panelSize.x - closeBtn.width - boader;
			closeBtn.y = boader;
			this.addChild(closeBtn);
			closeBtn.buttonMode = true;
			closeBtn.addEventListener(MouseEvent.CLICK, handlerClose);
			btmBtnLayer.x = boader;
			btmBtnLayer.y = panelSize.y - btmH - boader;
			var infoBtn:NewsTextBtn = new NewsTextBtn("详细内容");
			btmBtnLayer.addChild(infoBtn);
			infoBtn.buttonMode = true;
			infoBtn.addEventListener(MouseEvent.CLICK, handlerInfoBtnClick);

			var bookBtn:NewsTextBtn = new NewsTextBtn("相关信息");
			btmBtnLayer.addChild(bookBtn);
			bookBtn.addEventListener(MouseEvent.CLICK, handlerBookBtnClick);
			bookBtn.x = infoBtn.getRect(btmBtnLayer).right;

			bookLayer.visible = false;
			bookLayer.x = boader;
			bookLayer.y = boader + topH;

			infoLayer.visible = false;
			infoLayer.x = boader;
			infoLayer.y = boader + topH;

			var pagin:Pagination = new Pagination();
			bookLayer.addChild(pagin);
			pagin.y = bookSize.y - pagin.height;
			pagin.x = (bookSize.x - pagin.width) / 2;
			var pp:Point = new Point(0, pagin.height + boader);

			var bp:Point = bookSize.subtract(pp);
			var book:NewsBook = new NewsBook(bp);
			bookLayer.addChild(book);
			bookCtrler = new NewsBookCtrler(book, pagin);
			bookCtrler.addEventListener(NewsBookCtrler.EVENT_ITEM_CLICK, handlerItemClick);

			var info:NewsInfo = new NewsInfo(infoSize);
			infoLayer.addChild(info);
			infoCtrler = new NewsInfoCtrler(info);
		}

		private function handlerItemClick(e:Event):void {
			var data:DataDTO = bookCtrler.clickItem.data;
			newsState.infoId = data.id;
			refreshInfo();
			infoVsb(true);
		}

		private function handlerInfoBtnClick(e:Event):void {
			infoVsb(true);
		}

		private function handlerBookBtnClick(e:Event):void {
			refreshItems();
			infoVsb(false);
		}

		private function handlerClose(e:Event):void {
			this.dispatchEvent(new Event(EVENT_CLOSE));
		}

		public function refresh(newsState:NewsState):void {
			this.newsState = newsState.clone();
			refreshInfo();
		}

		private function refreshInfo():void {
			infoCtrler.refresh(infoUrl, code, this.newsState);
			infoVsb(true);
		}

		private function refreshItems():void {
			bookCtrler.refresh(itemsUrl, code, this.newsState);

		}

		private function infoVsb(b:Boolean):void {
			infoLayer.visible = b;
			bookLayer.visible = !b;
		}
	}
}
