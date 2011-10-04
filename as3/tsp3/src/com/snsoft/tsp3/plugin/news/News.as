package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.plugin.BPlugin;
	import com.snsoft.tsp3.plugin.news.dto.NewsTitleDTO;
	import com.snsoft.util.SkinsUtil;

	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;

	public class News extends BPlugin {
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

			//先在这里实现分页拖动

			var nb:NewsBook = new NewsBook(new Point(stage.stageWidth - nbb.width, mh));
			nb.y = th;
			nb.addEventListener(NewsBook.NEED_NEXT, handlerBookNext);
			nb.addEventListener(NewsBook.NEED_PREV, handlerBookPrev);
			this.addChild(nb);
		}

		private function handlerBookNext(e:Event):void {
			var nb:NewsBook = e.currentTarget as NewsBook;
			var nbp:NewsBookPage = new NewsBookPage(new Point(nb.bookSize.x, 600));
			nb.addPageNext(nbp);
		}

		private function handlerBookPrev(e:Event):void {
			trace("handlerBookPrev");
			var nb:NewsBook = e.currentTarget as NewsBook;
			var nbp:NewsBookPage = new NewsBookPage(new Point(nb.bookSize.x, 200));
			nb.addPagePrev(nbp);
		}

		private function handlerBtnClick(e:Event):void {
			var nbb:NewsBtnBox = e.currentTarget as NewsBtnBox;
			var btn:NewsImgBtn = nbb.clickBtn;
			var dto:NewsBtnDTO = btn.data as NewsBtnDTO;
			trace(dto.text);
		}
	}
}
