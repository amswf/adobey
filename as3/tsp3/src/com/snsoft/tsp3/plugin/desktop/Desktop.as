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

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.sampler.Sample;

	public class Desktop extends BPlugin {

		private var toolBtnImgRS:RSImages = new RSImages();

		private var startBarBtnDTOList:Vector.<DesktopBtnDTO> = new Vector.<DesktopBtnDTO>();

		private var quickBarBtnDTOList:Vector.<DesktopBtnDTO> = new Vector.<DesktopBtnDTO>();

		private var stateBarBtnDTOList:Vector.<DesktopBtnDTO> = new Vector.<DesktopBtnDTO>();

		private var _toolBarDataUrl:String;

		public function Desktop() {
			super();
		}

		override protected function init():void {
			trace("Desktop");

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

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

				var rlm:ResLoadManager = new ResLoadManager();
				rlm.addResSet(toolBtnImgRS);
				rlm.addEventListener(Event.COMPLETE, handlerLoadToolBtnImgCmp);
				rlm.load();
			}
		}

		private function handlerLoadToolBtnImgCmp(e:Event):void {
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

			this.addChild(startToolBar);
			this.addChild(quickToolBar);
			this.addChild(stateToolBar);

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

	}
}
