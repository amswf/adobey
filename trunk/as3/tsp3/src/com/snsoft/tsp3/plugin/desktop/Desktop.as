package com.snsoft.tsp3.plugin.desktop {
	import com.snsoft.tsp3.Common;
	import com.snsoft.tsp3.PromptMsgMng;
	import com.snsoft.tsp3.ViewUtil;
	import com.snsoft.tsp3.XMLData;
	import com.snsoft.tsp3.net.DataLoader;
	import com.snsoft.tsp3.pagination.Pagination;
	import com.snsoft.tsp3.pagination.PaginationEvent;
	import com.snsoft.tsp3.plugin.BPlugin;
	import com.snsoft.tsp3.plugin.desktop.dto.DesktopBtnDTO;
	import com.snsoft.tsp3.touch.TouchDrag;
	import com.snsoft.tsp3.touch.TouchDragEvent;
	import com.snsoft.util.rlm.ResLoadManager;
	import com.snsoft.util.rlm.rs.RSImages;
	import com.snsoft.util.rlm.rs.RSTextFile;
	import com.snsoft.util.xmldom.Node;
	import com.snsoft.util.xmldom.NodeList;
	import com.snsoft.util.xmldom.XMLDom;

	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.Regular;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class Desktop extends BPlugin implements IDesktop {

		private var pagin:Pagination = new Pagination();

		private var toolBtnImgRS:RSImages = new RSImages();

		private var boardImgRS:RSImages = new RSImages();

		private var imgRS:RSImages = new RSImages();

		private var xmlDataRS:RSTextFile = new RSTextFile();

		private var boardBtnDTOLL:Vector.<Vector.<DesktopBtnDTO>> = new Vector.<Vector.<DesktopBtnDTO>>();

		private var startBarBtnDTOList:Vector.<DesktopBtnDTO> = new Vector.<DesktopBtnDTO>();

		private var quickBarBtnDTOList:Vector.<DesktopBtnDTO> = new Vector.<DesktopBtnDTO>();

		private var stateBarBtnDTOList:Vector.<DesktopBtnDTO> = new Vector.<DesktopBtnDTO>();

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

		private static const CAPTURES:String = "captures";

		private var cfg:DesktopCfg = new DesktopCfg();

		private var boardXMLData:XMLData;

		private var toolBarXMLData:XMLData;

		public function Desktop() {
			super();
			pluginCfg = cfg;
			Common.instance().initDesktop(this);
		}

		public function pluginBarAddBtn(uuid:String):void {
			var btn:DesktopBtn = getBtn(uuid);
			if (btn != null) {
				var dto:DesktopBtnDTO = btn.data as DesktopBtnDTO;
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

			imgRS.addResUrl(pluginCfg.toolBarBackImgUrl);
			imgRS.addResUrl(pluginCfg.backImgUrl);

			PromptMsgMng.instance().setMsg("Desktop");

			loadToolBarData();
		}

		private function loadToolBarData():void {
			var url:String = cfg.toolBarDataUrl;
			var ul:URLLoader = new URLLoader(new URLRequest(url));
			ul.addEventListener(Event.COMPLETE, handlerLoadToolBarDataCmp);
			ul.addEventListener(IOErrorEvent.IO_ERROR, handlerLoadToolBarDataError);
		}

		private function handlerLoadToolBarDataCmp(e:Event):void {
			var ul:URLLoader = e.currentTarget as URLLoader;
			toolBarXMLData = new XMLData(ul.data);
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
			dl.loadData(url, code, CAPTURES);

		}

		private function handlerLoadBoaderDataCmp(e:Event):void {
			var dl:DataLoader = e.currentTarget as DataLoader;
			boardXMLData = new XMLData(dl.data);
			parseXMLData();
		}

		private function handlerLoadBoaderDataError(e:Event):void {
			PromptMsgMng.instance().setMsg("加载桌面按钮数据出错！");
		}

		private function parseXMLData():void {

			parseToolBtnXMLData(toolBarXMLData);
			parseBoardXMLData(boardXMLData);
			loadImgs();
		}

		private function parseBoardXMLData(xmlData:XMLData):void {
			var bodyNode:Node = xmlData.bodyNode;
			var groupList:NodeList = bodyNode.getNodeList("recordset");
			for (var i:int = 0; i < groupList.length(); i++) {
				var boardBtnDTOList:Vector.<DesktopBtnDTO> = new Vector.<DesktopBtnDTO>();
				var groupNode:Node = groupList.getNode(i);
				var btnList:NodeList = groupNode.getNodeList("record");
				for (var j:int = 0; j < btnList.length(); j++) {
					var btnNode:Node = btnList.getNode(j);
					var dto:DesktopBtnDTO = creatToolBarBtnDTO(btnNode);
					boardImgRS.addResUrl(dto.imgUrl);
					boardBtnDTOList.push(dto);
				}
				boardBtnDTOLL.push(boardBtnDTOList);
			}
		}

		private function parseToolBtnXMLData(xmlData:XMLData):void {
			var bodyNode:Node = xmlData.bodyNode;
			var setList:NodeList = bodyNode.getNodeList("recordset");
			for (var i2:int = 0; i2 < setList.length(); i2++) {
				var setNode:Node = setList.getNode(i2);
				var type:String = setNode.getAttributeByName("type");
				var dtoList:Vector.<DesktopBtnDTO> = null;
				if (type == TOOL_BAR_START) {
					dtoList = startBarBtnDTOList;
				}
				else if (type == TOOL_BAR_QUICK) {
					dtoList = quickBarBtnDTOList;
				}
				else if (type == TOOL_BAR_STATE) {
					dtoList = stateBarBtnDTOList;
				}
				var rcdList:NodeList = setNode.getNodeList("record");
				for (var j2:int = 0; j2 < rcdList.length(); j2++) {
					var rcdNode:Node = rcdList.getNode(j2);
					var dto:DesktopBtnDTO = creatToolBarBtnDTO(rcdNode);
					dtoList.push(dto);
					toolBtnImgRS.addResUrl(dto.imgUrl);
				}
			}
		}

		private function loadImgs():void {
			var rlm:ResLoadManager = new ResLoadManager();
			rlm.addResSet(toolBtnImgRS);
			rlm.addResSet(boardImgRS);
			rlm.addResSet(imgRS);
			rlm.addEventListener(Event.COMPLETE, handlerLoadImgsCmp);
			rlm.load();
		}

		private function handlerLoadImgsCmp(e:Event):void {
			initDesktop();
		}

		private function initDesktop():void {

			var backbmd:BitmapData = imgRS.getImageByUrl(pluginCfg.backImgUrl);
			var backbm:Bitmap = new Bitmap(backbmd, "auto", true);
			backbm.width = stage.stageWidth;
			backbm.height = stage.stageHeight;
			backLayer.addChild(backbm);

			for (var i:int = 0; i < boardBtnDTOLL.length; i++) {
				var bbdlist:Vector.<DesktopBtnDTO> = boardBtnDTOLL[i];
				dtoListSetImg(bbdlist, boardImgRS);
			}

			dtoListSetImg(startBarBtnDTOList, toolBtnImgRS);
			dtoListSetImg(quickBarBtnDTOList, toolBtnImgRS);
			dtoListSetImg(stateBarBtnDTOList, toolBtnImgRS);

			var tb:int = 0;
			var startToolBar:BtnBar = new BtnBar(startBarBtnDTOList);
			tb = stage.stageHeight - startToolBar.height;
			startToolBar.y = tb;
			startToolBar.addEventListener(BtnBar.EVENT_BTN_CLICK, handlerBtnBarBtnClick);

			var quickToolBar:BtnBar = new BtnBar(quickBarBtnDTOList);
			quickToolBar.y = tb;
			quickToolBar.x = startToolBar.width;
			quickToolBar.addEventListener(BtnBar.EVENT_BTN_CLICK, handlerBtnBarBtnClick);

			var stateToolBar:BtnBar = new BtnBar(stateBarBtnDTOList);
			stateToolBar.y = tb;
			stateToolBar.x = stage.stageWidth - stateToolBar.width;
			stateToolBar.addEventListener(BtnBar.EVENT_BTN_CLICK, handlerBtnBarBtnClick);

			pluginBar = new DyncBtnBar(5);
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

			var toolbmd:BitmapData = imgRS.getImageByUrl(pluginCfg.toolBarBackImgUrl);
			var toolbm:Bitmap = new Bitmap(toolbmd, "auto", true);
			toolbm.width = stage.stageWidth;
			toolbm.height = toolBarLayer.height;
			toolbm.y = stage.stageHeight - toolbm.height;
			toolBarBackLayer.addChild(toolbm);

			pagin = new Pagination();
			pagin.x = (stage.stageWidth - pagin.width) / 2;
			pagin.y = stage.stageHeight - toolbm.height - pagin.height - 10;
			pagin.setPageNum(1, boardBtnDTOLL.length);
			paginLayer.addChild(pagin);

			var boardw:int = stage.stageWidth;
			var boardh:int = pagin.y;

			var bbv:Vector.<BtnBoard> = new Vector.<BtnBoard>();
			for (var j:int = 0; j < boardBtnDTOLL.length; j++) {
				var back:Sprite = ViewUtil.creatRect(100, 100, 0xffffff);
				back.x = j * boardw;
				back.width = boardw;
				back.height = toolbm.y;
				boardLayer.addChild(back);

				var btnBoard:BtnBoard = new BtnBoard(boardBtnDTOLL[j], boardw, boardh, 80, 100);
				btnBoard.x = j * boardw;
				bbv.push(btnBoard);
				boardLayer.addChild(btnBoard);

			}

			var dbx:int = -boardw * (boardBtnDTOLL.length);
			var dbw:int = boardw * (boardBtnDTOLL.length + 1);
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
			pagin.setPageNum(pagin.pageNum, boardBtnDTOLL.length);
			moveBoardLayer(start, end);
		}

		private function handlerDragClick(e:Event):void {
			var td:TouchDrag = e.currentTarget as TouchDrag;
			var btn:DesktopBtn = td.clickObj as DesktopBtn;
			btnClick(btn);
		}

		private function btnClick(btn:DesktopBtn):void {
			var dto:DesktopBtnDTO = btn.data as DesktopBtnDTO;
			if (dto.plugin != null) {
				Common.instance().loadPlugin(dto.plugin, dto.params, btn.uuid);
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

			if (dist > 100 && pn >= 1 && pn <= boardBtnDTOLL.length) {
				end = boardLayer.x + sign * (stage.stageWidth - dist);

				pagin.setPageNum(pn, boardBtnDTOLL.length);
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

		private function dtoListSetImg(v:Vector.<DesktopBtnDTO>, rs:RSImages):void {
			for (var i:int = 0; i < v.length; i++) {
				var dto:DesktopBtnDTO = v[i];
				var url:String = dto.imgUrl;
				var bmd:BitmapData = rs.getImageByUrl(url);
				dto.img = bmd;
			}
		}

		private function creatToolBarBtnDTO(node:Node):DesktopBtnDTO {
			var dto:DesktopBtnDTO = new DesktopBtnDTO();
			node.attrToObj(dto);
			var params:Object = new Object();
			var paramsNode:Node = node.getNodeListFirstNode("params");
			paramsNode.attrToObj(params);
			paramsNode.childNodeTextTObj(params);
			dto.params = params;
			return dto;
		}

	}
}
