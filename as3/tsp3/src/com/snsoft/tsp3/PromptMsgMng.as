package com.snsoft.tsp3 {
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;

	/**
	 * 提示信息管理类
	 * @author Administrator
	 *
	 */
	public class PromptMsgMng {

		private static var parent:DisplayObjectContainer = null;

		private static var pmsg:PromptMsg = new PromptMsg();

		private static var pmsgMask:Sprite = new Sprite();

		private static var isInit:Boolean = false;

		public function PromptMsgMng() {
			trace("PromptMsgMng 不能new 创建，属于静态类！");
		}

		/**
		 * 初始化方法
		 * @param parent
		 *
		 */
		public static function init(parent:DisplayObjectContainer):void {

			if (!isInit) {
				PromptMsgMng.parent = parent;
				isInit = true;
				pmsgMask = new Sprite();
				pmsgMask.visible = false;
				pmsgMask.graphics.beginFill(0xffffff, 0.2);
				pmsgMask.graphics.drawRect(0, 0, 100, 100);
				pmsgMask.graphics.endFill();
				parent.addChild(pmsgMask);

				pmsg.visible = false;
				parent.addChild(pmsg);
				pmsg.addEventListener(Event.ENTER_FRAME, handlerEnterFrame);
				pmsg.addEventListener(PromptMsg.EVENT_BTN_CLICK, handlerBtnClick);
			}
		}

		public static function setMsg(msg:String):void {
			if (isInit) {
				pmsg.setMsg(msg);
				pmsg.visible = true;
				pmsgMask.visible = true;
			}
			else {
				trace("PromptMsgMng 需要调用init()初始化！");
			}
		}

		private static function handlerBtnClick(e:Event):void {
			pmsgMask.visible = false;
			pmsg.visible = false;
		}

		private static function handlerEnterFrame(e:Event):void {
			pmsg.removeEventListener(Event.ENTER_FRAME, handlerEnterFrame);
			var stage:Stage = parent.stage;

			pmsg.x = (stage.stageWidth - pmsg.width) / 2;
			pmsg.y = (stage.stageHeight - pmsg.height) / 2;
			pmsgMask.width = stage.stageWidth;
			pmsgMask.height = stage.stageHeight;
		}
	}
}
