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
		
		private var areaAttribute:AreaAttribute = new AreaAttribute();
		
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
			var wsw:int = this.width - SPACE - SPACE - SPACE - bar.width - areaAttribute.width;
			ws = new WorkSpace(new Point(wsw,wsh));
			ws.x = bar.width + SPACE + SPACE;
			ws.y = SPACE;
			this.addChild(ws);
			
			ws.addEventListener(WorkSpace.EVENT_MAP_AREA_CLICK,handlerMapAreaClick);
			bar.addEventListener(ToolsBar.TOOL_CLICK,handlerEventToolsClick);
			
			areaAttribute.x = this.width - areaAttribute.width;
			areaAttribute.y = SPACE;
			this.addChild(areaAttribute);
			areaAttribute.addEventListener(AreaAttribute.SUBMIT_EVENT,handlerSubmit);
		}
		
		private function handlerSubmit(e:Event):void{
			var mado:MapArea = ws.currentClickMapArea;
			if(areaAttribute.getareaName() != null){
				mado.mapAreaDO.areaName = areaAttribute.getareaName();
			}
			if(areaAttribute.getareaNameX() != null){
				mado.mapAreaDO.areaNamePlace.x = Number(areaAttribute.getareaNameX());
			}
			if(areaAttribute.getareaNameY() != null){
				mado.mapAreaDO.areaNamePlace.y = Number(areaAttribute.getareaNameY());
			}
		}
		
		private function handlerMapAreaClick(e:Event):void{
			var mado:MapAreaDO = ws.currentClickMapArea.mapAreaDO;
			
			var an:String = "<名称>";
			var anx:String = "0";
			var any:String = "0";
			if(mado.areaName != null){
				an = mado.areaName;
			}
			areaAttribute.setareaName(an);
			areaAttribute.setareaNameX(String(mado.areaNamePlace.x));
			areaAttribute.setareaNameY(String(mado.areaNamePlace.y));
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