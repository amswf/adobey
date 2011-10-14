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
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.SpriteUtil;

	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
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

		private const deskBarH:int = 84;

		private const infoBoader:int = 50;

		private const classH:int = 58;

		private var backLayer:Sprite = new Sprite();

		private var columnLayer:Sprite = new Sprite();

		private var bookLayer:Sprite = new Sprite();

		private var classLayer:Sprite = new Sprite();

		private var filtersLayer:Sprite = new Sprite();

		private var titleLayer:Sprite = new Sprite();

		private var paginLayer:Sprite = new Sprite();

		private var infoLayer:Sprite = new Sprite();

		private var cPlateId:String;

		private var cColumnId:String;

		private var cClassId:String;

		private var filter:Object;

		private var classBox:NewsClassBox;

		private var crntCH:int;

		private var crntFH:int;

		private var newsBookCtrler:NewsBookCtrler;

		public function News() {
			super();
			this.addChild(backLayer);
			this.addChild(columnLayer);
			this.addChild(bookLayer);
			this.addChild(classLayer);
			this.addChild(filtersLayer);
			this.addChild(titleLayer);
			this.addChild(paginLayer);
			this.addChild(infoLayer);

			pluginCfg = cfg;
			params = prms;
		}

		override protected function init():void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			cPlateId = prms.id;
			cColumnId = prms.columnId;

			trace(cPlateId, cColumnId);

			var back:MovieClip = SkinsUtil.createSkinByName("News_backSkin");
			backLayer.addChild(back);
			back.width = stage.stageWidth;
			back.height = stage.stageHeight - deskBarH;

			var ntdto:NewsTitleDTO = new NewsTitleDTO();
			ntdto.text = "新闻资讯";
			ntdto.titleImg = prms.img;
			var nt:NewsTitle = new NewsTitle(ntdto, stage.stageWidth, titleH);
			titleLayer.addChild(nt);
			nt.addEventListener(NewsTitle.EVENT_CLOSE, handlerCloseBtnClick);
			nt.addEventListener(NewsTitle.EVENT_MIN, handlerMinBtnClick);

			pagin = new Pagination(5);
			paginLayer.addChild(pagin);
			pagin.x = (stage.stageWidth - columnW - pagin.width) / 2;
			pagin.y = stage.stageHeight - deskBarH - pagin.height - boader;
			trace(pagin.height);
			//先在这里实现分页拖动

			newsBook = new NewsBook(new Point(stage.stageWidth - columnW, pagin.y - boader - titleH));
			newsBook.y = titleH;
			bookLayer.addChild(newsBook);

			classLayer.y = titleH;
			filtersLayer.y = titleH;

			classBox = new NewsClassBox(stage.stageWidth - columnW, classH, "分类", null);
			classLayer.addChild(classBox);
			classBox.visible = false;
			classBox.addEventListener(NewsClassBox.EVENT_BTN_CLICK, handlerClassBtnClick);

			newsBookCtrler = new NewsBookCtrler(newsBook, pagin);

			loadColumn();

			//stage.addEventListener(KeyboardEvent.KEY_UP, function(e:Event):void {crntCH--;resizeNewsBook();});
		}

		private function refreshBook():void {
			var ph:int = (crntCH + crntFH) * classH;
			var y:int = titleH + ph;
			var size:Point = new Point(stage.stageWidth - columnW, stage.stageHeight - deskBarH - paginH - boader - boader - titleH - ph);

			var url:String = Common.instance().dataUrl;
			var code:String = Common.instance().dataCode;

			if (url == null) {
				url = cfg.searchDataUrl;
			}

			var filterStr:String = filterToStr(filter);

			var params:Params = new Params();
			params.addParam(Common.PARAM_PLATE, cPlateId);
			params.addParam(Common.PARAM_COLUMN, cColumnId);
			params.addParam(Common.PARAM_CLASS, cClassId);
			params.addParam(Common.PARAM_FILTER, filterStr);
			params.addParam(Common.PARAM_PAGE_NUM, String(1));
			params.addParam(Common.PARAM_DIGEST_LENGTH, cfg.digestLength);
			newsBookCtrler.refresh(url, code, params, size, y);
		}

		private function loadInfo(infoId:String):void {
			var url:String = Common.instance().dataUrl;
			var code:String = Common.instance().dataCode;

			if (url == null) {
				url = cfg.infoDataUrl;
			}

			var filterStr:String = filterToStr(filter);

			var params:Params = new Params();
			params.addParam(Common.PARAM_PLATE, cPlateId);
			params.addParam(Common.PARAM_COLUMN, cColumnId);
			params.addParam(Common.PARAM_DIGEST_INFO, infoId);

			var dl:DataLoader = new DataLoader();
			dl.addEventListener(Event.COMPLETE, handlerInfoCmp);
			dl.addEventListener(IOErrorEvent.IO_ERROR, handlerInfoError);
			dl.loadData(url, code, Common.OPERATION_INFO, params);
		}

		private function handlerInfoCmp(e:Event):void {
			trace("handlerInfoCmp");
			var dl:DataLoader = e.currentTarget as DataLoader;
			var rsv:Vector.<DataSet> = dl.data;

			var itemv:Vector.<Sprite> = new Vector.<Sprite>();
			for (var i:int = 0; i < rsv.length; i++) {
				var rs:DataSet = rsv[i];

				var itype:String = rs.attr.listViewType;
				if (itype == null) {
					itype = NewsInfoBase.INFO_TYPE_I;
				}
				for (var j:int = 0; j < rs.dtoList.length; j++) {
					var dto:DataDTO = rs.dtoList[j];

					var info:NewsInfoBase;

					infoLayer.visible = true;

					var w:int = stage.stageWidth * 0.8;
					var h:int = stage.stageHeight - deskBarH - infoBoader - infoBoader;

					if (itype == NewsInfoBase.INFO_TYPE_I) {
						info = new NewsInfoI(new Point(w, h), dto);
					}
					info.addEventListener(NewsInfoBase.EVENT_CLOSE, handlerInfoClose);
					infoLayer.addChild(info);
					info.x = int((stage.stageWidth - info.width) / 2);
					info.y = infoBoader;
				}
			}
		}

		private function handlerInfoClose(e:Event):void {
			var info:NewsInfoBase = e.currentTarget as NewsInfoBase;
			info.removeEventListener(NewsInfoBase.EVENT_CLOSE, handlerInfoClose);
			SpriteUtil.deleteAllChild(infoLayer);
		}

		private function handlerInfoError(e:Event):void {

		}

		private function filterToStr(filter:Object):String {
			var filterStr:String = "";
			for (var name:String in filter) {
				filterStr += (name + ":" + filter[name] + ",");
			}
			filterStr = filterStr.substr(0, filterStr.length - 1);
			return filterStr;
		}

		private function loadFilter():void {
			filter = new Object();

			var url:String = Common.instance().dataUrl;
			var code:String = Common.instance().dataCode;

			if (url == null) {
				url = cfg.filterDataUrl;
			}

			var params:Params = new Params();
			params.addParam(Common.PARAM_PLATE, cPlateId);
			params.addParam(Common.PARAM_COLUMN, cColumnId);
			params.addParam(Common.PARAM_CLASS, cClassId);

			var dl:DataLoader = new DataLoader();
			dl.addEventListener(Event.COMPLETE, handlerLoadFilterCmp);
			dl.addEventListener(IOErrorEvent.IO_ERROR, handlerLoadFilterError);
			dl.loadData(url, code, Common.OPERATION_FILTER, params);
		}

		private function handlerLoadFilterCmp(e:Event):void {
			var dl:DataLoader = e.currentTarget as DataLoader;
			var rsv:Vector.<DataSet> = dl.data;

			var h:int = 0;
			if (classBox.visible == true) {
				h += classH;
			}

			crntFH = 0;
			for (var i:int = 0; i < rsv.length; i++) {
				crntFH++;
				var ds:DataSet = rsv[i];
				var v:Vector.<DataDTO> = ds.dtoList;
				var fbox:NewsClassBox = null;

				if (i < filtersLayer.numChildren) {
					fbox = filtersLayer.getChildAt(i) as NewsClassBox;
					fbox.clear();
				}
				else {
					fbox = new NewsClassBox(stage.stageWidth - columnW, classH, ds.attr.name, ds.attr.id, true);
					filtersLayer.addChild(fbox);
				}
				fbox.addChildren(v);
				fbox.y = h;
				h += classH;
				fbox.addEventListener(NewsClassBox.EVENT_BTN_CLICK, handlerFilterBtnClick);
			}
			refreshBook();
		}

		private function handlerFilterBtnClick(e:Event):void {
			var box:NewsClassBox = e.currentTarget as NewsClassBox;
			if (box.classType != null) {
				filter[box.classType] = box.dataId;
			}
			refreshBook();
		}

		private function handlerLoadFilterError(e:Event):void {

		}

		private function handlerClassBtnClick(e:Event):void {
			var box:NewsClassBox = e.currentTarget as NewsClassBox;
			cClassId = box.dataId;
			loadClass(false);
		}

		private function loadClass(isClear:Boolean):void {
			if (isClear) {
				classBox.clear();
			}

			var url:String = Common.instance().dataUrl;
			var code:String = Common.instance().dataCode;

			if (url == null) {
				url = cfg.classDataUrl;
			}

			var params:Params = new Params();
			params.addParam(Common.PARAM_PLATE, cPlateId);
			params.addParam(Common.PARAM_COLUMN, cColumnId);
			params.addParam(Common.PARAM_CLASS, cClassId);

			var dl:DataLoader = new DataLoader();
			dl.addEventListener(Event.COMPLETE, handlerLoadClassCmp);
			dl.addEventListener(IOErrorEvent.IO_ERROR, handlerLoadClassError);
			dl.loadData(url, code, Common.OPERATION_CLASS, params);
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
			if (cClassId == null) {
				init = true;
			}

			crntCH = 0;
			if (dtov.length > 0) {
				crntCH = 1;
				var fdto:DataDTO = dtov[0];
				cClassId = fdto.id;
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
			var url:String = Common.instance().dataUrl;
			var code:String = Common.instance().dataCode;

			if (url == null) {
				url = cfg.columnDataUrl;
			}

			var params:Params = new Params();
			params.addParam(Common.PARAM_PLATE, cPlateId);

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
			if (btnv.length > 0) {
				var fbtn:NewsImgBtn = btnv[0];
				var fdto:DataDTO = fbtn.data as DataDTO;
				if (cColumnId != null) {
					cColumnId = fdto.id;
				}
			}

			var mh:int = stage.stageHeight - titleH - deskBarH;
			var nbb:NewsBtnBox = new NewsBtnBox(btnv, mh);
			columnLayer.addChild(nbb);
			nbb.x = stage.stageWidth - nbb.width;
			nbb.y = titleH;
			nbb.addEventListener(NewsBtnBox.EVENT_BTN_CLICK, handlerBtnClick);

			for (var k:int = 0; k < btnv.length; k++) {
				var btn:NewsImgBtn = btnv[k];
				var sdto:DataDTO = btn.data as DataDTO;
				if ((cColumnId != null && cColumnId == sdto.id) || (cColumnId == null && k == 0)) {
					nbb.selectedDef(k);
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

		private function handlerBtnClick(e:Event):void {
			var nbb:NewsBtnBox = e.currentTarget as NewsBtnBox;
			var btn:NewsImgBtn = nbb.clickBtn;
			var dto:DataDTO = btn.data as DataDTO;
			cColumnId = dto.id;
			loadClass(true);
		}
	}
}
