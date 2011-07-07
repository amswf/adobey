package com.snsoft.ens {
	import com.snsoft.util.AbstractBase;
	import com.snsoft.util.ColorTransformUtil;
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.SpriteUtil;
	import com.snsoft.util.XMLFormat;
	import com.snsoft.util.rlm.ResLoadManager;
	import com.snsoft.util.rlm.rs.RSTextFile;
	import com.snsoft.util.xmldom.Node;
	import com.snsoft.util.xmldom.NodeList;
	import com.snsoft.util.xmldom.XMLDom;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.ui.Mouse;

	public class Ens extends Sprite {

		private var toolBtnsLayer:Sprite = new Sprite();

		private var mapLayer:Sprite = new Sprite();

		private var boothsLayer:Sprite = new Sprite();

		private var workLayer:Sprite = new Sprite();

		private var boothArrLayer:Sprite = new Sprite();

		private var boothEditer:BoothEditer = new BoothEditer();

		private var menuLayer:Sprite = new Sprite();

		private var penLayer:Sprite = new Sprite();

		private var toolType:String;

		private var paneWidth:int = 30;

		private var paneHeight:int = 30;

		private var booths:Vector.<Sprite> = new Vector.<Sprite>();

		private var currentBooth:EnsBooth = null;

		private var ensSpace:EnsSpace;

		private var rsxml:RSTextFile;

		private var xmlUrl:String = "data.xml";

		private var esRow:int = 1;

		private var esCol:int = 1;

		public function Ens() {
			super();
			this.addChild(workLayer);
			workLayer.addChild(mapLayer);
			workLayer.addChild(boothsLayer);
			this.addChild(boothArrLayer);
			this.addChild(menuLayer);
			this.addChild(toolBtnsLayer);
			this.addChild(penLayer);

			loadXML();
		}

		private function loadXML():void {
			rsxml = new RSTextFile();
			rsxml.addResUrl(xmlUrl);

			var rsm:ResLoadManager = new ResLoadManager();
			rsm.addResSet(rsxml);
			rsm.addEventListener(Event.COMPLETE, handlerLoadXMLCmp);
			rsm.load();
		}

		private function handlerLoadXMLCmp(e:Event):void {
			var xmlStr:String = rsxml.getTextByUrl(xmlUrl);
			var xml:XML = new XML(xmlStr);
			var xdom:XMLDom = new XMLDom(xml);
			var node:Node = xdom.parse();
			var ensNode:Node = node.getNodeListFirstNode("ens");
			esRow = parseInt(ensNode.getAttributeByName("row"));
			esCol = parseInt(ensNode.getAttributeByName("col"));

			var boothList:NodeList = ensNode.getNodeList("booth");
			if (boothList != null) {
				for (var i:int = 0; i < boothList.length(); i++) {
					var boothNode:Node = boothList.getNode(i);
					var ensb:EnsBooth = new EnsBooth();
					ensb.id = boothNode.getAttributeByName("value");
					ensb.text = boothNode.getAttributeByName("name");
					setBoothUnSelectedFilters(ensb);
					boothsLayer.addChild(ensb);
					ensb.addEventListener(MouseEvent.CLICK, handlerBoothMouseClick);

					var paneList:NodeList = boothNode.getNodeList("pane");
					for (var j:int = 0; j < paneList.length(); j++) {
						var paneNode:Node = paneList.getNode(j);
						var pdo:EnsPaneDO = new EnsPaneDO();
						pdo.row = parseInt(paneNode.getAttributeByName("row")) - 1;
						pdo.col = parseInt(paneNode.getAttributeByName("col")) - 1;
						pdo.width = paneWidth;
						pdo.height = paneHeight;
						var ensp:EnsPane = new EnsPane(pdo);
						ensp.x = pdo.col * paneWidth;
						ensp.y = pdo.row * paneHeight;
						ColorTransformUtil.setColor(ensp, 0xdddddd, 1, 0);
						ensb.addChild(ensp);
						ensp.addEventListener(MouseEvent.CLICK, handlerRemoveBoothPane);
					}
				}
			}

			init();
		}

		private function init():void {
			initToolsBar();
			initPen();
			initWork();
			initMap();
			initBoothAttr();
			initMenuLayer();

		}

		private function initMenuLayer():void {
			var ensm:EnsMenu = new EnsMenu();
			menuLayer.addChild(ensm);
			ensm.x = 50;
			ensm.y = 10;
			ensm.addEventListener(EnsMenu.EVENT_STATE, handlerMenuState);
		}

		private function handlerMenuState(e:Event):void {
			var ensm:EnsMenu = e.currentTarget as EnsMenu;
			var state:String = ensm.state;
			switch (state) {
				case EnsMenu.STATE_OUT:  {
					outXML();
					break;
				}
				case EnsMenu.STATE_IN:  {
					break;
				}
				case EnsMenu.STATE_ADD_ROW:  {
					ensSpace.addRow(1);
					break;
				}
				case EnsMenu.STATE_DEL_ROW:  {
					ensSpace.addRow(-1);
					break;
				}
				case EnsMenu.STATE_ADD_COL:  {
					ensSpace.addCol(1);
					break;
				}
				case EnsMenu.STATE_DEL_COL:  {
					ensSpace.addCol(-1);
					break;
				}
			}
		}

		private function outXML():void {
			ensSpace.row;
			ensSpace.col;

			var asdf:String = "";
			var str:String = '<?xml version="1.0" encoding="utf-8"?>\n';
			str += '<xml>\n';
			str += '	<ens row="' + ensSpace.row + '" col="' + ensSpace.col + '" >\n';

			for (var i:int = 0; i < boothsLayer.numChildren; i++) {
				var booth:EnsBooth = boothsLayer.getChildAt(i) as EnsBooth;
				if (booth != null) {
					str += '		<booth name="' + booth.text + '" value="' + booth.id + '" text="' + "" + '" >\n';
					for (var j:int = 0; j < booth.numChildren; j++) {
						var pane:EnsPane = booth.getChildAt(j) as EnsPane;
						pane.ensPaneDO.row
						if (pane != null) {
							str += '			<pane row="' + (pane.ensPaneDO.row + 1) + '" col="' + (pane.ensPaneDO.col + 1) + '">\n';
							str += '			</pane>\n';
						}
					}
					str += '		</booth>\n';
				}
			}

			str += '	</ens>\n';
			str += '</xml>\n';

			trace(str);
		}

		private function initWork():void {
			workLayer.x = 50;
			workLayer.y = 50;
		}

		private function initBoothAttr():void {
			boothEditer = new BoothEditer();
			boothEditer.x = stage.stageWidth - 194;
			boothEditer.y = 10;
			boothArrLayer.addChild(boothEditer);
			boothEditer.addEventListener(BoothEditer.EVENT_CMP, handlerBoothCmpClick);
			boothEditer.addEventListener(BoothEditer.EVENT_DEL, handlerBoothDelClick);
		}

		private function handlerBoothCmpClick(e:Event):void {
			var be:BoothEditer = e.currentTarget as BoothEditer;
			if (currentBooth != null) {
				currentBooth.id = be.id;
				currentBooth.text = be.text;
			}
			clearCurrentBooth();
		}

		private function clearCurrentBooth():void {
			if (currentBooth != null) {
				setBoothUnSelectedFilters(currentBooth);
				currentBooth = null;
			}
		}

		private function handlerBoothDelClick(e:Event):void {
			if (currentBooth != null) {
				boothsLayer.removeChild(currentBooth);
				currentBooth = null;
			}
		}

		private function initMap():void {
			ensSpace = new EnsSpace(esRow, esCol, paneWidth, paneHeight);
			mapLayer.addChild(ensSpace);
			workLayer.addEventListener(MouseEvent.MOUSE_DOWN, handlerMapMouseDown);
			workLayer.addEventListener(MouseEvent.MOUSE_UP, handlerMapMouseUp);
			ensSpace.addEventListener(EnsSpace.EVENT_SELECT_PANE, handlerBoothPane);

		}

		private function handlerMapMouseDown(e:Event):void {
			if (toolType == EnsToolType.DRAG) {
				workLayer.startDrag();
			}
		}

		private function handlerMapMouseUp(e:Event):void {
			if (toolType == EnsToolType.DRAG) {
				workLayer.stopDrag();
			}
		}

		private function handlerBoothPane(e:Event):void {
			if (toolType == EnsToolType.BOOTH) {
				var enss:EnsSpace = e.currentTarget as EnsSpace;
				var pane:EnsPane = enss.currentPane;
				drawBooth(pane);
			}
			else if (toolType == EnsToolType.SELECT) {
				clearCurrentBooth();
			}
		}

		private function drawBooth(ensPane:EnsPane):void {
			if (currentBooth == null) {
				currentBooth = new EnsBooth();
				boothsLayer.addChild(currentBooth);
				booths.push(currentBooth);
				setBoothSelectedFilters(currentBooth);
				currentBooth.addEventListener(MouseEvent.CLICK, handlerBoothMouseClick);
				boothEditer.id = "";
				boothEditer.text = "";
			}

			var enspdo:EnsPaneDO = new EnsPaneDO();
			enspdo.width = paneWidth;
			enspdo.height = paneHeight;
			enspdo.row = ensPane.ensPaneDO.row;
			enspdo.col = ensPane.ensPaneDO.col;
			var ensp:EnsPane = new EnsPane(enspdo);
			ensp.x = ensPane.x;
			ensp.y = ensPane.y;
			ColorTransformUtil.setColor(ensp, 0xdddddd, 1, 0);
			currentBooth.addChild(ensp);
			ensp.addEventListener(MouseEvent.CLICK, handlerRemoveBoothPane);
		}

		private function handlerBoothMouseClick(e:Event):void {
			var booth:EnsBooth = e.currentTarget as EnsBooth;
			if (toolType == EnsToolType.SELECT) {
				if (booth != currentBooth) {
					if (currentBooth != null) {
						setBoothUnSelectedFilters(currentBooth);
					}
					currentBooth = booth;
					setBoothSelectedFilters(currentBooth);
					boothEditer.id = currentBooth.id;
					boothEditer.text = currentBooth.text;
					boothsLayer.setChildIndex(currentBooth, boothsLayer.numChildren - 1);
				}
			}
		}

		private function setBoothSelectedFilters(booth:Sprite):void {
			var array:Array = new Array();
			array.push(new DropShadowFilter(0, 0, 0xffffff, 3, 2, 2, 255));
			array.push(new DropShadowFilter(0, 0, 0x000000, 3, 4, 4, 1));
			booth.filters = array;
		}

		private function setBoothUnSelectedFilters(booth:Sprite):void {
			var array:Array = new Array();
			array.push(new DropShadowFilter(0, 0, 0x999999, 3, 2, 2, 255, 1, true));
			booth.filters = array;
		}

		private function handlerRemoveBoothPane(e:Event):void {
			if (toolType == EnsToolType.BOOTH) {
				try {
					var ensp:EnsPane = e.currentTarget as EnsPane;
					currentBooth.removeChild(ensp);
					ensp.removeEventListener(MouseEvent.CLICK, handlerRemoveBoothPane);
				}
				catch (e:Error) {

				}
			}
		}

		private function initPen():void {
			penLayer.mouseEnabled = false;
			penLayer.mouseChildren = false;
			refreshPen();
			stage.addEventListener(MouseEvent.MOUSE_MOVE, handlerMouseMove);
		}

		private function handlerMouseMove(e:Event):void {
			Mouse.hide();
			penLayer.x = mouseX;
			penLayer.y = mouseY;
		}

		private function initToolsBar():void {
			var etb:EnsToolsBar = new EnsToolsBar();
			etb.addBtn(new EnsToolBtnDO("ToolSelectDefaultSkin", "ToolSelectDownSkin", "ToolSelectOverSkin", true, EnsToolType.SELECT));
			etb.addBtn(new EnsToolBtnDO("ToolDragDefaultSkin", "ToolDragDownSkin", "ToolDragOverSkin", false, EnsToolType.DRAG));
			etb.addBtn(new EnsToolBtnDO("ToolLineDefaultSkin", "ToolLineDownSkin", "ToolLineOverSkin", false, EnsToolType.BOOTH));
			etb.x = 10;
			etb.y = 10;
			toolBtnsLayer.addChild(etb);
			etb.addEventListener(EnsToolsBar.EVENT_CHANGE_TYPE, handlerMouseDown);
			toolType = etb.type;
		}

		private function handlerMouseDown(e:Event):void {
			var etb:EnsToolsBar = e.currentTarget as EnsToolsBar;
			toolType = etb.type;
			refreshPen();
		}

		private function refreshPen():void {
			SpriteUtil.deleteAllChild(penLayer);
			var pen:MovieClip = SkinsUtil.createSkinByName(toolType);
			penLayer.addChild(pen);
		}
	}
}
