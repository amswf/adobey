package com.snsoft.tsp3.plugin.desktop {
	import com.snsoft.tsp3.Common;
	import com.snsoft.tsp3.PromptMsgMng;
	import com.snsoft.tsp3.ViewUtil;
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.tsp3.net.DataLoader;
	import com.snsoft.tsp3.net.DataSet;
	import com.snsoft.tsp3.pagination.Pagination;
	import com.snsoft.tsp3.pagination.PaginationEvent;
	import com.snsoft.tsp3.plugin.BPlugin;
	import com.snsoft.tsp3.touch.TouchDrag;
	import com.snsoft.tsp3.touch.TouchDragEvent;
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.di.DependencyInjection;
	import com.snsoft.util.rlm.ResLoadManager;
	import com.snsoft.util.rlm.rs.RSEmbedFonts;
	import com.snsoft.util.rlm.rs.RSImages;
	import com.snsoft.util.rlm.rs.RSTextFile;

	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.Regular;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Rectangle;

	public class Desktop extends BPlugin implements IDesktop {

		private var pagin:Pagination = new Pagination();

		private var toolBtnImgRS:RSImages = new RSImages();

		private var boardImgRS:RSImages = new RSImages();

		private var imgRS:RSImages = new RSImages();

		private var xmlDataRS:RSTextFile = new RSTextFile();

		private var toolBarLayer:Sprite = new Sprite();

		private var toolBarBackLayer:Sprite = new Sprite();

		private var backLayer:Sprite = new Sprite();

		private var boardLayer:Sprite = new Sprite();

		private var paginLayer:Sprite = new Sprite();

		private var moveBoardLock:Boolean = false;

		private var pluginBar:DyncBtnBar;

		private var allBtns:Array = new Array();

		private static const TOOL_BAR_START:String = "start";

		private static const TOOL_BAR_QUICK:String = "quick";

		private static const TOOL_BAR_STATE:String = "state";

		private var cfg:DesktopCfg = new DesktopCfg();

		private var boardData:Vector.<DataSet>;

		private var toolBarData:Vector.<DataSet>;

		public function Desktop() {
			super();
			pluginCfg = cfg;
			Common.instance().initDesktop(this);
		}

		public function pluginBarAddBtn(uuid:String):void {
			var btn:DesktopBtn = getBtn(uuid);
			if (btn != null) {
				var dto:DataDTO = btn.data as DataDTO;
				if (dto != null) {
					pluginBar.addBtn(dto, btn.uuid);
				}
			}
		}

		public function pluginBarRemoveBtn(uuid:String):void {
			pluginBar.removeBtn(uuid);
		}

		private function pushListToAllBtns(v:Vector.<DesktopBtn>):void {
			for (var i:int = 0; i < v.length; i++) {
				var btn:DesktopBtn = v[i];
				allBtns[btn.uuid] = btn;
			}
		}

		private function getBtn(uuid:String):DesktopBtn {
			return allBtns[uuid] as DesktopBtn;
		}

		override protected function init():void {
			trace("Desktop");

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			this.addChild(backLayer);
			this.addChild(toolBarBackLayer);
			this.addChild(boardLayer);
			this.addChild(paginLayer);
			this.addChild(toolBarLayer);

			imgRS.addResUrl(cfg.logoImgUrl);
			imgRS.addResUrl(cfg.backImgUrl);

			PromptMsgMng.instance().setMsg("Desktop");

			loadFonts();
		}

		private function loadFonts():void {
			var rsf:RSEmbedFonts = new RSEmbedFonts();
			rsf.addFontName("MicrosoftYaHei");
			rsf.addFontName("HZGBYS");

			var rlm:ResLoadManager = new ResLoadManager();
			rlm.addResSet(rsf);
			rlm.addEventListener(Event.COMPLETE, handlerLoadFontCmp);
			rlm.load();
		}

		private function handlerLoadFontCmp(e:Event):void {
			loadToolBarData();
		}

		private function loadToolBarData():void {
			var code:String = Common.instance().dataCode;
			var url:String = cfg.toolBarDataUrl;
			var dl:DataLoader = new DataLoader();
			dl.addEventListener(Event.COMPLETE, handlerLoadToolBarDataCmp);
			dl.addEventListener(IOErrorEvent.IO_ERROR, handlerLoadToolBarDataError);
			dl.loadData(url, code, "");
		}

		private function handlerLoadToolBarDataCmp(e:Event):void {
			var dl:DataLoader = e.currentTarget as DataLoader;
			toolBarData = dl.data;
			loadBoaderData();
		}

		private function handlerLoadToolBarDataError(e:Event):void {
			PromptMsgMng.instance().setMsg("加载工具栏按钮数据出错！");
		}

		private function loadBoaderData():void {
			var code:String = Common.instance().dataCode;
			var url:String = Common.instance().dataUrl;
			if (url == null) {
				url = cfg.boardDataUrl;
			}
			var dl:DataLoader = new DataLoader();
			dl.addEventListener(Event.COMPLETE, handlerLoadBoaderDataCmp);
			dl.addEventListener(IOErrorEvent.IO_ERROR, handlerLoadBoaderDataError);
			dl.loadData(url, code, Common.OPERATION_PLATE);

		}

		private function handlerLoadBoaderDataCmp(e:Event):void {
			var dl:DataLoader = e.currentTarget as DataLoader;
			boardData = dl.data;
			loadImgs();
		}

		private function handlerLoadBoaderDataError(e:Event):void {
			PromptMsgMng.instance().setMsg("加载桌面按钮数据出错！");
		}

		private function loadImgs():void {
			var rlm:ResLoadManager = new ResLoadManager();
			rlm.addResSet(imgRS);
			rlm.addEventListener(Event.COMPLETE, handlerLoadImgsCmp);
			rlm.load();
		}

		private function handlerLoadImgsCmp(e:Event):void {
			initDesktop();
		}

		private function initDesktop():void {

			var backbmd:BitmapData = imgRS.getImageByUrl(cfg.backImgUrl);
			var backbm:Bitmap = new Bitmap(backbmd, "auto", true);
			backbm.width = stage.stageWidth;
			backbm.height = stage.stageHeight;
			backLayer.addChild(backbm);

			var logobmd:BitmapData = imgRS.getImageByUrl(cfg.logoImgUrl);
			var logobm:Bitmap = new Bitmap(logobmd, "auto", true);
			backLayer.addChild(logobm);
			logobm.x = int(cfg.logoImgX);
			logobm.y = int(cfg.logoImgY);

			var startBarBtnDTOList:Vector.<DataDTO> = new Vector.<DataDTO>();
			var quickBarBtnDTOList:Vector.<DataDTO> = new Vector.<DataDTO>();
			var stateBarBtnDTOList:Vector.<DataDTO> = new Vector.<DataDTO>();

			var tb:int = 0;

			for (var i:int = 0; i < toolBarData.length; i++) {
				var tds:DataSet = toolBarData[i];
				if (tds.attr != null && tds.attr.type == TOOL_BAR_START) {
					startBarBtnDTOList = tds.dtoList;
				}
				else if (tds.attr != null && tds.attr.type == TOOL_BAR_QUICK) {
					quickBarBtnDTOList = tds.dtoList;
				}
				else if (tds.attr != null && tds.attr.type == TOOL_BAR_STATE) {
					stateBarBtnDTOList = tds.dtoList;
				}
			}

			var startToolBar:BtnBar = new BtnBar(startBarBtnDTOList);
			tb = stage.stageHeight - startToolBar.height;
			startToolBar.y = tb;
			startToolBar.addEventListener(BtnBar.EVENT_BTN_CLICK, handlerBtnBarBtnClick);

			var quickToolBar:BtnBar = new BtnBar(quickBarBtnDTOList);
			quickToolBar.y = tb;
			quickToolBar.x = startToolBar.width;
			quickToolBar.addEventListener(BtnBar.EVENT_BTN_CLICK, handlerBtnBarBtnClick);

			var qbtns:Vector.<DesktopBtn> = quickToolBar.btns;
			if (qbtns != null) {
				for (var i3:int = 0; i3 < qbtns.length; i3++) {
					var qbtn:DesktopBtn = qbtns[i3];
					var qdata:DataDTO = qbtn.data as DataDTO;
					Common.instance().loadPlugin(qdata.plugin, qdata.params, qbtn.uuid, false);
				}
			}
			var stateToolBar:BtnBar = new BtnBar(stateBarBtnDTOList);
			stateToolBar.y = tb;
			stateToolBar.x = stage.stageWidth - stateToolBar.width;
			stateToolBar.addEventListener(BtnBar.EVENT_BTN_CLICK, handlerBtnBarBtnClick);

			var pw:int = stage.stageWidth - quickToolBar.x - quickToolBar.width - stateToolBar.width;

			pluginBar = new DyncBtnBar(pw);
			pluginBar.y = tb;
			pluginBar.x = quickToolBar.x + quickToolBar.width;
			pluginBar.addEventListener(BtnBar.EVENT_BTN_CLICK, handlerDyncBtnBarBtnClick);

			toolBarLayer.addChild(pluginBar);
			toolBarLayer.addChild(startToolBar);
			toolBarLayer.addChild(quickToolBar);
			toolBarLayer.addChild(stateToolBar);

			pushListToAllBtns(startToolBar.btns);
			pushListToAllBtns(quickToolBar.btns);
			pushListToAllBtns(stateToolBar.btns);

			var toolBack:MovieClip = SkinsUtil.createSkinByName("Desktop_barBack");
			toolBack.width = stage.stageWidth;
			toolBack.height = toolBarLayer.height;
			toolBack.y = stage.stageHeight - toolBack.height;
			toolBarBackLayer.addChild(toolBack);

			var bpNum:int = boardData.length;

			pagin = new Pagination();
			pagin.x = (stage.stageWidth - pagin.width) / 2;
			pagin.y = stage.stageHeight - toolBack.height - pagin.height - 10;
			pagin.setPageNum(1, bpNum);
			paginLayer.addChild(pagin);

			var boardw:int = stage.stageWidth;
			var boardh:int = pagin.y;

			var bbv:Vector.<BtnBoard> = new Vector.<BtnBoard>();
			for (var j:int = 0; j < boardData.length; j++) {
				var back:Sprite = ViewUtil.creatRect(100, 100, 0xffffff);
				back.x = j * boardw;
				back.width = boardw;
				back.height = toolBack.y;
				boardLayer.addChild(back);

				var bv:Vector.<DataDTO> = boardData[j].dtoList;
				var btnBoard:BtnBoard = new BtnBoard(bv, boardw, boardh, 120, 130);
				btnBoard.x = j * boardw;
				bbv.push(btnBoard);
				boardLayer.addChild(btnBoard);

			}

			var dbx:int = -boardw * (bpNum);
			var dbw:int = boardw * (bpNum + 1);
			var dragBounds:Rectangle = new Rectangle(dbx, 0, dbw, 0);
			var td:TouchDrag = new TouchDrag(boardLayer, stage, dragBounds);
			for (var k:int = 0; k < bbv.length; k++) {
				var bb:BtnBoard = bbv[k];
				var btnV:Vector.<DesktopBtn> = bb.btnV;
				for (var i2:int = 0; i2 < btnV.length; i2++) {
					var btn:DesktopBtn = btnV[i2];
					btn.buttonMode = true;
					td.addClickObj(btn);
				}
				pushListToAllBtns(btnV);
			}

			td.addEventListener(TouchDragEvent.TOUCH_DRAG_MOUSE_UP, handlerDragMouseUp);
			td.addEventListener(TouchDragEvent.TOUCH_CLICK, handlerDragClick);

			pagin.addEventListener(PaginationEvent.PAGIN_CLICK, handlerPaginClick);

		}

		private function handlerDyncBtnBarBtnClick(e:Event):void {
			var btnBar:DyncBtnBar = e.currentTarget as DyncBtnBar;
			var btn:DesktopBtn = btnBar.btn;
			btnClick(btn);
		}

		private function handlerBtnBarBtnClick(e:Event):void {
			var btnBar:BtnBar = e.currentTarget as BtnBar;
			var btn:DesktopBtn = btnBar.btn;
			btnClick(btn);
		}

		private function handlerPaginClick(e:Event):void {
			var start:Number = boardLayer.x;
			var end:Number = -(pagin.pageNum - 1) * stage.stageWidth;
			pagin.setPageNum(pagin.pageNum, boardData.length);
			moveBoardLayer(start, end);
		}

		private function handlerDragClick(e:Event):void {
			var td:TouchDrag = e.currentTarget as TouchDrag;
			var btn:DesktopBtn = td.clickObj as DesktopBtn;
			btnClick(btn);
		}

		private function btnClick(btn:DesktopBtn):void {
			var dto:DataDTO = btn.data as DataDTO;
			if (dto.plugin != null) {
				var params:Object = new Object();
				DependencyInjection.diToObj(dto.params, params, false);
				DependencyInjection.diToObj(dto, params, false);
				Common.instance().loadPlugin(dto.plugin, params, btn.uuid);
			}
		}

		private function handlerDragMouseUp(e:Event):void {
			boardLayer.mouseEnabled = false;
			boardLayer.mouseChildren = false;

			var td:TouchDrag = e.currentTarget as TouchDrag;

			var sign:Number = td.mouseUpPoint.x > td.mouseDownPoint.x ? 1 : -1;
			var dist:Number = Math.abs(td.mouseUpPoint.x - td.mouseDownPoint.x);

			var start:Number = boardLayer.x;
			var end:Number = boardLayer.x;

			var pn:int = pagin.pageNum - sign;

			if (dist > 100 && pn >= 1 && pn <= boardData.length) {
				end = boardLayer.x + sign * (stage.stageWidth - dist);

				pagin.setPageNum(pn, boardData.length);
			}
			else {
				end = boardLayer.x - sign * dist;
			}
			moveBoardLayer(start, end);

		}

		private function moveBoardLayer(start:Number, end:Number):void {
			var twn:Tween = new Tween(boardLayer, "x", Regular.easeOut, start, end, 0.3, true);
			twn.addEventListener(TweenEvent.MOTION_FINISH, handlerMotionFinish);
			twn.start();
		}

		private function handlerMotionFinish(e:Event):void {
			var twn:Tween = e.currentTarget as Tween;
			twn.removeEventListener(TweenEvent.MOTION_FINISH, handlerMotionFinish);
			boardLayer.mouseEnabled = true;
			boardLayer.mouseChildren = true;
		}

	}
}
