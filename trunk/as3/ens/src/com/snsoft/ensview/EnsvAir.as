package com.snsoft.ensview {
	import com.snsoft.util.SpriteUtil;

	import flash.display.NativeWindow;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.system.Capabilities;

	public class EnsvAir extends Sprite {

		private var win:NativeWindow;

		private var startLayer:Sprite = new Sprite();

		private var ensLayer:Sprite = new Sprite();

		private var backLayer:Sprite = new Sprite();

		private var mainback:Sprite;

		private var winBoader:int = 10;

		private var mainSize:Point = new Point(550, 400);

		public function EnsvAir() {
			super();
			init();
		}

		private function init():void {
			win = stage.nativeWindow;
			win.title = "ensv 1.0";
			win.x = (Capabilities.screenResolutionX - stage.stageWidth) / 2;
			win.y = (Capabilities.screenResolutionY - stage.stageHeight) / 2;

			this.addChild(backLayer);
			this.addChild(startLayer);
			this.addChild(ensLayer);

			stage.addEventListener(Event.FULLSCREEN, handlerFullScreen);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			initBack();
			initStart();
		}

		private function handlerFullScreen(e:Event):void {
			if (stage.displayState == StageDisplayState.FULL_SCREEN) {
				ensLayer.visible = true;
				mainback.visible = true;
				startLayer.visible = false;
				mainback.width = stage.stageWidth;
				mainback.height = stage.stageHeight;
				initEns();
			}
			else {
				mainback.visible = false;
				ensLayer.visible = false;
				startLayer.visible = true;
			}
		}

		private function initBack():void {
			mainback = new Sprite();
			mainback.visible = false;
			mainback.graphics.beginFill(0xffffff, 1);
			mainback.graphics.drawRect(0, 0, mainSize.x, mainSize.y);
			mainback.graphics.endFill();
			backLayer.addChild(mainback);
		}

		private function initStart():void {
			var ensvs:EnsvStart = new EnsvStart();
			ensvs.x = 10;
			ensvs.y = 10;
			startLayer.addChild(ensvs);
			ensvs.addEventListener(EnsvStart.EVENT_START, handlerStart);
		}

		private function handlerStart(e:Event):void {
			stage.displayState = StageDisplayState.FULL_SCREEN;
		}

		private function initEns():void {
			SpriteUtil.deleteAllChild(ensLayer);
			var ensv:Ensv = new Ensv(stage.stageWidth, stage.stageHeight);
			ensLayer.addChild(ensv);
		}
	}
}
