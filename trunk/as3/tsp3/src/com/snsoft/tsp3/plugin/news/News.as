package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.Common;
	import com.snsoft.tsp3.PromptMsgMng;
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.tsp3.net.DataLoader;
	import com.snsoft.tsp3.net.DataParam;
	import com.snsoft.tsp3.net.DataSet;
	import com.snsoft.tsp3.pagination.Pagination;
	import com.snsoft.tsp3.plugin.BPlugin;
	import com.snsoft.tsp3.plugin.news.dto.NewsTitleDTO;
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.rlm.ResLoadManager;
	import com.snsoft.util.rlm.rs.RSEmbedFonts;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;

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

		private const deskBarH:int = Common.DESKTOP_TOOLBAR_HEIGHT;

		private const infoBoader:int = 30;

		private const classH:int = 44;

		private const filtersH:int = 34;

		private var backLayer:Sprite = new Sprite();

		private var columnLayer:Sprite = new Sprite();

		private var bookLayer:Sprite = new Sprite();

		private var classLayer:Sprite = new Sprite();

		private var filtersLayer:Sprite = new Sprite();

		private var titleLayer:Sprite = new Sprite();

		private var bookHeadLayer:Sprite = new Sprite();

		private var paginLayer:Sprite = new Sprite();

		private var infoLayer:Sprite = new Sprite();

		private var classBox:NewsClassBox;

		private var classCount:int;

		private var filtersCount:int;

		private var newsBookCtrler:NewsBookCtrler;

		private var newsState:NewsState = new NewsState();

		private var newsPanel:NewsPanel;

		private var panelSize:Point;

		private var panelX:int;

		private var panelY:int;

		private var newsTitle:NewsTitle;

		private var filterSelTft:TextFormat;

		private var filterUnSelTft:TextFormat;

		private var lock:Boolean = false;

		private var lockTimer:Timer;

		public function News() {
			NewsItemI;
			NewsItemII;
			NewsItemIII;
			NewsItemIV;
			NewsItemV;
			NewsItemVI;
			NewsItemVII;
			NewsItemVIII;

			NewsBoardI;
			NewsBoardII;
			NewsBoardIII;
			NewsBoardIV;

			super();
			this.addChild(backLayer);
			this.addChild(columnLayer);
			this.addChild(bookLayer);
			this.addChild(classLayer);
			this.addChild(filtersLayer);
			this.addChild(titleLayer);
			this.addChild(bookHeadLayer);
			this.addChild(paginLayer);
			this.addChild(infoLayer);

			pluginCfg = cfg;
			params = prms;
		}

		override protected function init():void {
			loadFonts();
		}

		private function loadFonts():void {
			var rsf:RSEmbedFonts = new RSEmbedFonts();
			rsf.addFontName(Common.FONT_YH);
			rsf.addFontName(Common.FONT_HZGBYS);

			var rlm:ResLoadManager = new ResLoadManager();
			rlm.addResSet(rsf);
			rlm.addEventListener(Event.COMPLETE, handlerLoadFontCmp);
			rlm.load();
		}

		private function handlerLoadFontCmp(e:Event):void {
			filterSelTft = new TextFormat(RSEmbedFonts.findFontByName(Common.FONT_YH), 14, 0xffffff);
			filterUnSelTft = new TextFormat(RSEmbedFonts.findFontByName(Common.FONT_YH), 14, 0x666666);

			initBase();
		}

		private function initBase():void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			//prms.id = "5bc003ec024e49a995dbeb85f8734b84";
			//prms.text = "新闻资讯";

			trace(prms.id, prms.columnId, prms.text);

			newsState.cPlateId = prms.id;
			newsState.cColumnId = prms.columnId;

			newsState.pageSize = int(cfg.pageSize);
			newsState.digestLength = int(cfg.digestLength);

			trace("newsState", cfg.pageSize, cfg.digestLength);

			lockTimer = new Timer(Common.REQ_DELAY_TIME, 1);

			lockTimer.addEventListener(TimerEvent.TIMER_COMPLETE, handlerLockTimerCmp);

			var back:MovieClip = SkinsUtil.createSkinByName("News_backSkin");
			backLayer.addChild(back);
			back.width = stage.stageWidth;
			back.height = stage.stageHeight - deskBarH;

			var ntdto:NewsTitleDTO = new NewsTitleDTO();
			ntdto.text = prms.text;
			ntdto.img = prms.img;
			ntdto.titleImg = prms.titleImg;
			newsTitle = new NewsTitle(ntdto, stage.stageWidth, titleH);
			titleLayer.addChild(newsTitle);
			newsTitle.addEventListener(NewsTitle.EVENT_CLOSE, handlerCloseBtnClick);
			newsTitle.addEventListener(NewsTitle.EVENT_MIN, handlerMinBtnClick);
			newsTitle.addEventListener(NewsTitle.EVENT_SEARCH, handlerSearchBtnClick);

			pagin = new Pagination(5);
			pagin.visible = false;
			paginLayer.addChild(pagin);
			pagin.x = (stage.stageWidth - columnW - pagin.width) / 2;
			pagin.y = stage.stageHeight - deskBarH - pagin.height - boader;
			//先在这里实现分页拖动

			newsBook = new NewsBook(new Point(stage.stageWidth - columnW, pagin.getRect(paginLayer).bottom - boader - titleH));
			newsBook.y = titleH;
			bookLayer.addChild(newsBook);

			classLayer.y = titleH;
			filtersLayer.y = titleH;

			classBox = new NewsClassBox(stage.stageWidth - columnW, classH, null, null, true, NewsClassBox.ALIGN_RIGHT);
			classLayer.addChild(classBox);
			classBox.visible = false;
			classBox.addEventListener(NewsClassBox.EVENT_BTN_CLICK, handlerClassBtnClick);

			newsBookCtrler = new NewsBookCtrler(newsBook, pagin, bookHeadLayer);
			newsBookCtrler.addEventListener(NewsBookCtrler.EVENT_ITEM_CLICK, handlerItemClick);
			newsBookCtrler.addEventListener(NewsBookCtrler.EVENT_LOAD_COMPLETE, handlerloadItemsCmp);

			loadColumn();

			var rate:Number = 0.8;
			var w:int = stage.stageWidth * 0.8;
			var h:int = stage.stageHeight - deskBarH - infoBoader - infoBoader;
			panelSize = new Point(w, h);

			panelX = int(stage.stageWidth * (1 - 0.8) / 2);
			panelY = infoBoader;

			var code:String = Common.instance().dataCode;

			var infoUrl:String = Common.instance().dataUrl;
			if (infoUrl == null) {
				infoUrl = cfg.infoDataUrl;
			}

			var itemsUrl:String = Common.instance().dataUrl;
			if (itemsUrl == null) {
				itemsUrl = cfg.searchDataUrl;
			}

			infoLayer.visible = false;

			var newsPanelLock:Sprite = SkinsUtil.createSkinByName("NewsPanel_lockSkin");
			newsPanelLock.width = back.width;
			newsPanelLock.height = back.height;
			infoLayer.addChild(newsPanelLock);

			newsPanel = new NewsPanel(panelSize, infoUrl, itemsUrl, code);
			newsPanel.x = panelX;
			newsPanel.y = panelY;
			infoLayer.addChild(newsPanel);
			newsPanel.addEventListener(NewsPanel.EVENT_CLOSE, handlerPanelClose);

			//stage.addEventListener(KeyboardEvent.KEY_UP, function(e:Event):void {crntCH--;resizeNewsBook();});

		}

		private function handlerPanelClose(e:Event):void {
			infoLayer.visible = false;
		}

		private function refreshBook():void {
			newsState.pageNum = 1;
			newsState.infoId = null;
			newsState.pageCol = getItemColNum();

			var ph:int = classCount * classH + filtersCount * filtersH;
			var y:int = titleH + ph;
			var size:Point = new Point(stage.stageWidth - columnW, stage.stageHeight - deskBarH - titleH - ph);

			var url:String = Common.instance().dataUrl;
			var code:String = Common.instance().dataCode;

			if (url == null) {
				url = cfg.searchDataUrl;
			}

			newsBookCtrler.refresh(url, code, newsState, size, pagin.height, y);
		}

		private function getItemColNum():int {
			var type:String = newsState.listViewType;
			var n:int = 1;
			var cn:int = newsState.columnNumber;
			var MClass:Class = null;
			try {
				MClass = getDefinitionByName("com.snsoft.tsp3.plugin.news.NewsItem" + type) as Class;
			}
			catch (error:Error) {
				trace("找不到[列表]显示类型：" + type);
			}
			if (MClass != null) {
				var item:NewsItemBase = new MClass(new DataDTO) as NewsItemBase;
				if (item != null && item.autoCol) {
					var bp:NewsBookPage = new NewsBookPage(new Point(newsBook.bookSize.x, 100), 1);
					var bw:int = bp.itemsWidth + 1;
					var w:int = item.itemWidth;
					n = bw / w;
				}
				else if (cn > 0) {
					n = cn;
				}
			}
			return n;
		}

		private function handlerloadItemsCmp(e:Event):void {
			newsState.detailViewType = newsBookCtrler.infoViewType;
			newsState.listViewType = newsBookCtrler.itemViewType;
			lockStop();
		}

		private function handlerItemClick(e:Event):void {
			var item:NewsItemBase = newsBookCtrler.clickItem;
			if (item.clickType == NewsItemBase.CLICK_TYPE_INFO) {
				newsState.infoId = item.data.id;
				newsPanel.refresh(newsState);
				infoLayer.visible = true;
			}
			else if (item.clickType == NewsItemBase.CLICK_TYPE_PLAY) {
				if (item.data.videos != null && item.data.videos.length > 0) {
					var video:DataParam = item.data.videos[0];
					Common.instance().playVideo(video.url, video.text);
				}
				else if (item.data.audios != null && item.data.audios.length > 0) {
					var audio:DataParam = item.data.audios[0];
					Common.instance().playMp3(audio.url, audio.text);
				}
			}
		}

		private function loadFilter():void {
			newsState.pageNum = 1;
			newsState.infoId = null;

			newsState.filter = new Object();

			var url:String = Common.instance().dataUrl;
			var code:String = Common.instance().dataCode;

			if (url == null) {
				url = cfg.filterDataUrl;
			}

			var dl:DataLoader = new DataLoader();
			dl.addEventListener(Event.COMPLETE, handlerLoadFilterCmp);
			dl.addEventListener(IOErrorEvent.IO_ERROR, handlerLoadFilterError);
			dl.loadData(url, code, Common.OPERATION_FILTER, newsState.toParams());
		}

		private function handlerLoadFilterCmp(e:Event):void {
			if (stage != null) {
				var dl:DataLoader = e.currentTarget as DataLoader;
				var rsv:Vector.<DataSet> = dl.data;

				var h:int = classCount * classH;

				filtersCount = 0;
				var cn:int = rsv.length;
				while (filtersLayer.numChildren > cn) {
					filtersLayer.removeChildAt(filtersLayer.numChildren - 1);
				}

				for (var i:int = 0; i < rsv.length; i++) {
					filtersCount++;
					var ds:DataSet = rsv[i];
					var v:Vector.<DataDTO> = ds.dtoList;
					var fbox:NewsClassBox = null;

					if (i < filtersLayer.numChildren) {
						fbox = filtersLayer.getChildAt(i) as NewsClassBox;
						fbox.clear();
					}
					else {
						fbox = new NewsClassBox(stage.stageWidth - columnW, filtersH, ds.attr.name, ds.attr.id, true);
						fbox.selectedSkin = "NewsFilterBtn_selectedSkin";
						fbox.unSelectedSkin = "NewsFilterBtn_unSelectedSkin";
						fbox.backSkin = "NewsFilterBox_backSkin";
						fbox.selTft = filterSelTft;
						fbox.unSelTft = filterUnSelTft;
						filtersLayer.addChild(fbox);
					}
					fbox.title = ds.attr.name;
					fbox.classType = ds.attr.id;
					fbox.addChildren(v);
					fbox.y = h;
					h += filtersH;
					fbox.addEventListener(NewsClassBox.EVENT_BTN_CLICK, handlerFilterBtnClick);
				}
				refreshBook();
			}
		}

		private function handlerFilterBtnClick(e:Event):void {
			if (!lock) {
				lockStart();
				var box:NewsClassBox = e.currentTarget as NewsClassBox;
				if (box.classType != null) {
					var dto:DataDTO = box.data;
					newsState.filter[box.classType] = dto.id;
				}
				refreshBook();
			}
		}

		private function handlerLoadFilterError(e:Event):void {

		}

		private function loadClass(isClear:Boolean):void {
			newsState.filter = null;
			newsState.searchText = null;
			newsState.pageNum = 1;
			newsState.infoId = null;

			newsState.type = NewsState.TYPE_FACTOR;
			clearSearchText();

			if (isClear) {
				newsState.cClassId = null;
				classBox.clear();
				classBox.visible = false;
			}

			var url:String = Common.instance().dataUrl;
			var code:String = Common.instance().dataCode;

			if (url == null) {
				url = cfg.classDataUrl;
			}

			var dl:DataLoader = new DataLoader();
			dl.addEventListener(Event.COMPLETE, handlerLoadClassCmp);
			dl.addEventListener(IOErrorEvent.IO_ERROR, handlerLoadClassError);
			dl.loadData(url, code, Common.OPERATION_CLASS, newsState.toParams());
		}

		private function handlerLoadClassCmp(e:Event):void {
			var dl:DataLoader = e.currentTarget as DataLoader;
			var rsv:Vector.<DataSet> = dl.data;

			var dtov:Vector.<DataDTO> = new Vector.<DataDTO>();
			for (var i:int = 0; i < rsv.length; i++) {
				var ds:DataSet = rsv[i];
				var v:Vector.<DataDTO> = ds.dtoList;
				for (var j:int = 0; j < v.length; j++) {
					var dto:DataDTO = v[j];
					dtov.push(dto);
				}
			}

			var init:Boolean = false;
			if (newsState.cClassId == null) {
				init = true;
			}

			classCount = 0;
			if (dtov.length > 0) {
				classCount = 1;
				var fdto:DataDTO = dtov[0];
				newsState.cClassId = fdto.id;
				newsStateSetViewType(fdto);
				classBox.visible = true;
				classBox.addChildren(dtov);
				if (init) {
					classBox.selectedDef(0);
				}
			}
			loadFilter();
		}

		private function handlerLoadClassError(e:Event):void {

		}

		private function loadColumn():void {
			newsState.cClassId = null;
			newsState.filter = null;
			newsState.searchText = null;
			newsState.pageNum = 1;
			newsState.infoId = null;

			newsState.type = NewsState.TYPE_FACTOR;
			clearSearchText();

			var url:String = Common.instance().dataUrl;
			var code:String = Common.instance().dataCode;

			if (url == null) {
				url = cfg.columnDataUrl;
			}

			var dl:DataLoader = new DataLoader();
			dl.addEventListener(Event.COMPLETE, handlerLoadColumnCmp);
			dl.addEventListener(IOErrorEvent.IO_ERROR, handlerLoadColumnError);
			dl.loadData(url, code, Common.OPERATION_COLUMN, newsState.toParams());
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
					trace(dto.listViewType);
					var nib:NewsImgBtn = new NewsImgBtn(new Point(44, 44), dto.img, dto.text, columnW);
					nib.buttonMode = true;
					nib.data = dto;
					btnv.push(nib);
				}
			}

			var mh:int = stage.stageHeight - titleH - deskBarH;
			var nbb:NewsBtnBox = new NewsBtnBox(btnv, mh);
			columnLayer.addChild(nbb);
			nbb.x = stage.stageWidth - nbb.width;
			nbb.y = titleH;
			nbb.addEventListener(NewsBtnBox.EVENT_BTN_CLICK, handlerColumnBtnClick);

			for (var k:int = 0; k < btnv.length; k++) {
				var btn:NewsImgBtn = btnv[k];
				var sdto:DataDTO = btn.data as DataDTO;
				if ((newsState.cColumnId != null && newsState.cColumnId == sdto.id) || (newsState.cColumnId == null && k == 0)) {
					nbb.selectedDef(k);
					newsState.cColumnId = sdto.id;
					newsStateSetViewType(sdto);
					break;
				}
			}

			loadClass(true);
		}

		private function handlerLoadColumnError(e:Event):void {

		}

		private function handlerCloseBtnClick(e:Event):void {
			closePlugin();
		}

		private function handlerMinBtnClick(e:Event):void {
			minimizePlugin();
		}

		private function handlerSearchBtnClick(e:Event):void {
			if (!lock) {
				lockStart();
				var nt:NewsTitle = e.currentTarget as NewsTitle;
				newsState.searchText = nt.searchText;
				newsState.type = NewsState.TYPE_SEARCH;
				refreshBook();
			}
		}

		private function handlerColumnBtnClick(e:Event):void {
			if (!lock) {
				lockStart();
				var nbb:NewsBtnBox = e.currentTarget as NewsBtnBox;
				var btn:NewsImgBtn = nbb.clickBtn;
				var dto:DataDTO = btn.data as DataDTO;
				newsState.cColumnId = dto.id;
				newsStateSetViewType(dto);
				loadClass(true);
			}
		}

		private function handlerClassBtnClick(e:Event):void {
			if (!lock) {
				lockStart();
				var box:NewsClassBox = e.currentTarget as NewsClassBox;
				var dto:DataDTO = box.data;
				newsState.cClassId = dto.id;
				newsStateSetViewType(dto);
				//loadClass(false);  //目前不需要显示子分类，分类只有一级。
				loadFilter();
			}
		}

		private function newsStateSetViewType(dto:DataDTO):void {
			trace("newsStateSetViewType:", newsState.listViewType);
			newsState.listViewType = dto.listViewType;
			newsState.detailViewType = dto.detailViewType;
			newsState.columnNumber = int(dto.columnNumber);
		}

		private function handlerLockTimerCmp(e:Event):void {
			lockStop();
			PromptMsgMng.instance().setMsg("请求数据超时...");
		}

		private function lockStart():void {
			lock = true;
			lockTimer.start();
		}

		private function lockStop():void {
			lockTimer.stop();
			lock = false;
		}

		private function clearSearchText():void {
			newsTitle.clearSearchText();
			newsState.searchText = null;
		}

	}
}
