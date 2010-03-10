package com.snsoft.map
{
	import com.snsoft.map.file.MapDataFileIO;
	import com.snsoft.map.util.HashArray;
	import com.snsoft.map.util.MapUtil;
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.SpriteMouseAction;
	
	import fl.core.UIComponent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * HashArray需要优化算法，需要用Vector 重写。
	 * MapComponent需要按照 UIComponent的configUI() draw() getStyle() 等重写。 
	 * @author Administrator
	 * 
	 */	
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
		
		//主属性
		private var mmAttribute:MapMainAttribute = new MapMainAttribute();
		
		//工作区遮罩
		private var wsMask:MovieClip = null;
		
		//工作区边框
		private var wsFrame:MovieClip = null;
		
		//工作区
		private var ws:WorkSpace = null;
		
		//综合事件对象[拖动]
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
			bar.addEventListener(ToolsBar.TOOL_CLICK,handlerEventToolsClick);
			
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
			ws.addEventListener(WorkSpace.EVENT_MAP_AREA_ADD,handlerMapAreaChange);
			ws.addEventListener(WorkSpace.EVENT_MAP_AREA_DELETE,handlerMapAreaChange);
			ws.addEventListener(WorkSpace.EVENT_MAP_AREA_UPDATE,handlerMapAreaChange);
			
			var atbw:Number = 180;
			var atbh:Number = 100;
			
			areaAttribute.x = this.width - atbw - SPACE;
			areaAttribute.y = SPACE;
			this.addChild(areaAttribute);
			areaAttribute.addEventListener(AreaAttribute.SUBMIT_EVENT,handlerAreaAttributeSubmit);
			areaAttribute.addEventListener(AreaAttribute.DELETE_EVENT,handlerAreaAttributeDelete);
			
			wsAttribute.x = this.width - atbw - SPACE;
			wsAttribute.y = areaAttribute.y + atbh + SPACE;
			wsAttribute.addEventListener(WorkSpaceAttribute.SUBMIT_EVENT,handlerWsAttributeSubmit);
			wsAttribute.addEventListener(WorkSpaceAttribute.ZOOM_IN_EVENT,handlerWsAttributeZoomIn);
			wsAttribute.addEventListener(WorkSpaceAttribute.ZOOM_OUT_EVENT,handlerWsAttributeZoomOut);
			wsAttribute.addEventListener(WorkSpaceAttribute.TREE_CLICK,handlerWsAttributeTreeClick);
			this.addChild(wsAttribute);
			
			var wsbw:Number = 180;
			var wsbh:Number = 290;
			
			mmAttribute.x = this.width - atbw - SPACE;
			mmAttribute.y = wsAttribute.y + wsbh + SPACE;
			mmAttribute.addEventListener(MapMainAttribute.SAVE_EVENT,handlerWsAttributeSave);
			mmAttribute.addEventListener(MapMainAttribute.OPEN_EVENT,handlerWsAttributeOpen);
			this.addChild(mmAttribute);
		}
		
		private function handlerWsAttributeTreeClick(e:Event):void{
			var name:String = wsAttribute.currentTreeNodeBtnName;
			ws.setMapAreaIndex(name);
		}
		
		private function handlerWsAttributeZoomIn(e:Event):void{
			ws.scalePoint = MapUtil.creatSaclePoint(ws.scalePoint,new Point(2,2));
			ws.refreshScale(this.wsFrame);
		}
		
		private function handlerWsAttributeZoomOut(e:Event):void{
			ws.scalePoint = MapUtil.creatInverseSaclePoint(ws.scalePoint,new Point(2,2));
			ws.refreshScale(this.wsFrame);
		}
		
		private function handlerWsAttributeSubmit(e:Event):void{
			ws.refreshMapBack(wsAttribute.imageUrl);
		}
		
		private function handlerWsAttributeSave(e:Event):void{
			var dir:String = mmAttribute.mapFileMainDirectory;
			if(dir != null){
				ws.manager.mapAreaDOAry;
				MapDataFileIO.save(ws,dir+"/ws.xml");
			}
			else {
				mmAttribute.selectSaveDirectory();
			}
		}
		
		private function handlerWsAttributeOpen(e:Event):void{
			var dir:String = mmAttribute.mapFileMainDirectory;
			if(dir != null){
				MapDataFileIO.open(dir+"/ws.xml");
			}
		}
		
		private function handlerAreaAttributeDelete(e:Event):void{
			var ma:MapArea = ws.currentClickMapArea;
			if(ma != null){
				ws.deleteMapArea(ma);
			}
		}
		
		private function handlerAreaAttributeSubmit(e:Event):void{
			this.ws.updateMapArea(this.areaAttribute);
		}
		
		private function handlerMapAreaClick(e:Event):void{
			var mado:MapAreaDO = ws.currentClickMapArea.mapAreaDO;
			
			var an:String = "";
			var anx:String = "0";
			var any:String = "0";
			if(mado.areaName != null){
				an = mado.areaName;
			}
			areaAttribute.setareaName(an);
			areaAttribute.setareaNameX(String(mado.areaNamePlace.x));
			areaAttribute.setareaNameY(String(mado.areaNamePlace.y));
		}
		
		private function handlerMapAreaChange(e:Event):void{
			var maha:HashArray = this.ws.manager.mapAreaDOAry;
			this.wsAttribute.refreshMapAreaListBtn(maha);
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
				spriteMouseAction.addMouseDragEvents(this.ws,this.wsFrame);
			}
		}
		
		/**
		 *  
		 * @param e
		 * 
		 */		
		private function handlerWsDragMove(e:Event):void{
			
		}
	}
}