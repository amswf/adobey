package com.snsoft.map {
	import com.snsoft.map.file.MapDataFileManager;
	import com.snsoft.util.HashVector;
	import com.snsoft.util.PointUtil;

	import fl.core.UIComponent;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;

	/**
	 * 工作区
	 * @author Administrator
	 *
	 */
	public class WorkSpace extends UIComponent {

		//画区块点管理器
		private var _areaManager:MapPointsManager = null;

		//画路径点管理器
		private var _pathManager:MapPathManager = null;

		//画出的线所在的层Layer
		private var linesLayer:MovieClip = new MovieClip();

		//画出的线所在的层Layer
		private var pathLayer:MovieClip = new MovieClip();

		//画笔所在的层Layer
		private var penLayer:MovieClip = new MovieClip();

		//操作提示层Layer
		private var viewLayer:MovieClip = new MovieClip();

		//操作提示快速画线提示层Layer
		private var fastViewLayer:MovieClip = new MovieClip();

		//地图分块层Layer
		private var mapsLayer:MovieClip = new MovieClip();

		//背景层Layer	
		private var backLayer:MovieClip = new MovieClip();

		//背景图片层Layer	
		private var mapImageLayer:MovieClip = new MovieClip();

		//画笔对象
		private var pen:Pen = new Pen();

		//背景对象
		private var back:MapBack = new MapBack();

		//背景图片
		private var _mapImage:MapBackImage = null;

		//提示
		private var suggest:MapLine = new MapLine();

		//工具类型
		private var _toolEventType:String = null;

		//所有点的数组的数组
		private var pointAryAry:Array = new Array();

		private static const VIEW_COLOR:int = 0xff0000;

		private static const VIEW_FILL_COLOR:int = 0xffffff;

		private static const LINE_COLOR:int = 0xff0000;

		private static const LINE_FILL_COLOR:int = 0xffffff;

		private static const AREA_LINE_COLOR:int = 0x0000ff;

		private static const AREA_FILL_COLOR:int = 0xffff00;

		private static const AREA_FILL_MOUSE_OVER_COLOR:int = 0x00ff00;

		public static const EVENT_MAP_AREA_CLICK:String = "EVENT_MAP_AREA_CLICK";

		public static const EVENT_MAP_AREA_DOUBLE_CLICK:String = "EVENT_MAP_AREA_DOUBLE_CLICK";

		public static const EVENT_MAP_AREA_DELETE:String = "EVENT_MAP_AREA_DELETE";

		public static const EVENT_MAP_AREA_ADD:String = "EVENT_MAP_AREA_ADD";

		public static const EVENT_MAP_AREA_UPDATE:String = "EVENT_MAP_AREA_UPDATE";

		private var _currentClickMapArea:MapArea = null;

		private var threadMouseMoveSign:Boolean = true;

		private var threadMouseClickSign:Boolean = true;

		private var _scalePoint:Point = new Point(1, 1);

		private var hitTestDvaluePoint:Point = new Point(5, 5);

		//工作区名称
		private var _wsName:String = null;

		//工作区数据对象
		private var workSpaceDO:WorkSpaceDO = null;

		/**
		 * 构造方法
		 *
		 */
		public function WorkSpace(sizePoint:Point) {
			super();
			if (sizePoint != null) {
				this.width = sizePoint.x;
				this.height = sizePoint.y;
			}
			init();
		}

		/**
		 * 初始化
		 *
		 */
		public function init():void {

			//点管理器
			var scaleHtdP:Point = PointUtil.creatInverseSaclePoint(hitTestDvaluePoint, this.scalePoint);
			this._areaManager = new MapPointsManager(new Point(this.width, this.height), scaleHtdP);
			this._pathManager = new MapPathManager(new Point(this.width, this.height), scaleHtdP);

			//显示对象层
			this.addChild(mapImageLayer); //背景图片
			this.addChild(backLayer); //背影
			this.addChild(mapsLayer); //区块
			this.addChild(linesLayer); //点线
			this.addChild(pathLayer); //路径
			this.addChild(viewLayer); //提示
			this.addChild(fastViewLayer); //快速画线
			this.addChild(penLayer); //画笔

			//显示对象
			this.penLayer.addChild(this.pen); //画笔
			this.pen.visible = false;

			var wsSize:Point = new Point(this.width, this.height);

			this._mapImage = new MapBackImage(wsSize);
			this.mapImageLayer.addChild(this.mapImage); //背景图片
			this.mapImage.scalePoint = this.scalePoint;
			this.mapImage.addEventListener(Event.COMPLETE, mapBackImageLoadComplete);
			this.backLayer.addChild(this.back); //背影
			this.refreshMapBack(null);

			this.viewLayer.addChild(this.suggest); //提示
			this.suggest.pointColor = VIEW_COLOR;
			this.suggest.lineColor = VIEW_COLOR;
			this.suggest.pointFillColor = VIEW_FILL_COLOR;
			this.suggest.scalePoint = this.scalePoint;
			this.viewLayer.mouseEnabled = false;
			this.viewLayer.buttonMode = false;
			this.viewLayer.mouseChildren = false;

			//注册事件  MOUSE_OVER / CLICK / MOUSE_MOVE / MOUSE_OUT
			this.addEventListener(MouseEvent.MOUSE_OVER, handlerMouseOverWorkSpace);
			this.addEventListener(MouseEvent.CLICK, handerMouseClickWorkSpace);
			this.addEventListener(MouseEvent.MOUSE_MOVE, handlerMouseMoveWorkSpase);
			this.addEventListener(MouseEvent.MOUSE_OUT, handlerMouseOutWorkSpase);

		}

		public function saveWorkSpace(parentWsName:String = null):void {
			if (parentWsName == null) {
				parentWsName = MapDataFileManager.MAP_FILE_BASE_NAME;
			}
			var mdfio:MapDataFileManager = new MapDataFileManager();
			var fullPath:String = mdfio.creatFileFullPath(parentWsName);
			mdfio.save(this, fullPath);

			for (var i:int = 0; i < this.mapsLayer.numChildren; i++) {
				var ma:MapArea = this.mapsLayer.getChildAt(i) as MapArea;
				if (ma != null) {
					ma.childWorkSpace.saveWorkSpace(this.wsName);
				}
			}
		}

		/**
		 * 缩放刷新工作区
		 *
		 */
		public function refreshScale(wsFrame:DisplayObject):void {
			var pp:Point = new Point(this.x, this.y);
			var sp:Point = new Point(this.width, this.height);

			//刷新地图块
			var mal:MovieClip = this.mapsLayer;
			for (var iMal:int = 0; iMal < mal.numChildren; iMal++) {
				var ma:MapArea = mal.getChildAt(iMal) as MapArea;
				if (ma != null) {
					ma.scalePoint = this.scalePoint;
					ma.refresh();
				}
			}
			//刷新当前画线
			var mll:MovieClip = this.linesLayer;
			for (var iMll:int = 0; iMll < mll.numChildren; iMll++) {
				var ml:MapLine = mll.getChildAt(iMll) as MapLine;
				if (ml != null) {
					ml.scalePoint = this.scalePoint;
					ml.refresh();
				}
			}

			//刷新当前路径
			var mpl:MovieClip = this.pathLayer;
			for (var iMpl:int = 0; iMpl < mpl.numChildren; iMpl++) {
				var mp:MapLine = mpl.getChildAt(iMpl) as MapLine;
				if (mp != null) {
					mp.scalePoint = this.scalePoint;
					mp.refresh();
				}
			}

			//刷新当前正在画的线
			this.suggest.scalePoint = this.scalePoint;
			this.suggest.refresh();

			//刷新碰撞检测的碰撞阈值
			this.areaManager.hitTestDvaluePoint = PointUtil.creatInverseSaclePoint(this.hitTestDvaluePoint, this.scalePoint);
			var sizeP:Point = PointUtil.creatInverseSaclePoint(new Point(this.width, this.height), this.scalePoint);
			this.width = sizeP.x;
			this.height = sizeP.y;

			//刷新地图
			this.mapImage.scalePoint = this.scalePoint;
			this.mapImage.refresh();

			this.width = this.mapImage.width;
			this.height = this.mapImage.height;

			var signX:Number = this.width > sp.x ? -1 : 1;
			var signY:Number = this.height > sp.y ? -1 : 1;

			var x:Number = pp.x - (0.5 * wsFrame.width - (pp.x - wsFrame.x)) * (this.width - sp.x) / sp.x;
			var y:Number = pp.y - (0.5 * wsFrame.height - (pp.y - wsFrame.y)) * (this.height - sp.y) / sp.y;

			this.x = x;
			this.y = y;
			this.dispatchEvent(new Event(MouseEvent.MOUSE_UP));
		}

		public function refreshMapBack(imageUrl:String):void {
			var w:Number = this.width;
			var h:Number = this.height;
			if (imageUrl != null) {
				this.mapImage.imageUrl = imageUrl;
				this.mapImage.addEventListener(Event.COMPLETE, mapBackImageLoadComplete);
				this.mapImage.loadImage();
			}
		}

		public function updateMapArea(areaAttribute:AreaAttribute):void {
			var ma:MapArea = this.currentClickMapArea;
			if (ma != null) {
				if (areaAttribute.getareaName() != null) {
					ma.mapAreaDO.areaName = areaAttribute.getareaName();
				}
				if (areaAttribute.getareaCode() != null) {
					ma.mapAreaDO.areaCode = areaAttribute.getareaCode();
				}
				if (areaAttribute.getareaUrl() != null) {
					ma.mapAreaDO.areaUrl = areaAttribute.getareaUrl();
				}
				if (areaAttribute.getareaNameX() != null) {
					ma.mapAreaDO.areaNamePlace.x = Number(areaAttribute.getareaNameX());
				}
				if (areaAttribute.getareaNameY() != null) {
					ma.mapAreaDO.areaNamePlace.y = Number(areaAttribute.getareaNameY());
				}
				ma.refresh();
				var hv:HashVector = ma.mapAreaDO.pointArray;
				var name:String = MapPointsManager.creatHashArrayHashName(hv);
				this.areaManager.mapAreaDOAry.push(ma.mapAreaDO, name);
				this.dispatchEvent(new Event(EVENT_MAP_AREA_UPDATE));
			}
		}

		public function deleteMapArea(mapArea:MapArea):void {
			var ml:MovieClip = this.mapsLayer;
			var mado:MapAreaDO = mapArea.mapAreaDO;
			var name:String = MapPointsManager.creatHashArrayHashName(mado.pointArray);
			var ma:MapArea = ml.getChildByName(name) as MapArea;
			if (ma != null) {
				ml.removeChild(ma);
			}
			var mpm:MapPointsManager = this.areaManager;
			mpm.deletePointAryAndDeleteHitTestPoint(mado);
			this.dispatchEvent(new Event(EVENT_MAP_AREA_DELETE));
		}

		/**
		 * 创建地图块时，地图块的默人名称，也是地图块的编号。
		 * @return
		 *
		 */
		public function createChildWordSpaceId():String {
			var baseId:String = this.wsName;
			var areaId:String = null;
			for (var i:int = 1; i <= this.mapsLayer.numChildren + 1; i++) {
				var id:String = baseId + MapDataFileManager.MAP_FILE_NAME_SPLIT + i;
				var hasSame:Boolean = false;
				for (var j:int = 0; j < this.mapsLayer.numChildren; j++) {
					var ma:MapArea = this.mapsLayer.getChildAt(j) as MapArea;
					var mado:MapAreaDO = ma.mapAreaDO;
					if (id == mado.areaId) {
						hasSame ||= true;
						break;
					}
				}
				if (!hasSame) {
					areaId = id;
					break;
				}
			}
			return areaId;
		}

		/**
		 * 事件 加载图片完成
		 * @param e
		 *
		 */
		public function mapBackImageLoadComplete(e:Event):void {
			var wsSize:Point = new Point(this.mapImage.width, this.mapImage.height);
			PointUtil.setSpriteSize(this, wsSize);
			this.areaManager.setHitTest(wsSize);
			this.mapImage.removeEventListener(Event.COMPLETE, mapBackImageLoadComplete);
		}

		/**
		 * 事件 MOUSE_OVER
		 * @param e
		 *
		 */
		private function handlerMouseOverWorkSpace(e:Event):void {

			var mousep:Point = new Point(this.mouseX, this.mouseY);
			this.pen.x = mousep.x;
			this.pen.y = mousep.y;

			//画笔
			Mouse.hide();
			this.pen.visible = true;
		}

		/**
		 * 事件 CLICK
		 * @param e
		 *
		 */
		private function handerMouseClickWorkSpace(e:Event):void {
			if (threadMouseClickSign) {
				threadMouseClickSign = false;
				if (this.toolEventType == ToolsBar.TOOL_TYPE_LINE) {
					drawArea();
				}
				else if (this.toolEventType == ToolsBar.TOOL_TYPE_PATH) {
					drawPath();
				}
			}
			threadMouseClickSign = true;
		}

		private function drawPath():void {
			//画笔坐标
			var mousep:Point = new Point(pen.x, pen.y);
			var p1:Point = this.suggest.startPoint;
			var p2:Point = this.suggest.endPoint;
			//画笔状态
			if (this.pen.penState == Pen.PEN_STATE_START) { //画笔状态是开始画：起点未画，末点未画
				this.pen.penState = Pen.PEN_STATE_DOING;
				p2 = PointUtil.creatInverseSaclePoint(mousep, this.scalePoint);
				var pf:Point = pathManager.findHitPoint(p2);
				if (pf != null) {
					p2 = pf;
				}
			}
			else if (this.pen.penState == Pen.PEN_STATE_DOING) { //画笔状态是正在画：起点画完，末点未画

				if (!p1.equals(p2)) {
					var ml:MapLine = new MapLine(p1, p2, VIEW_COLOR, VIEW_COLOR, VIEW_FILL_COLOR, this.scalePoint);
					pathLayer.addChild(ml);
				}
				else {
					this.pen.penState = Pen.PEN_STATE_START;
				}
			}
			pathManager.addPoint(p2);
			this.suggest.startPoint = p2;
		}

		private function drawArea():void {
			//画笔坐标
			var mousep:Point = new Point(pen.x, pen.y);
			var mouseScaleP:Point = PointUtil.creatInverseSaclePoint(mousep, this.scalePoint);

			//画笔状态
			if (this.pen.penState == Pen.PEN_STATE_START) { //画笔状态是开始画：起点未画，末点未画
				this.pen.penState = Pen.PEN_STATE_DOING;
			}
			else if (this.pen.penState == Pen.PEN_STATE_DOING) { //画笔状态是正在画：起点画完，末点未画
				mouseScaleP = this.suggest.endPoint;
			}

			//点管理器
			var pstate:MapPointManagerState = this.areaManager.addPoint(mouseScaleP);
			var cpa:HashVector = this.areaManager.currentPointAry;
			var hitp:Point = pstate.hitPoint;
			var flha:HashVector = pstate.fastPointArray;

			//如果当前要画的点是闭合、碰撞、正常状态
			if (pstate.isState(MapPointManagerState.IS_CLOSE)
				|| pstate.isState(MapPointManagerState.IS_NORMAL)
				|| pstate.isState(MapPointManagerState.IS_HIT)) { //画笔状态，如果能继续画

				//把画线添加到线层
				if (flha != null && flha.length > 0) {
					var sn:int = cpa.length - flha.length;
					var p1:Point = cpa.findByIndex(sn - 1) as Point;
					for (var i:int = sn; i < cpa.length; i++) {
						var p2:Point = cpa.findByIndex(i) as Point;
						var fml:MapLine = new MapLine(p1, p2, VIEW_COLOR, VIEW_COLOR, VIEW_FILL_COLOR, this.scalePoint);
						fml.refresh();
						this.linesLayer.addChild(fml);
						p1 = p2;
					}
				}
				else {
					var ml:MapLine = new MapLine(this.suggest.startPoint, this.suggest.endPoint, VIEW_COLOR, VIEW_COLOR, VIEW_FILL_COLOR, this.scalePoint);
					this.linesLayer.addChild(ml);
				}

				//如果当前要画的点是闭合状态
				if (pstate.isState(MapPointManagerState.IS_CLOSE)) { //如果当前链已关闭

					//初始化提示 view 和  画笔 pen
					this.pen.penState = Pen.PEN_STATE_START;
					this.suggest.startPoint = null;
					this.suggest.endPoint = null;
					this.suggest.refresh();

					//画区块
					var mado:MapAreaDO = this.areaManager.findLatestMapAreaDO();
					addMapArea(mado);
					this.dispatchEvent(new Event(EVENT_MAP_AREA_ADD));

					//删除画出的线
					PointUtil.deleteAllChild(this.linesLayer);
					PointUtil.deleteAllChild(this.fastViewLayer);
				}
				else { //如果当前链没有关闭
					this.suggest.startPoint = hitp;
					this.suggest.endPoint = hitp;
					this.suggest.refresh();
				}
			}
		}

		/**
		 * 把地图块添加到工作区
		 * @param mado
		 *
		 */
		private function addMapArea(mado:MapAreaDO):void {
			var wsName:String = null;
			if (mado.areaId != null && mado.areaId.length > 0) {
				wsName = mado.areaId;
			}
			else {
				wsName = this.createChildWordSpaceId();
				mado.areaId = wsName;
				mado.areaName = wsName;
			}
			var ma:MapArea = new MapArea(mado, AREA_LINE_COLOR, AREA_FILL_COLOR, this.scalePoint);
			ma.name = MapPointsManager.creatHashArrayHashName(mado.pointArray);
			ma.refresh();
			this.mapsLayer.addChild(ma);
			var cws:WorkSpace = new WorkSpace(new Point(0, 0));
			ma.childWorkSpace = cws;
			cws.wsName = wsName;
			this.addMapAreaEvent(ma);
		}

		/**
		 * 外部读取的数据，还原工作区。
		 * @param image
		 * @param mapAreaDoHashArray
		 *
		 */
		public function initFromSaveData(workSpaceDO:WorkSpaceDO):void {
			if (workSpaceDO != null) {
				this.workSpaceDO = workSpaceDO;
				this.refreshMapBackFromSaveData();
			}
		}

		/**
		 *
		 *
		 */
		private function refreshMapBackFromSaveData():void {
			var imageUrl:String = workSpaceDO.image;
			var w:Number = this.width;
			var h:Number = this.height;
			if (imageUrl != null) {
				this.mapImage.imageUrl = imageUrl;
				this.mapImage.addEventListener(Event.COMPLETE, mapBackImageLoadFromSaveDataComplete);
				this.mapImage.addEventListener(IOErrorEvent.IO_ERROR, mapBackImageLoadFromSaveDataIOError);
				this.mapImage.loadImage();
			}
		}

		/**
		 *
		 * @param e
		 *
		 */
		private function mapBackImageLoadFromSaveDataComplete(e:Event):void {
			var wsSize:Point = new Point(this.mapImage.width, this.mapImage.height);
			PointUtil.setSpriteSize(this, wsSize);
			this.areaManager.setHitTest(wsSize);
			initMapAreasFromSaveData();
		}

		/**
		 *
		 * @param e
		 *
		 */
		private function mapBackImageLoadFromSaveDataIOError(e:Event):void {
			initMapAreasFromSaveData();
		}

		/**
		 *
		 *
		 */
		private function initMapAreasFromSaveData():void {
			var mapAreaDoHashArray:HashVector = workSpaceDO.mapAreaDOHashArray;
			if (mapAreaDoHashArray != null) {
				for (var i:int = 0; i < mapAreaDoHashArray.length; i++) {
					var mapAreaDo:MapAreaDO = mapAreaDoHashArray.findByIndex(i) as MapAreaDO;
					if (mapAreaDo != null) {
						this.addMapArea(mapAreaDo);
						var pha:HashVector = mapAreaDo.pointArray;
						if (pha != null) {
							for (var j:int = 0; j < pha.length; j++) {
								var p:Point = pha.findByIndex(j) as Point;
								this.areaManager.addPointFromXML(p);
							}
							var endP:Point = pha.findByIndex(0) as Point;
							this.areaManager.addPointFromXML(endP, true);
						}
						var mado:MapAreaDO = this.areaManager.mapAreaDOAry.findByIndex(i) as MapAreaDO;
						mado.areaName = mapAreaDo.areaName;
						mado.areaId = mapAreaDo.areaId;
						mado.areaNamePlace = mapAreaDo.areaNamePlace;
					}
				}
			}
			this.dispatchEvent(new Event(EVENT_MAP_AREA_ADD));
		}

		/**
		 * 创建默认的地图块显示名称
		 * @return
		 *
		 */
		private function creatMapAreaDODefaultAreaName():String {
			return "area_" + (this.mapsLayer.numChildren + 1);
		}

		/**
		 * 事件 MOUSE_MOVE
		 * @param e
		 *
		 */
		private function handlerMouseMoveWorkSpase(e:Event):void {

			if (threadMouseMoveSign) {
				threadMouseMoveSign = false;

				this.mouseChildren = true;

				//获得当前鼠标坐标，给画笔置位置
				var mousep:Point = new Point(this.mouseX, this.mouseY);
				var mouseScaleP:Point = PointUtil.creatInverseSaclePoint(mousep, this.scalePoint);
				this.pen.x = mousep.x;
				this.pen.y = mousep.y;

				if (this.toolEventType == null) {
					return;
				}
				else if (this.toolEventType == ToolsBar.TOOL_TYPE_SELECT) {
					this.pen.penSkin = Pen.PEN_SELECT_DEFAULT_SKIN;
					this.pen.refresh();
					return;
				}
				else if (this.toolEventType == ToolsBar.TOOL_TYPE_DRAG) {
					this.pen.penSkin = Pen.PEN_DRAG_DEFAULT_SKIN;
					this.pen.refresh();
					this.mouseChildren = false;
					return;
				}
				else if (this.toolEventType == ToolsBar.TOOL_TYPE_LINE) {
					viewLine(mouseScaleP);
				}
				else if (this.toolEventType == ToolsBar.TOOL_TYPE_PATH) {
					viewPath(mouseScaleP);
				}
			}
			threadMouseMoveSign = true;
		}

		private function viewPath(mouseScaleP:Point):void {
			var p1:Point = this.pathManager.currentPoint;
			var p2:Point = this.pathManager.findHitPoint(mouseScaleP);
			if (p2 == null) {
				this.pen.penSkin = Pen.PEN_PATH_DEFAULT_SKIN;
				p2 = mouseScaleP;
			}
			else {
				this.pen.penSkin = Pen.PEN_PATH_POINT_SKIN;
			}

			PointUtil.deleteAllChild(this.fastViewLayer);
			if (this.pen.penState == Pen.PEN_STATE_DOING) { //画笔状态是正在画：起点画完，末点未画
				var ml:MapLine = new MapLine(p1, p2, VIEW_COLOR, VIEW_COLOR, VIEW_FILL_COLOR, this.scalePoint);
				this.fastViewLayer.addChild(ml);
				this.suggest.endPoint = p2;
			}
			this.pen.refresh();
		}

		private function viewLine(mouseScaleP:Point):void {

			//当前点状态
			var pstate:MapPointManagerState = this.areaManager.hitTestPoint(mouseScaleP);
			var hitp:Point = pstate.hitPoint; //检测返回结果点
			var cpa:HashVector = this.areaManager.currentPointAry;

			if (pstate.isState(MapPointManagerState.IS_CLOSE)) { //如果闭合链了
				this.pen.penSkin = Pen.PEN_LINE_CLOSE_SKIN;
			}
			else if (pstate.isState(MapPointManagerState.IS_IN_CPA)) { //如果在当前链上，且不闭合
				this.pen.penSkin = Pen.PEN_LINE_UNABLE_SKIN;
			}
			else if (pstate.isState(MapPointManagerState.IS_HIT)) { //如果碰撞了，但不在当前链上
				this.pen.penSkin = Pen.PEN_LINE_POINT_SKIN;
			}
			else { //其它情况
				this.pen.penSkin = Pen.PEN_LINE_DEFAULT_SKIN;
			}
			this.pen.refresh();
			PointUtil.deleteAllChild(this.fastViewLayer);
			if (this.pen.penState == Pen.PEN_STATE_DOING) { //画笔状态是正在画：起点画完，末点未画
				var fpa:HashVector = pstate.fastPointArray;
				if (fpa != null && fpa.length > 0) {
					var cpal:int = cpa.length;
					var p1:Point = cpa.findByIndex(cpal) as Point;
					for (var i:int = 0; i < fpa.length; i++) {
						var p2:Point = fpa.findByIndex(i) as Point;
						var ml:MapLine = new MapLine(p1, p2, VIEW_COLOR, VIEW_COLOR, VIEW_FILL_COLOR, this.scalePoint);
						ml.refresh();
						this.fastViewLayer.addChild(ml);
						p1 = p2;
					}
					this.suggest.visible = false;
				}
				this.suggest.visible = true;
				this.suggest.endPoint = hitp;
				this.suggest.refresh();
			}
		}

		/**
		 * 事件 MOUSE_OUT
		 * @param e
		 *
		 */
		private function handlerMouseOutWorkSpase(e:Event):void {
			Mouse.show();
			this.pen.visible = false;
		}

		/**
		 *
		 * @param mapArea
		 *
		 */
		private function addMapAreaEvent(mapArea:MapArea):void {
			if (mapArea != null) {
				mapArea.addEventListener(MouseEvent.MOUSE_DOWN, handlerMapAreaMouseDown);
				mapArea.addEventListener(MouseEvent.MOUSE_OVER, handlerMapAreaMouseOver);
				mapArea.addEventListener(MouseEvent.MOUSE_OUT, handlerMapAreaMouseOut);
				mapArea.addEventListener(MouseEvent.DOUBLE_CLICK, handlerMapAreaMouseDoubleClick);
				mapArea.addEventListener(MapArea.CUNTRY_NAME_MOVE_EVENT, handlerMapAreaCuntryNameMove);
				mapArea.doubleClickEnabled = true;
			}
		}

		private function handlerMapAreaCuntryNameMove(e:Event):void {
			var ma:MapArea = e.currentTarget as MapArea;
			this.setcurrentClickMapArea(ma.name);
			var newMado:MapAreaDO = ma.mapAreaDO;
			var hv:HashVector = newMado.pointArray;
			var madoName:String = MapPointsManager.creatHashArrayHashName(hv);
			var madohv:HashVector = this.areaManager.mapAreaDOAry;
			var managerMado:MapAreaDO = madohv.findByName(madoName) as MapAreaDO;
			if (managerMado != null) {
				managerMado.areaNamePlace = newMado.areaNamePlace;
				managerMado.areaName = newMado.areaName;
			}

			this.dispatchEvent(new Event(EVENT_MAP_AREA_CLICK));
		}

		/**
		 *
		 * @param e
		 *
		 */
		private function handlerMapAreaMouseDown(e:Event):void {
			if (this.toolEventType == null || this.toolEventType != ToolsBar.TOOL_TYPE_SELECT) {
				return;
			}
			var ma:MapArea = e.currentTarget as MapArea;
			this.setcurrentClickMapArea(ma.name);
		}

		/**
		 * 设置当前点击的地图块最顶层，并且设置工作区当前地图块对象
		 * @param name
		 *
		 */
		public function setcurrentClickMapArea(name:String):void {
			var ma:MapArea = this.mapsLayer.getChildByName(name) as MapArea;
			if (ma != null) {
				this.mapsLayer.setChildIndex(ma, this.mapsLayer.numChildren - 1);
				this._currentClickMapArea = ma;
				this.dispatchEvent(new Event(EVENT_MAP_AREA_CLICK));
			}
		}

		/**
		 *
		 * @param e
		 *
		 */
		private function handlerMapAreaMouseOver(e:Event):void {
			if (this.toolEventType == null) {
				return;
			}
			if (this.toolEventType == ToolsBar.TOOL_TYPE_SELECT) {
				this.removeEventListener(MouseEvent.MOUSE_OVER, handlerMouseOverWorkSpace);
				this.removeEventListener(MouseEvent.CLICK, handerMouseClickWorkSpace);
				this.removeEventListener(MouseEvent.MOUSE_MOVE, handlerMouseMoveWorkSpase);
				this.removeEventListener(MouseEvent.MOUSE_OUT, handlerMouseOutWorkSpase);
				var ma:MapArea = e.currentTarget as MapArea;
				if (ma != null) {
					ma.fillColor = AREA_FILL_MOUSE_OVER_COLOR;
					ma.refresh();
				}
			}
		}

		/**
		 *
		 * @param e
		 *
		 */
		private function handlerMapAreaMouseDoubleClick(e:Event):void {
			this.dispatchEvent(new Event(EVENT_MAP_AREA_DOUBLE_CLICK));
		}

		/**
		 *
		 * @param e
		 *
		 */
		private function handlerMapAreaMouseOut(e:Event):void {
			if (this.toolEventType == null || this.toolEventType != ToolsBar.TOOL_TYPE_SELECT) {
				return;
			}
			var ma:MapArea = e.currentTarget as MapArea;
			if (ma != null) {
				ma.fillColor = AREA_FILL_COLOR;
				ma.refresh();
			}
			this.addEventListener(MouseEvent.MOUSE_OVER, handlerMouseOverWorkSpace);
			this.addEventListener(MouseEvent.CLICK, handerMouseClickWorkSpace);
			this.addEventListener(MouseEvent.MOUSE_MOVE, handlerMouseMoveWorkSpase);
			this.addEventListener(MouseEvent.MOUSE_OUT, handlerMouseOutWorkSpase);
		}

		public function get toolEventType():String {
			return _toolEventType;
		}

		public function setToolEventType(value:String):void {
			this.pen.penState = Pen.PEN_STATE_START;
			_toolEventType = value;
		}

		public function get currentClickMapArea():MapArea {
			return _currentClickMapArea;
		}

		public function get scalePoint():Point {
			return _scalePoint;
		}

		public function set scalePoint(value:Point):void {
			_scalePoint = value;
		}

		public function get areaManager():MapPointsManager {
			return _areaManager;
		}

		public function get mapImage():MapBackImage {
			return _mapImage;
		}

		public function get wsName():String {
			return _wsName;
		}

		public function set wsName(value:String):void {
			_wsName = value;
		}

		public function get pathManager():MapPathManager {
			return _pathManager;
		}

	}
}
