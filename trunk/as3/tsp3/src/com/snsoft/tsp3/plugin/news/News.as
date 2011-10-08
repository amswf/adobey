package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.ViewUtil;
	import com.snsoft.tsp3.pagination.Pagination;
	import com.snsoft.tsp3.pagination.PaginationEvent;
	import com.snsoft.tsp3.plugin.BPlugin;
	import com.snsoft.tsp3.plugin.news.dto.NewsTitleDTO;
	import com.snsoft.util.SkinsUtil;

	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;

	public class News extends BPlugin {

		private var boader:int = 10;

		private var newsBook:NewsBook;

		private var pagin:Pagination;

		private var isLock:Boolean = false;

		public function News() {
			super();

			pluginCfg = new Object();
		}

		override protected function init():void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			var nw:int = stage.stageWidth;
			var nh:int = stage.stageHeight - 86;

			var th:int = 100;
			var ntdto:NewsTitleDTO = new NewsTitleDTO();
			ntdto.text = "新闻资讯";
			ntdto.titleImg = new BitmapData(48, 48);
			var nt:NewsTitle = new NewsTitle(ntdto, stage.stageWidth, th);
			this.addChild(nt);
			nt.addEventListener(NewsTitle.EVENT_CLOSE, handlerCloseBtnClick);
			nt.addEventListener(NewsTitle.EVENT_MIN, handlerMinBtnClick);

			var btnv:Vector.<NewsImgBtn> = new Vector.<NewsImgBtn>();
			for (var i:int = 0; i < 20; i++) {
				var nib:NewsImgBtn = new NewsImgBtn(new Point(48, 48), new BitmapData(100, 100), "这里的山路十八", 126);
				nib.buttonMode = true;

				var dto:NewsBtnDTO = new NewsBtnDTO();
				dto.text = "asdfasdf";

				nib.data = dto;
				btnv.push(nib);
			}

			var mh:int = nh - th;

			var nbb:NewsBtnBox = new NewsBtnBox(btnv, mh);
			this.addChild(nbb);
			nbb.x = stage.stageWidth - nbb.width;
			nbb.y = th;
			nbb.addEventListener(NewsBtnBox.EVENT_BTN_CLICK, handlerBtnClick);

			pagin = new Pagination(5);
			this.addChild(pagin);
			pagin.x = (stage.stageWidth - nbb.width - pagin.width) / 2;
			pagin.y = nh - pagin.height - boader;
			pagin.addEventListener(PaginationEvent.PAGIN_CLICK, handlerPaginBtnClick);
			//先在这里实现分页拖动

			newsBook = new NewsBook(new Point(stage.stageWidth - nbb.width, pagin.y - boader - th));
			newsBook.y = th;
			newsBook.addEventListener(NewsBook.NEED_NEXT, handlerBookNext);
			newsBook.addEventListener(NewsBook.NEED_PREV, handlerBookPrev);
			newsBook.addEventListener(NewsBook.CHANGE_PAGE, handlerChangePage);
			this.addChild(newsBook);
		}

		private function handlerCloseBtnClick(e:Event):void {
			closePlugin();
		}

		private function handlerMinBtnClick(e:Event):void {
			minimizePlugin();
		}

		private function handlerPaginBtnClick(e:Event):void {
			var pagin:Pagination = e.currentTarget as Pagination;
			newsBook.gotoPage(pagin.pageNum);
		}

		private function handlerChangePage(e:Event):void {
			var nb:NewsBook = e.currentTarget as NewsBook;
			pagin.setPageNum(nb.currentNum, 5);
		}

		private function handlerBookNext(e:Event):void {
			trace("handlerBookNext");
			var nb:NewsBook = e.currentTarget as NewsBook;
			pagin.setPageNum(pagin.pageNum, 5);

			if (nb.npNum <= 5) {
				var v:Vector.<Sprite> = new Vector.<Sprite>();
				for (var i:int = 0; i < 15; i++) {
					var spr:Sprite = new Sprite();
					spr.addChild(ViewUtil.creatRect(400, 50, 0x000000, 1));
					v.push(spr);
				}

				var nbp:NewsBookPage = new NewsBookPage(new Point(nb.bookSize.x, 300), v, nb.npNum, 5);

				var timer:Timer = new Timer(500, 1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:Event):void {
					nb.addPageNext(nbp);
				});
				timer.start();
			}
		}

		private function handlerBookPrev(e:Event):void {
			trace("handlerBookPrev");
			var nb:NewsBook = e.currentTarget as NewsBook;
			pagin.setPageNum(pagin.pageNum, 5);

			var v:Vector.<Sprite> = new Vector.<Sprite>();
			for (var i:int = 0; i < 15; i++) {
				var spr:Sprite = new Sprite();
				spr.addChild(ViewUtil.creatRect(400, 50, 0x000000, 1));
				v.push(spr);
			}

			var nbp:NewsBookPage = new NewsBookPage(new Point(nb.bookSize.x, 300), v, nb.npNum, 5);

			var timer:Timer = new Timer(500, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:Event):void {
				nb.addPagePrev(nbp);
			});
			timer.start();
		}

		private function handlerBtnClick(e:Event):void {
			var nbb:NewsBtnBox = e.currentTarget as NewsBtnBox;
			var btn:NewsImgBtn = nbb.clickBtn;
			var dto:NewsBtnDTO = btn.data as NewsBtnDTO;
			trace(dto.text);
		}
	}
}
