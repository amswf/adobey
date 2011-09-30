package com.snsoft.tsp3.plugin.desktop {
	import com.snsoft.tsp3.Common;
	import com.snsoft.tsp3.PromptMsgMng;
	import com.snsoft.tsp3.XMLData;
	import com.snsoft.tsp3.plugin.BPlugin;
	import com.snsoft.tsp3.plugin.desktop.dto.DesktopBtnDTO;
	import com.snsoft.util.rlm.ResLoadManager;
	import com.snsoft.util.rlm.rs.RSImages;
	import com.snsoft.util.xmldom.Node;
	import com.snsoft.util.xmldom.NodeList;
	import com.snsoft.util.xmldom.XMLDom;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.sampler.Sample;

	public class Desktop extends BPlugin {

		private var toolBtnImgRS:RSImages = new RSImages();

		private var imgRS:RSImages = new RSImages();

		private var startBarBtnDTOList:Vector.<DesktopBtnDTO> = new Vector.<DesktopBtnDTO>();

		private var quickBarBtnDTOList:Vector.<DesktopBtnDTO> = new Vector.<DesktopBtnDTO>();

		private var stateBarBtnDTOList:Vector.<DesktopBtnDTO> = new Vector.<DesktopBtnDTO>();

		private var _toolBarDataUrl:String;

		private var _backImgUrl:String;

		private var _toolBarBackImgUrl:String;

		private var toolBarLayer:Sprite = new Sprite();

		private var toolBarBackLayer:Sprite = new Sprite();

		private var backLayer:Sprite = new Sprite();

		public function Desktop() {
			super();
		}

		override protected function init():void {
			trace("Desktop");

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			this.addChild(backLayer);
			this.addChild(toolBarBackLayer);
			this.addChild(toolBarLayer);

			imgRS.addResUrl(toolBarBackImgUrl);
			imgRS.addResUrl(backImgUrl);

			PromptMsgMng.instance().setMsg("Desktop");

			loadBarsXML();
		}

		private function loadBarsXML():void {
			var ul:URLLoader = new URLLoader(new URLRequest(dataBaseUrl + toolBarDataUrl));
			ul.addEventListener(Event.COMPLETE, handlerLoadToolbarXMLCmp);
		}

		private function handlerLoadToolbarXMLCmp(e:Event):void {
			var ul:URLLoader = e.currentTarget as URLLoader;
			var xml:XML = new XML(ul.data);
			var xd:XMLDom = new XMLDom(xml);
			var xmlNode:Node = xd.parse();
			var xmlData:XMLData = new XMLData(xmlNode);

			var bodyNode:Node = xmlData.bodyNode;
			if (xmlData.isCmp) {

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
				loadImgs();
			}
		}

		private function loadImgs():void {
			var rlm:ResLoadManager = new ResLoadManager();
			rlm.addResSet(toolBtnImgRS);
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

			trace(backImgUrl, backbmd);

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

	}
}
