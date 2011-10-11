package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.Common;
	import com.snsoft.tsp3.ViewUtil;
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.tsp3.net.DataLoader;
	import com.snsoft.tsp3.net.DataSet;
	import com.snsoft.tsp3.net.Params;
	import com.snsoft.tsp3.pagination.Pagination;
	import com.snsoft.tsp3.pagination.PaginationEvent;
	import com.snsoft.tsp3.plugin.BPlugin;
	import com.snsoft.tsp3.plugin.news.dto.NewsTitleDTO;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;

	public class News extends BPlugin {

		private var boader:int = 10;

		private var newsBook:NewsBook;

		private var pagin:Pagination;

		private var isLock:Boolean = false;

		private var cfg:NewsCfg = new NewsCfg();

		private var prms:NewsParams = new NewsParams();

		private const columnW:int = 190;

		private const paginH:int = 58;

		private const titleH:int = 100;

		private const deskBarH:int = 86;

		public function News() {
			super();
			pluginCfg = cfg;
			params = prms;
		}

		override protected function init():void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			trace(prms.id, prms.columnId);

			var ntdto:NewsTitleDTO = new NewsTitleDTO();
			ntdto.text = "新闻资讯";
			ntdto.titleImg = prms.img;
			var nt:NewsTitle = new NewsTitle(ntdto, stage.stageWidth, titleH);
			this.addChild(nt);
			nt.addEventListener(NewsTitle.EVENT_CLOSE, handlerCloseBtnClick);
			nt.addEventListener(NewsTitle.EVENT_MIN, handlerMinBtnClick);

			pagin = new Pagination(5);
			this.addChild(pagin);
			pagin.x = (stage.stageWidth - columnW - pagin.width) / 2;
			pagin.y = stage.stageHeight - deskBarH - pagin.height - boader;
			pagin.addEventListener(PaginationEvent.PAGIN_CLICK, handlerPaginBtnClick);

			trace(pagin.height);
			//先在这里实现分页拖动

			newsBook = new NewsBook(new Point(stage.stageWidth - columnW, pagin.y - boader - titleH));
			newsBook.y = titleH;
			newsBook.addEventListener(NewsBook.NEED_NEXT, handlerBookNext);
			newsBook.addEventListener(NewsBook.NEED_PREV, handlerBookPrev);
			newsBook.addEventListener(NewsBook.CHANGE_PAGE, handlerChangePage);
			this.addChild(newsBook);
			loadColumn();
		}

		private function loadColumn():void {
			var url:String = Common.instance().dataUrl;
			var code:String = Common.instance().dataCode;

			if (url == null) {
				url = cfg.columnDataUrl;
			}

			var params:Params = new Params();
			params.addParam(Common.PLATE_ID, prms.id);

			var dl:DataLoader = new DataLoader();
			dl.addEventListener(Event.COMPLETE, handlerLoadColumnCmp);
			dl.addEventListener(IOErrorEvent.IO_ERROR, handlerLoadColumnError);
			dl.loadData(url, code, Common.OPERATION_COLUMN, params);
		}

		private function handlerLoadColumnCmp(e:Event):void {

			var dl:DataLoader = e.currentTarget as DataLoader;
			var rsv:Vector.<DataSet> = dl.data;

			var btnv:Vector.<NewsImgBtn> = new Vector.<NewsImgBtn>();

			for (var i:int = 0; i < rsv.length; i++) {
				var ds:DataSet = rsv[i];
				var v:Vector.<DataDTO> = ds.dtoList;
				for (var j:int = 0; j < v.length; j++) {
					var dto:DataDTO = v[j];
					var nib:NewsImgBtn = new NewsImgBtn(new Point(48, 48), dto.img, dto.text, columnW);
					nib.buttonMode = true;
					nib.data = dto;
					btnv.push(nib);
				}
			}

			var mh:int = stage.stageHeight - titleH - deskBarH;
			var nbb:NewsBtnBox = new NewsBtnBox(btnv, mh);
			this.addChild(nbb);
			nbb.x = stage.stageWidth - nbb.width;
			nbb.y = titleH;
			nbb.addEventListener(NewsBtnBox.EVENT_BTN_CLICK, handlerBtnClick);

		}

		private function handlerLoadColumnError(e:Event):void {

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
			var dto:DataDTO = btn.data as DataDTO;
		}
	}
}
