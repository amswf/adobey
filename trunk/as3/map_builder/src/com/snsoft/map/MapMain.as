package com.snsoft.map
{
	import com.snsoft.map.file.MapDataFileManager;
	import com.snsoft.util.HashVector;
	import com.snsoft.util.PointUtil;
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.complexEvent.CplxMouseDrag;
	
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
		
		//根工作区
		private var rootWs:WorkSpace = null;
		
		//综合事件对象[拖动]
		private var spriteMouseAction:CplxMouseDrag = new CplxMouseDrag();
		
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
		
		//
		private var workSpaceHashVector:HashVector = new HashVector();
		
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
			
			//工作区遮罩
			wsMask =  SkinsUtil.createSkinByName(MAIN_FRAME_SKIN);
			this.addChild(wsMask);
			wsMask.width = wsw;
			wsMask.height = wsh;
			wsMask.x = wsx;
			wsMask.y = wsy;
			
			var mdfm:MapDataFileManager = new MapDataFileManager();
			this.parentWsName = MapDataFileManager.MAP_FILE_BASE_NAME;
			var wsName:String = MapDataFileManager.createChildWorkSpaceName(this.parentWsName,1);
			
			//工作区
			//this.initWorkSpace(wsMask,new Point(wsx,wsy),new Point(wsw,wsh),wsName);
			this.initWorkSpaceByName();
			this.rootWs = this.ws;
			
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
			var atbh:Number = 145;
			
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
			wsAttribute.addEventListener(WorkSpaceAttribute.BACK_PARENT_EVENT,handlerWsAttributeBackParent);
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
			this.workSpaceHashVector.push(ws,wsName);
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
			ws.scalePoint = PointUtil.creatSaclePoint(ws.scalePoint,new Point(2,2));
			ws.refreshScale(this.wsFrame);
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerWsAttributeZoomOut(e:Event):void{
			ws.scalePoint = PointUtil.creatInverseSaclePoint(ws.scalePoint,new Point(2,2));
			ws.refreshScale(this.wsFrame);
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerWsAttributeBackParent(e:Event):void{
			var wsName:String = this.ws.wsName;
			if(wsName != null){
				wsName = MapDataFileManager.createParentWorkSpaceName(wsName);
				if(wsName != null){
					var ws:WorkSpace = this.workSpaceHashVector.findByName(wsName) as WorkSpace;
					this.updateAndSetWorkSpace(ws,wsName);
				}
			}
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
				
				//删除所有分层保存文件
				mdfm.deleteAllChildDirectory();
				
				//保存
				var mdfio:MapDataFileManager = new MapDataFileManager();
				var hv:HashVector = this.workSpaceHashVector;
				if(hv != null){
					for(var i:int = 0;i < hv.length;i ++){
						var ws:WorkSpace = hv.findByIndex(i) as WorkSpace;
						var wsName:String = ws.wsName;
						if(wsName != null){
							var fullPath:String = mdfio.creatFileFullPath2(wsName);
							if(ws != null){
								mdfio.save(ws,fullPath);
							}
						}
					}
				}
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
				mdfio.mainDirectory = dir;
				mdfio.addEventListener(Event.COMPLETE,handlerLoadXMLComplete);
				mdfio.openAll();
			}
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerLoadXMLComplete(e:Event):void{
			var mdfio:MapDataFileManager = e.currentTarget as MapDataFileManager;
			var v:Vector.<WorkSpaceDO> = mdfio.workSpaceDOVector;
			for(var i:int = 0;i < v.length;i ++){
				var wsdo:WorkSpaceDO = v[i];
				var wsName:String = wsdo.wsName;
				var ws:WorkSpace = new WorkSpace(new Point(this.wsw,this.wsh));
				ws.initFromSaveData(wsdo);
				ws.wsName = wsName;
				this.workSpaceHashVector.push(ws,wsName);
			}
			var rootWsName:String = MapDataFileManager.MAP_FILE_DEFAULT_NAME;
			var rootWs:WorkSpace = this.workSpaceHashVector.findByName(rootWsName) as WorkSpace; 
			this.updateAndSetWorkSpace(rootWs,rootWsName);
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
			var ac:String = "";
			var au:String = "";
			var anx:String = "0";
			var any:String = "0";
			if(mado.areaName != null){
				an = mado.areaName;
			}
			if(mado.areaCode != null){
				ac = mado.areaCode;
			}
			if(mado.areaUrl != null){
				au = mado.areaUrl;
			}
			areaAttribute.setareaName(an);
			areaAttribute.setareaCode(ac);
			areaAttribute.setareaUrl(au);
			areaAttribute.setareaNameX(String(mado.areaNamePlace.x));
			areaAttribute.setareaNameY(String(mado.areaNamePlace.y));
			this.workSpaceHashVector.push(this.ws,this.ws.wsName);
		}
		
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerMapAreaDoubleClick(e:Event):void{
			var ma:MapArea = this.ws.currentClickMapArea;
			var mado:MapAreaDO = ma.mapAreaDO;
			this.initWorkSpaceByName(mado.areaId);
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
			spriteMouseAction.removeEvents();
			var toolEventType:String = bar.toolEventType;
			ws.toolEventType = toolEventType;
			if(ws.toolEventType == ToolsBar.TOOL_TYPE_DRAG){
				spriteMouseAction.addEvents(this.ws,this.wsFrame);
			}
		}
		
		/**
		 *  
		 * @param e
		 * 
		 */		
		private function handlerWsDragMove(e:Event):void{
			
		}
		
		
		/**
		 * 通过工作区名称初始化工作区 
		 * @param parentWsName
		 * 
		 */		
		private function initWorkSpaceByName(wsName:String = null):void{
			if(wsName == null){
				wsName = MapDataFileManager.MAP_FILE_DEFAULT_NAME;
			}
			var newWs:WorkSpace = null;
			var wshv:HashVector = this.workSpaceHashVector;
			var hvWs:WorkSpace = wshv.findByName(wsName) as WorkSpace;
			var dir:String = mmAttribute.mapFileMainDirectory;
			var sign:Boolean = false;
			if(hvWs != null){
				newWs = hvWs;
			}
			else{
				newWs = new WorkSpace(new Point(this.wsw,this.wsh));
			}
			this.updateAndSetWorkSpace(newWs,wsName); 
			
			if(dir != null && hvWs == null){
				var mdfio:MapDataFileManager = new MapDataFileManager();
				mdfio.addEventListener(Event.COMPLETE,handlerLoadXMLComplete);
				var fullPath:String = mdfio.creatFileFullPath2(wsName);
				if(mdfio.fileIsExists(fullPath)){
					mdfio.open(fullPath);
				}
			}
		}
		
		/**
		 * 更新工作区并设置关联属性
		 * @param ws
		 * @param wsName
		 * @param msk
		 * @param place
		 * @param size
		 * 
		 */		
		private function updateAndSetWorkSpace(ws:WorkSpace,wsName:String):void{
			if(ws != null && wsName != null){
				ws.mask = this.wsMask;
				ws.x = this.wsx;
				ws.y = this.wsy;
				ws.wsName = wsName;
				if(this.ws != null){
					this.removeChild(this.ws);
				}
				this.ws = ws;
				this.addChild(this.ws);
				
				ws.addEventListener(WorkSpace.EVENT_MAP_AREA_CLICK,handlerMapAreaClick);
				ws.addEventListener(WorkSpace.EVENT_MAP_AREA_DOUBLE_CLICK,handlerMapAreaDoubleClick);
				ws.addEventListener(WorkSpace.EVENT_MAP_AREA_ADD,handlerMapAreaChange);
				ws.addEventListener(WorkSpace.EVENT_MAP_AREA_DELETE,handlerMapAreaChange);
				ws.addEventListener(WorkSpace.EVENT_MAP_AREA_UPDATE,handlerMapAreaChange);
				
				//相关联属性设置
				this.wsAttribute.refreshMapAreaListBtn(null);
				this.workSpaceHashVector.push(ws,wsName);
				this.ws.dispatchEvent(new Event(WorkSpace.EVENT_MAP_AREA_ADD));
			}
		}
	}
}