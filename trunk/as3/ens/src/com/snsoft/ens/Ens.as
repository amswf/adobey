package com.snsoft.ens {
	import com.snsoft.util.ColorTransformUtil;
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.SpriteUtil;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;

	public class Ens extends Sprite {

		private var toolBtnsLayer:Sprite = new Sprite();

		private var mapLayer:Sprite = new Sprite();

		private var boothsLayer:Sprite = new Sprite();

		private var workLayer:Sprite = new Sprite();

		private var penLayer:Sprite = new Sprite();

		private var toolType:String;

		private var paneWidth:int = 30;

		private var paneHeight:int = 30;

		public function Ens() {
			super();
			this.addChild(workLayer);
			workLayer.addChild(mapLayer);
			workLayer.addChild(boothsLayer);
			this.addChild(toolBtnsLayer);
			this.addChild(penLayer);
			init();
		}

		private function init():void {
			initToolsBar();
			initPen();
			initMap();
		}

		private function initWorkLayer():void {

		}

		private function initMap():void {
			var enss:EnsSpace = new EnsSpace(10, 15, paneWidth, paneHeight);
			mapLayer.addChild(enss);
			enss.addEventListener(MouseEvent.MOUSE_DOWN, handlerMapMouseDown);
			enss.addEventListener(MouseEvent.MOUSE_UP, handlerMapMouseUp);
			enss.addEventListener(EnsSpace.EVENT_SELECT_PANE, handlerMapSelectPane);

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

		private function handlerMapSelectPane(e:Event):void {
			if (toolType == EnsToolType.SELECT) {
				trace("adsf");
				var enss:EnsSpace = e.currentTarget as EnsSpace;
				var pane:EnsPane = enss.currentPane;
				drawBooth(pane);
			}
		}

		private function drawBooth(ensPane:EnsPane):void {
			var enspdo:EnsPaneDO = new EnsPaneDO();
			enspdo.width = paneWidth;
			enspdo.height = paneHeight;
			var ensp:EnsPane = new EnsPane(enspdo);
			ensp.x = ensPane.x;
			ensp.y = ensPane.y;
			ColorTransformUtil.setColor(ensp, 0x000000, 1, 0);
			boothsLayer.addChild(ensp);
		}

		private function initPen():void {
			penLayer.mouseEnabled = false;
			penLayer.mouseChildren = false;
			Mouse.hide();
			refreshPen();
			stage.addEventListener(MouseEvent.MOUSE_MOVE, handlerMouseMove);
		}

		private function handlerMouseMove(e:Event):void {
			penLayer.x = mouseX;
			penLayer.y = mouseY;
		}

		private function initToolsBar():void {
			var etb:EnsToolsBar = new EnsToolsBar();
			etb.addBtn(new EnsToolBtnDO("ToolSelectDefaultSkin", "ToolSelectDownSkin", "ToolSelectOverSkin", true, EnsToolType.SELECT));
			etb.addBtn(new EnsToolBtnDO("ToolDragDefaultSkin", "ToolDragDownSkin", "ToolDragOverSkin", false, EnsToolType.DRAG));
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
