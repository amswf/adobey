﻿package com.snsoft.tsp3.plugin.desktop {
	import com.snsoft.tsp3.PromptMsgMng;
	import com.snsoft.tsp3.XMLData;
	import com.snsoft.tsp3.plugin.BPlugin;
	import com.snsoft.tsp3.plugin.desktop.dto.DesktopBtnDTO;
	import com.snsoft.util.rlm.ResLoadManager;
	import com.snsoft.util.rlm.rs.RSImages;
	import com.snsoft.util.rlm.rs.RSTextFile;
	import com.snsoft.util.xmldom.Node;
	import com.snsoft.util.xmldom.NodeList;
	import com.snsoft.util.xmldom.XMLDom;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class Desktop extends BPlugin {

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
			var quickToolBar:BtnBar = new BtnBar(quickBarBtnDTOList);
			quickToolBar.y = tb;
			quickToolBar.x = startToolBar.width;
			var stateToolBar:BtnBar = new BtnBar(stateBarBtnDTOList);
			stateToolBar.y = tb;
			stateToolBar.x = stage.stageWidth - stateToolBar.width;

			toolBarLayer.addChild(startToolBar);
			toolBarLayer.addChild(quickToolBar);
			toolBarLayer.addChild(stateToolBar);

			var toolbmd:BitmapData = imgRS.getImageByUrl(toolBarBackImgUrl);
			var toolbm:Bitmap = new Bitmap(toolbmd, "auto", true);
			toolbm.width = stage.stageWidth;
			toolbm.height = toolBarLayer.height;
			toolbm.y = stage.stageHeight - toolbm.height;
			toolBarBackLayer.addChild(toolbm);

			var bbv:Vector.<BtnBoard> = new Vector.<BtnBoard>();
			for (var j:int = 0; j < boardBtnDTOLL.length; j++) {
				var btnBoard:BtnBoard = new BtnBoard(boardBtnDTOLL[j], stage.stageWidth, stage.stageHeight - toolbm.height - 50, 80, 100);
				bbv.push(btnBoard);
			}
			boardLayer.addChild(bbv[0]);
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
