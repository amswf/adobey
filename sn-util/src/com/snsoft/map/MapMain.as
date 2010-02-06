package com.snsoft.map
{
	import com.snsoft.util.SkinsUtil;
	
	import fl.core.UIComponent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class MapMain extends UIComponent
	{
		//边框
		private var MAIN_FRAME_SKIN:String = "BaseBack";
		
		//工具栏
		private var bar:ToolsBar = new ToolsBar();
		
		//工作区
		private var ws:WorkSpace = null;
		
		private const SPACE:int = 10;
		
		public function MapMain()
		{
			super();
			
			var skin:MovieClip = SkinsUtil.createSkinByName(MAIN_FRAME_SKIN);
			skin.width = this.width;
			skin.height = this.height;
			this.addChild(skin);
			bar.x = SPACE;
			bar.y = SPACE;
			this.addChild(bar);
			var wsh:int = this.height - SPACE - SPACE;
			var wsw:int = this.width - SPACE - SPACE - SPACE - bar.width;
			ws = new WorkSpace(new Point(wsw,wsh));
			ws.x = bar.width + SPACE + SPACE;
			ws.y = SPACE;
			
			this.addChild(ws);
			bar.addEventListener(ToolsBar.TOOL_CLICK,handlerEventToolsClick);
		}
		
		/**
		 * 事件 工具选择 
		 * 
		 */		
		private function handlerEventToolsClick(e:Event):void{ 
			var toolEventType:String = bar.toolEventType;
			ws.toolEventType = toolEventType;
		}
	}
}