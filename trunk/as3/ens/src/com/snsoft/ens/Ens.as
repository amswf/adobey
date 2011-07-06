package com.snsoft.ens {
	import com.snsoft.util.AbstractBase;
	import com.snsoft.util.ColorTransformUtil;
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.SpriteUtil;

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

		private var menuLayer:Sprite = new Sprite();

		private var penLayer:Sprite = new Sprite();

		private var toolType:String;

		private var paneWidth:int = 30;

		private var paneHeight:int = 30;

		private var booths:Vector.<Sprite> = new Vector.<Sprite>();

		private var currentBooth:Sprite = null;

		private var ensSpace:EnsSpace;

		public function Ens() {
			super();
			this.addChild(workLayer);
			workLayer.addChild(mapLayer);
			workLayer.addChild(boothsLayer);
			this.addChild(boothArrLayer);
			this.addChild(menuLayer);
			this.addChild(toolBtnsLayer);
			this.addChild(penLayer);
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

		private function initWork():void {
			workLayer.x = 50;
			workLayer.y = 50;
		}

		private function initBoothAttr():void {
			var be:BoothEditer = new BoothEditer();
			be.x = stage.stageWidth - 194;
			be.y = 10;
			boothArrLayer.addChild(be);
			be.addEventListener(BoothEditer.EVENT_CMP, handlerBoothCmpClick);
			be.addEventListener(BoothEditer.EVENT_DEL, handlerBoothDelClick);
		}

		private function handlerBoothCmpClick(e:Event):void {
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
			ensSpace = new EnsSpace(10, 15, paneWidth, paneHeight);
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
				currentBooth = new Sprite();
				boothsLayer.addChild(currentBooth);
				booths.push(currentBooth);
				setBoothSelectedFilters(currentBooth);
				currentBooth.addEventListener(MouseEvent.CLICK, handlerBoothMouseClick);
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
			var booth:Sprite = e.currentTarget as Sprite;
			if (toolType == EnsToolType.SELECT) {
				if (booth != currentBooth) {
					if (currentBooth != null) {
						setBoothUnSelectedFilters(currentBooth);
					}
					currentBooth = booth;
					setBoothSelectedFilters(currentBooth);
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
