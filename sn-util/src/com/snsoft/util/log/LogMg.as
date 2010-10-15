package com.snsoft.util.log{
	import fl.controls.TextArea;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	/**
	 * 在flash运行时，控制台显示 
	 * @author Administrator
	 * 
	 */	
	public class LogMg{
		
		private static var _logMsg:String = "";
		
		private static var logPanel:LogPanel = new LogPanel();
		
		private static var stage:Stage;
		
		/**
		 * 
		 * 
		 */		
		public function LogMg()
		{
		}
		
		/**
		 * 初始化调用 
		 * @param stage
		 * 
		 */		
		public static function init(stg:Stage):void{
			stage = stg;
			logPanel.width = 400;
			logPanel.height = 200;
			keepLogPanelInStage(stage);
			
			var cmi:ContextMenuItem = new ContextMenuItem("LogMg控制台",true,true,true);
			cmi.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,handlerMenuSelect);
			
			var mainTimeLine:Sprite = stage.getChildAt(0) as Sprite;
			
			if(mainTimeLine.contextMenu == null){
				mainTimeLine.contextMenu = new ContextMenu();
			}
			var cm:ContextMenu = ContextMenu(mainTimeLine.contextMenu);
			
			
			if(cm.customItems == null){
				cm.customItems = new Array();
			}
			var customItems:Array = cm.customItems;
			customItems.push(cmi);
		}
		
		private static function handlerMenuSelect(e:Event):void{
			logPanel.visible = true;
			logPanel.x = 10;
			logPanel.y = 10;
			logPanel.refreshLogMsg();
		}
		
		/**
		 * 输出日志 
		 * @param value
		 * 
		 */		
		public static function traceLog(...value):void{
			if(stage != null){
				addTraceMsg(value);
				keepLogPanelInStage(stage);
				logPanel.refreshLogMsg();
			}
			else{
				trace("没有初始化LogMg  需要调用一下LogMg.init();");
			}
		}
		
		private static function keepLogPanelInStage(stage:Stage):void{
			var hasLp:Boolean = false;
			var n:int = stage.numChildren;
			for(var i:int = 0 ;i< n;i++){
				var lp:LogPanel = stage.getChildAt(i) as LogPanel;
				if(lp != null){
					hasLp = true;
				}
			}
			if(!hasLp){
				stage.addChild(logPanel);
			}
		}
		
		/**
		 * 把日志信息追加到 日志信息字符串里
		 * @param msgArray
		 * 
		 */		
		private static function addTraceMsg(msgArray:Array):void{
			if(msgArray != null){
				for(var i:int = 0;i < msgArray.length;i ++){
					var v:String = String(msgArray[i]);
					_logMsg += v;
					
					if(i < msgArray.length - 1){
						_logMsg += " ";
					}
				}
			}
			_logMsg +="\r";
			
			if(_logMsg.length > 2000){
				_logMsg = _logMsg.substring(_logMsg.length-1-200,_logMsg.length-1);
			}
		}
		
		public static function get logMsg():String
		{
			return _logMsg;
		}
		
		/**
		 * 记录日志信息 
		 */
		public static function set logMsg(value:String):void
		{
			_logMsg = value;
		}
		
		
	}
}