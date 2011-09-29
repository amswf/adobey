package com.snsoft.tsp3.plugin.desktop {
	import com.snsoft.tsp3.PromptMsgMng;
	import com.snsoft.tsp3.plugin.BPlugin;
	import com.snsoft.tsp3.plugin.desktop.dto.DesktopBtnDTO;
	import com.snsoft.util.rlm.ResLoadManager;
	import com.snsoft.util.rlm.rs.RSImages;
	import com.snsoft.util.xmldom.Node;
	import com.snsoft.util.xmldom.NodeList;
	import com.snsoft.util.xmldom.XMLDom;

	import flash.display.BitmapData;
	import flash.display.Sprite;
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

		public function Desktop() {
			super();
		}

		override protected function init():void {
			trace("Desktop");

			PromptMsgMng.instance().setMsg("b");

			loadBarsXML();
		}

		private function loadBarsXML():void {
			var ul:URLLoader = new URLLoader(new URLRequest("toolbar.xml"));
			ul.addEventListener(Event.COMPLETE, handlerLoadToolbarXMLCmp);
		}

		private function handlerLoadToolbarXMLCmp(e:Event):void {
			var ul:URLLoader = e.currentTarget as URLLoader;
			var xml:XML = new XML(ul.data);
			var xd:XMLDom = new XMLDom(xml);
			var xmlNode:Node = xd.parse();

			var startNode:Node = xmlNode.getNodeListFirstNode("start");
			var startBtnNode:Node = startNode.getNodeListFirstNode("btn");
			var startDTO:DesktopBtnDTO = creatToolBarBtnDTO(startBtnNode);
			startBarBtnDTOList.push(startDTO);
			toolBtnImgRS.addResUrl(startDTO.imgUrl);

			var quickNode:Node = xmlNode.getNodeListFirstNode("quick");
			var quickList:NodeList = quickNode.getNodeList("btn");
			for (var i:int = 0; i < quickList.length(); i++) {
				var quickBtnNode:Node = quickList.getNode(i);
				var quickDTO:DesktopBtnDTO = creatToolBarBtnDTO(quickBtnNode);
				quickBarBtnDTOList.push(quickDTO);
				toolBtnImgRS.addResUrl(quickDTO.imgUrl);
			}

			var stateNode:Node = xmlNode.getNodeListFirstNode("state");
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

		private function handlerLoadToolBtnImgCmp(e:Event):void {
			dtoListSetImg(startBarBtnDTOList, toolBtnImgRS);
			dtoListSetImg(quickBarBtnDTOList, toolBtnImgRS);
			dtoListSetImg(stateBarBtnDTOList, toolBtnImgRS);

			var tb:int = 0;
			var startToolBar:BtnBar = new BtnBar(startBarBtnDTOList);
			tb = stage.fullScreenHeight - startToolBar.height;
			startToolBar.y = tb;
			var quickToolBar:BtnBar = new BtnBar(quickBarBtnDTOList);
			quickToolBar.y = tb;
			quickToolBar.x = startToolBar.width;
			var stateToolBar:BtnBar = new BtnBar(stateBarBtnDTOList);
			stateToolBar.y = tb;
			stateToolBar.x = stage.fullScreenWidth - stateToolBar.width;

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
	}
}
