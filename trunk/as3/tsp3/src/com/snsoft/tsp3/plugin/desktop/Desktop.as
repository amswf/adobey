package com.snsoft.tsp3.plugin.desktop {
	import com.snsoft.tsp3.PromptMsgMng;
	import com.snsoft.tsp3.ViewUtil;
	import com.snsoft.tsp3.XMLData;
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
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class Desktop extends BPlugin {

		private var pagin:Pagination = new Pagination();

		private var toolBtnImgRS:RSImages = new RSImages();

		private var boardImgRS:RSImages = new RSImages();

		private var imgRS:RSImages = new RSImages();

		private var xmlDataRS:RSTextFile = new RSTextFile();

		private var boardBtnDTOLL:Vector.<Vector.<DesktopBtnDTO>> = new Vector.<Vector.<DesktopBtnDTO>>();

		private var startBarBtnDTOList:Vector.<DesktopBtnDTO> = new Vector.<DesktopBtnDTO>();

		private var quickBarBtnDTOList:Vector.<DesktopBtnDTO> = new Vector.<DesktopBtnDTO>();

		private var stateBarBtnDTOList:Vector.<DesktopBtnDTO> = new Vector.<DesktopBtnDTO>();

		private var _toolBarDataUrl:String;

		private var _boardDataUrl:String;

		private var _backImgUrl:String;

		private var _toolBarBackImgUrl:String;

		private var toolBarLayer:Sprite = new Sprite();

		private var toolBarBackLayer:Sprite = new Sprite();

		private var backLayer:Sprite = new Sprite();

		private var boardLayer:Sprite = new Sprite();

		private var paginLayer:Sprite = new Sprite();

		private var moveBoardLock:Boolean = false;

		public function Desktop() {
			super();
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

			imgRS.addResUrl(toolBarBackImgUrl);
			imgRS.addResUrl(backImgUrl);

			PromptMsgMng.instance().setMsg("Desktop");

			loadBarsXML();
		}

		private function loadBarsXML():void {

			xmlDataRS.addResUrl(dataBaseUrl + toolBarDataUrl);
			xmlDataRS.addResUrl(dataBaseUrl + boardDataUrl);

			var rlm:ResLoadManager = new ResLoadManager();
			rlm.addEventListener(Event.COMPLETE, handlerLoadXMLDataCmp);
			rlm.addResSet(xmlDataRS);
			rlm.load();

		}

		private function handlerLoadXMLDataCmp(e:Event):void {
			parseXMLData();
		}

		private function parseXMLData():void {

			var tbstr:String = xmlDataRS.getTextByUrl(dataBaseUrl + toolBarDataUrl);
			var bstr:String = xmlDataRS.getTextByUrl(dataBaseUrl + boardDataUrl);

			var tbxd:XMLData = new XMLData(tbstr);
			var bxd:XMLData = new XMLData(bstr);

			if (tbxd.isCmp && bxd.isCmp) {
				parseToolBtnXMLData(tbxd);
				parseBoardXMLData(bxd);
				loadImgs();
			}
		}

		private function parseBoardXMLData(xmlData:XMLData):void {
			var bodyNode:Node = xmlData.bodyNode;
			var groupList:NodeList = bodyNode.getNodeList("group");
			for (var i:int = 0; i < groupList.length(); i++) {
				var boardBtnDTOList:Vector.<DesktopBtnDTO> = new Vector.<DesktopBtnDTO>();
				var groupNode:Node = groupList.getNode(i);
				var btnList:NodeList = groupNode.getNodeList("btn");
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
			var startNode:Node = bodyNode.getNodeListFirstNode("start");
			var startBtnNode:Node = startNode.getNodeListFirstNode("btn");
			var startDTO:DesktopBtnDTO = creatToolBarBtnDTO(startBtnNode);
			startBarBtnDTOList.push(startDTO);
			toolBtnImgRS.addResUrl(startDTO.imgUrl);

			var quickNode:Node = bodyNode.getNodeListFirstNode("quick");
			var quickList:NodeList = quickNode.getNodeList("btn");
			for (var i:int = 0; i < quickList.length(); i++) {
				var quickBtnNode:Node = quickList.getNode(i);
				var quickDTO:DesktopBtnDTO = creatToolBarBtnDTO(quickBtnNode);
				quickBarBtnDTOList.push(quickDTO);
				toolBtnImgRS.addResUrl(quickDTO.imgUrl);
			}

			var stateNode:Node = bodyNode.getNodeListFirstNode("state");
			var stateList:NodeList = stateNode.getNodeList("btn");
			for (var j:int = 0; j < stateList.length(); j++) {
				var stateBtnNode:Node = stateList.getNode(j);
				var stateDTO:DesktopBtnDTO = creatToolBarBtnDTO(stateBtnNode);
				stateBarBtnDTOList.push(stateDTO);
				toolBtnImgRS.addResUrl(stateDTO.imgUrl);
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

			var backbmd:BitmapData = imgRS.getImageByUrl(backImgUrl);
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

			toolBarLayer.addChild(startToolBar);
			toolBarLayer.addChild(quickToolBar);
			toolBarLayer.addChild(stateToolBar);

			var toolbmd:BitmapData = imgRS.getImageByUrl(toolBarBackImgUrl);
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
			}

			td.addEventListener(TouchDragEvent.TOUCH_DRAG_MOUSE_UP, handlerDragMouseUp);
			td.addEventListener(TouchDragEvent.TOUCH_CLICK, handlerDragClick);

			pagin.addEventListener(PaginationEvent.PAGIN_CLICK, handlerPaginClick);

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
			trace(dto.text);
		}

		private function handlerDragMouseUp(e:Event):void {
			trace("handlerDragMouseUp");
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

		public function get toolBarDataUrl():String {
			return _toolBarDataUrl;
		}

		public function set toolBarDataUrl(value:String):void {
			_toolBarDataUrl = value;
		}

		public function get backImgUrl():String {
			return _backImgUrl;
		}

		public function set backImgUrl(value:String):void {
			_backImgUrl = value;
		}

		public function get toolBarBackImgUrl():String {
			return _toolBarBackImgUrl;
		}

		public function set toolBarBackImgUrl(value:String):void {
			_toolBarBackImgUrl = value;
		}

		public function get boardDataUrl():String {
			return _boardDataUrl;
		}

		public function set boardDataUrl(value:String):void {
			_boardDataUrl = value;
		}

	}
}
