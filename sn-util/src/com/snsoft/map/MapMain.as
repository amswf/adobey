package com.snsoft.map
{
	import com.snsoft.map.file.MapDataFileManager;
	import com.snsoft.map.util.HashVector;
	import com.snsoft.map.util.MapUtil;
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.SpriteMouseAction;
	
	import fl.core.UIComponent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * HashArray需要优化算法，需要用Vector 重写。
	 * MapComponent需要按照 UIComponent的configUI() draw() getStyle() 等重写。 
	 * MapMain初始 化各子对象时，需要单个定义化。备以后扩展用。
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
		
		//工作区高
		private var wsh:int = 0;
		
		//工作区宽
		private var wsw:int = 0;
		
		//工作区x坐标
		private var wsx:int = 0;
		
		//工作区y坐标
		private var wsy:int = 0;
		
		//上一层工作区名称
		private var parentWsName:String = null;
		
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
			
			wsh = this.height - SPACE - SPACE;
			wsw = this.width - SPACE - SPACE - SPACE - bar.width - areaAttribute.width;
			wsx = bar.width + SPACE + SPACE;
			wsy = SPACE;
			
			wsMask =  SkinsUtil.createSkinByName(MAIN_FRAME_SKIN);
			this.addChild(wsMask);
			wsMask.width = wsw;
			wsMask.height = wsh;
			wsMask.x = wsx;
			wsMask.y = wsy;
			var mdfm:MapDataFileManager = new MapDataFileManager();
			this.parentWsName = MapDataFileManager.MAP_FILE_BASE_NAME;
			var wsName:String = mdfm.createChildWorkSpaceName(this.parentWsName,1);
			this.initWorkSpace(wsMask,new Point(wsx,wsy),new Point(wsw,wsh),wsName);
			
			wsFrame = SkinsUtil.createSkinByName(MAIN_FRAME_SKIN);
			wsFrame.width = wsw;
			wsFrame.height = wsh;
			wsFrame.x = wsx;
			wsFrame.y = wsy;
			wsFrame.mouseEnabled = false;
			wsFrame.mouseChildren = false;
			wsFrame.buttonMode = false;
			this.addChild(wsFrame);
			
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
		
		/**
		 *  
		 * @param msk
		 * 
		 */		
		private function initWorkSpace(msk:Sprite,place:Point,size:Point,wsName:String):void{
			
			var ws:WorkSpace = new WorkSpace(size);
			ws.mask = msk;
			ws.x = place.x;
			ws.y = place.y;
			ws.wsName = wsName;
			if(this.ws != null){
				this.removeChild(this.ws);
			}
			this.ws = ws;
			this.addChild(this.ws);
			
			this.wsAttribute.refreshMapAreaListBtn(null);
			
			ws.addEventListener(WorkSpace.EVENT_MAP_AREA_CLICK,handlerMapAreaClick);
			ws.addEventListener(WorkSpace.EVENT_MAP_AREA_DOUBLE_CLICK,handlerMapAreaDoubleClick);
			ws.addEventListener(WorkSpace.EVENT_MAP_AREA_ADD,handlerMapAreaChange);
			ws.addEventListener(WorkSpace.EVENT_MAP_AREA_DELETE,handlerMapAreaChange);
			ws.addEventListener(WorkSpace.EVENT_MAP_AREA_UPDATE,handlerMapAreaChange);
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerWsAttributeTreeClick(e:Event):void{
			var name:String = wsAttribute.currentTreeNodeBtnName;
			ws.setcurrentClickMapArea(name);
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerWsAttributeZoomIn(e:Event):void{
			ws.scalePoint = MapUtil.creatSaclePoint(ws.scalePoint,new Point(2,2));
			ws.refreshScale(this.wsFrame);
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerWsAttributeZoomOut(e:Event):void{
			ws.scalePoint = MapUtil.creatInverseSaclePoint(ws.scalePoint,new Point(2,2));
			ws.refreshScale(this.wsFrame);
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerWsAttributeSubmit(e:Event):void{
			ws.refreshMapBack(wsAttribute.imageUrl);
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerWsAttributeSave(e:Event):void{
			var dir:String = mmAttribute.mapFileMainDirectory;
			if(dir != null){
				//设置共享根路径
				var mdfm:MapDataFileManager = new MapDataFileManager();
				mdfm.mainDirectory = dir;
				
				//保存
				ws.saveWorkSpace();
			}
			else {
				mmAttribute.selectSaveDirectory();
			}
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerWsAttributeOpen(e:Event):void{
			var dir:String = mmAttribute.mapFileMainDirectory;
			if(dir != null){
				var mdfio:MapDataFileManager = new MapDataFileManager();
				mdfio.addEventListener(Event.COMPLETE,handlerLoadXMLComplete);
				var fullPath:String = mdfio.creatFileFullPath(dir);
				if(mdfio.fileIsExists(fullPath)){
					mdfio.open(fullPath);
				}
			}
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerLoadXMLComplete(e:Event):void{
			var mdfio:MapDataFileManager = e.currentTarget as MapDataFileManager;
			if(mdfio != null && mdfio.workSpaceDO != null){
				
				var wsh:int = this.height - SPACE - SPACE;
				var wsw:int = this.width - SPACE - SPACE - SPACE - bar.width - areaAttribute.width;
				var wsx:int = bar.width + SPACE + SPACE;
				var wsy:int = SPACE;
				
				var mdfm:MapDataFileManager = new MapDataFileManager();
				var wsName:String = mdfm.createChildWorkSpaceName(this.parentWsName,1);
				this.initWorkSpace(this.wsMask,new Point(wsx,wsy),new Point(wsw,wsh),wsName);
				this.ws.initFromSaveData(mdfio.workSpaceDO);
			}
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerAreaAttributeDelete(e:Event):void{
			var ma:MapArea = ws.currentClickMapArea;
			if(ma != null){
				ws.deleteMapArea(ma);
			}
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerAreaAttributeSubmit(e:Event):void{
			this.ws.updateMapArea(this.areaAttribute);
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
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
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerMapAreaDoubleClick(e:Event):void{
			this.parentWsName = this.ws.wsName;
			var dir:String = mmAttribute.mapFileMainDirectory;
			var mdfm:MapDataFileManager = new MapDataFileManager();
			var mado:MapAreaDO = ws.currentClickMapArea.mapAreaDO;
			var ma:MapArea = ws.currentClickMapArea;
			var wsName:String = mdfm.createChildWorkSpaceName(this.parentWsName,1);
			this.initWorkSpace(wsMask,new Point(wsx,wsy),new Point(wsw,wsh),wsName);
			///初始化数据
			if(dir != null){
				var mdfio:MapDataFileManager = new MapDataFileManager();
				mdfio.addEventListener(Event.COMPLETE,handlerLoadXMLComplete);
				var fullPath:String = mdfio.creatFileFullPath(this.parentWsName);
				if(mdfio.fileIsExists(fullPath)){
					mdfio.open(fullPath);
				}
			}
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerMapAreaChange(e:Event):void{
			var maha:HashVector = this.ws.manager.mapAreaDOAry;
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