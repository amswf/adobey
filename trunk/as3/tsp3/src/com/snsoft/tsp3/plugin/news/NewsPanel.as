package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.MySprite;
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.tsp3.pagination.Pagination;
	import com.snsoft.util.SkinsUtil;

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

		private var bookHeadLayer:Sprite = new Sprite();

		private var titleLayer:Sprite = new Sprite();

		private var btmBtnLayer:Sprite = new Sprite();

		private var topBtnLayer:Sprite = new Sprite();

		private var btmH:int = 50;

		private var boader:int = 19;

		private var boader2:int = 10;

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

		private var cbtmBtn:NewsPanelBtn;

		private var infoBtn:NewsPanelBtn;

		private var bookBtn:NewsPanelBtn;

		private var pagin:Pagination;

		private var title:NewsInfoTitle;

		public function NewsPanel(panelSize:Point, infoUrl:String, itemsUrl:String, code:String) {
			this.panelSize = panelSize;
			this.infoUrl = infoUrl;
			this.itemsUrl = itemsUrl;
			this.code = code;
			this.infoSize = new Point(panelSize.x - boader - boader, panelSize.y - boader - boader - btmH);
			this.bookSize = new Point(panelSize.x - boader - boader, panelSize.y - boader - boader - btmH);

			super();
		}

		override protected function configMS():void {
			this.addChild(backLayer);
			this.addChild(titleLayer);
			this.addChild(btmBtnLayer);
			this.addChild(infoLayer);
			this.addChild(bookLayer);
			this.addChild(bookHeadLayer);
			this.addChild(topBtnLayer);
		}

		override protected function draw():void {
			var back:MovieClip = SkinsUtil.createSkinByName("NewsPanel_backSkin");
			backLayer.addChild(back);
			back.width = panelSize.x;
			back.height = panelSize.y;

			closeBtn = SkinsUtil.createSkinByName("NewsPanel_closeBtnSkin");
			closeBtn.x = panelSize.x - closeBtn.width;

			topBtnLayer.addChild(closeBtn);
			closeBtn.buttonMode = true;
			closeBtn.addEventListener(MouseEvent.CLICK, handlerClose);

			btmBtnLayer.x = boader;
			btmBtnLayer.y = panelSize.y - btmH - boader;

			var btmBack:Sprite = SkinsUtil.createSkinByName("NewsBoard_bottomBackSkin");
			btmBtnLayer.addChild(btmBack);
			btmBack.width = infoSize.x;
			btmBack.height = btmH;

			infoBtn = new NewsPanelBtn("详细内容");
			btmBtnLayer.addChild(infoBtn);
			infoBtn.x = boader2;
			infoBtn.setSectcted(true);
			setBtmBtnState(infoBtn);
			infoBtn.buttonMode = true;
			infoBtn.addEventListener(MouseEvent.CLICK, handlerInfoBtnClick);

			bookBtn = new NewsPanelBtn("相关信息");
			btmBtnLayer.addChild(bookBtn);
			bookBtn.addEventListener(MouseEvent.CLICK, handlerBookBtnClick);
			bookBtn.x = infoBtn.getRect(btmBtnLayer).right;

			bookLayer.visible = false;
			bookLayer.x = boader;

			infoLayer.visible = false;
			infoLayer.x = boader;

			pagin = new Pagination();
			pagin.visible = false;
			bookLayer.addChild(pagin);
			pagin.y = btmBtnLayer.y - pagin.height - boader2;
			pagin.x = (bookSize.x - pagin.width) / 2;
			var pp:Point = new Point(0, pagin.height + boader + boader2);

			title = new NewsInfoTitle(infoSize.x);
			titleLayer.addChild(title);
			title.x = boader;
			title.y = boader;

			var bp:Point = bookSize.subtract(pp);
			var book:NewsBook = new NewsBook(bp);
			bookLayer.addChild(book);
			bookCtrler = new NewsBookCtrler(book, pagin, bookHeadLayer, title);
			bookCtrler.addEventListener(NewsBookCtrler.EVENT_ITEM_CLICK, handlerItemClick);
			bookCtrler.addEventListener(NewsBookCtrler.EVENT_LOAD_COMPLETE, handlerItemCmp);

			var info:NewsInfo = new NewsInfo(infoSize);
			infoLayer.addChild(info);
			infoCtrler = new NewsInfoCtrler(info, title);
		}

		private function handlerItemCmp(e:Event):void {
			infoVsb(false);
		}

		private function handlerItemClick(e:Event):void {
			var data:DataDTO = bookCtrler.clickItem.data;
			newsState.infoId = data.id;
			refreshInfo();
			setBtmBtnState(infoBtn);
			infoVsb(true);
		}

		private function handlerInfoBtnClick(e:Event):void {
			setBtmBtnState(e.currentTarget);
			infoVsb(true);
		}

		private function handlerBookBtnClick(e:Event):void {
			setBtmBtnState(e.currentTarget);
			refreshItems();
			infoLayer.visible = false;
		}

		private function setBtmBtnState(clickObj:Object):void {
			if (cbtmBtn != null) {
				cbtmBtn.setSectcted(false);
			}
			cbtmBtn = clickObj as NewsPanelBtn;
			cbtmBtn.setSectcted(true);
		}

		private function handlerClose(e:Event):void {
			this.dispatchEvent(new Event(EVENT_CLOSE));
		}

		public function refresh(newsState:NewsState):void {
			this.infoLayer.visible = false;
			this.newsState = newsState.clone();
			refreshInfo();
		}

		private function refreshInfo():void {
			infoCtrler.refresh(infoUrl, code, this.newsState);
			infoVsb(true);
		}

		private function refreshItems():void {
			bookCtrler.refresh(itemsUrl, code, this.newsState, bookSize, pagin.height + boader2);
		}

		private function infoVsb(b:Boolean):void {
			infoLayer.visible = b;
			bookLayer.visible = !b;
		}
	}
}
