package com.snsoft.map
{
	import com.snsoft.map.util.MapUtil;
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.SpriteMouseAction;
	
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
		
		//地图块属性
		private var areaAttribute:AreaAttribute = new AreaAttribute();
		
		//工作区属性
		private var wsAttribute:WorkSpaceAttribute = new WorkSpaceAttribute();
		
		//工作区遮罩
		private var wsMask:MovieClip = null;
		
		//工作区边框
		private var wsFrame:MovieClip = null;
		
		//工作区
		private var ws:WorkSpace = null;
		
		private var spriteMouseAction:SpriteMouseAction = new SpriteMouseAction();
		
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
			var wsx:int = bar.width + SPACE + SPACE;
			var wsy:int = SPACE;
			 
			wsMask =  SkinsUtil.createSkinByName(MAIN_FRAME_SKIN);
			this.addChild(wsMask);
			wsMask.width = wsw;
			wsMask.height = wsh;
			wsMask.x = wsx;
			wsMask.y = wsy;
			
			ws = new WorkSpace(new Point(wsw,wsh));
			ws.mask = wsMask;
			ws.x = wsx;
			ws.y = wsy;
			spriteMouseAction.dragDisplayObject = ws;
			spriteMouseAction.addEventListener(SpriteMouseAction.DRAG_MOVE_EVENT,handlerWsDragMove);
			this.addChild(ws);
			
			wsFrame = SkinsUtil.createSkinByName(MAIN_FRAME_SKIN);
			wsFrame.width = wsw;
			wsFrame.height = wsh;
			wsFrame.x = wsx;
			wsFrame.y = wsy;
			wsFrame.mouseEnabled = false;
			wsFrame.mouseChildren = false;
			wsFrame.buttonMode = false;
			this.addChild(wsFrame);
			
			ws.addEventListener(WorkSpace.EVENT_MAP_AREA_CLICK,handlerMapAreaClick);
			bar.addEventListener(ToolsBar.TOOL_CLICK,handlerEventToolsClick);
			
			var atbw:Number = 180;
			var atbh:Number = 150;
			
			areaAttribute.x = this.width - atbw - SPACE;
			areaAttribute.y = SPACE;
			this.addChild(areaAttribute);
			areaAttribute.addEventListener(AreaAttribute.SUBMIT_EVENT,handlerAreaAttributeSubmit);
			areaAttribute.addEventListener(AreaAttribute.DELETE_EVENT,handlerAreaAttributeDelete);
			
			wsAttribute.x = this.width - atbw - SPACE;
			wsAttribute.y = SPACE + SPACE + atbh;
			this.addChild(wsAttribute);
			wsAttribute.addEventListener(WorkSpaceAttribute.SUBMIT_EVENT,handlerWsAttributeSubmit);
			wsAttribute.addEventListener(WorkSpaceAttribute.ZOOM_IN_EVENT,handlerWsAttributeZoomIn);
			wsAttribute.addEventListener(WorkSpaceAttribute.ZOOM_OUT_EVENT,handlerWsAttributeZoomOut);
		}
		
		private function handlerWsAttributeZoomIn(e:Event):void{
			ws.scalePoint = MapUtil.creatSaclePoint(ws.scalePoint,new Point(2,2));
			var wsFrameP:Point = MapUtil.getSpriteSize(wsFrame);
			ws.refreshScale(wsFrameP);
		}
		
		private function handlerWsAttributeZoomOut(e:Event):void{
			ws.scalePoint = MapUtil.creatInverseSaclePoint(ws.scalePoint,new Point(2,2));
			var wsFrameP:Point = MapUtil.getSpriteSize(wsFrame);
			ws.refreshScale(wsFrameP);
		}
		
		private function handlerWsAttributeSubmit(e:Event):void{
			ws.refreshMapBack(wsAttribute.imageUrl);
		}
		
		private function handlerAreaAttributeDelete(e:Event):void{
			var ma:MapArea = ws.currentClickMapArea;
			if(ma != null){
				ws.deleteMapArea(ma);
			}
		}
		
		private function handlerAreaAttributeSubmit(e:Event):void{
			var ma:MapArea = ws.currentClickMapArea;
			if(ma != null){
				if(areaAttribute.getareaName() != null){
					ma.mapAreaDO.areaName = areaAttribute.getareaName();
				}
				if(areaAttribute.getareaNameX() != null){
					ma.mapAreaDO.areaNamePlace.x = Number(areaAttribute.getareaNameX());
				}
				if(areaAttribute.getareaNameY() != null){
					ma.mapAreaDO.areaNamePlace.y = Number(areaAttribute.getareaNameY());
				}
				ma.refresh();
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
			spriteMouseAction.removeMouseDragEvents();
			var toolEventType:String = bar.toolEventType;
			ws.toolEventType = toolEventType;
			if(ws.toolEventType == ToolsBar.TOOL_TYPE_DRAG){
				spriteMouseAction.addMouseDragEvents();
			}
		}
		
		/**
		 *  
		 * @param e
		 * 
		 */		
		private function handlerWsDragMove(e:Event):void{
			var wsx:Number = this.ws.x;
			var wsy:Number = this.ws.y;
			
			var wsbx:Number = bar.width + SPACE + SPACE;
			var wsby:Number = SPACE;
			
			var wscx:Number = wsFrame.width - ws.width + wsbx;
			
			var wscy:Number = wsFrame.height - ws.height + wsby;
			
			if(wsx > wsbx || ws.width < wsFrame.width){
				wsx = wsbx;
			}
			else if(wsx < wscx){
				wsx = wscx;
			}
			if(wsy > wsby || ws.height < wsFrame.height){
				wsy = wsby;
			}
			else if(wsy < wscy){
				wsy = wscy;
			}
			this.ws.x = wsx;
			this.ws.y = wsy;
		}
	}
}