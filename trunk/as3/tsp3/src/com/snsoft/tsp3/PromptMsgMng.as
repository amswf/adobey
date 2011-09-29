package com.snsoft.tsp3 {
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;

	/**
	 * 提示信息管理类  单例类 请使用 instance初始化
	 * @author Administrator
	 *
	 */
	public class PromptMsgMng {

		private var parent:DisplayObjectContainer = null;

		private static var pmsg:PromptMsg = new PromptMsg();

		private var pmsgMask:Sprite = new Sprite();

		private var isInit:Boolean = false;

		private var lock:Boolean = false;

		private static var pmm:PromptMsgMng = new PromptMsgMng();

		public function PromptMsgMng() {
			if (lock) {
				throw new Error("PromptMsgMng can not be new");
			}
			lock = true;
		}

		public static function instance():PromptMsgMng {
			return pmm;
		}

		/**
		 * 初始化方法
		 * @param parent
		 *
		 */
		public function init(parent:Stage):void {

			if (!isInit) {
				this.parent = parent;
				this.isInit = true;
				pmsgMask = new Sprite();

				pmsgMask.graphics.beginFill(0xffffff, 0.2);
				pmsgMask.graphics.drawRect(0, 0, 100, 100);
				pmsgMask.graphics.endFill();
				pmsgMask.visible = false;
				parent.addChild(pmsgMask);

				pmsg.visible = false;
				parent.addChild(pmsg);
				pmsg.addEventListener(Event.ENTER_FRAME, handlerEnterFrame);
				parent.stage.addEventListener(Event.RESIZE, handlerEnterFrame);
				pmsg.addEventListener(PromptMsg.EVENT_BTN_CLICK, handlerBtnClick);
			}
		}

		public function setMsg(msg:String):void {
			if (isInit) {
				pmsg.setMsg(msg);
				pmsg.visible = true;
				pmsgMask.visible = true;
			}
			else {
				trace("PromptMsgMng 需要调用init()初始化！");
			}
		}

		private function handlerBtnClick(e:Event):void {
			pmsgMask.visible = false;
			pmsg.visible = false;
		}

		private function handlerEnterFrame(e:Event):void {
			pmsg.removeEventListener(Event.ENTER_FRAME, handlerEnterFrame);
			var stage:Stage = parent.stage;
			pmsg.x = (stage.stageWidth - pmsg.width) / 2;
			pmsg.y = (stage.stageHeight - pmsg.height) / 2;
			pmsgMask.width = stage.stageWidth;
			pmsgMask.height = stage.stageHeight;
		}
	}
}
