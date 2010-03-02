package com.snsoft.map{
	import com.snsoft.map.util.HashArray;
	import com.snsoft.map.util.MapUtil;
	
	import fl.core.UIComponent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	
	/**
	 * 工作区 
	 * @author Administrator
	 * 
	 */	
	public class WorkSpace extends UIComponent {
		
		//点管理器
		private var manager:MapPointsManager = null;
		
		//画出的线所在的层Layer
		private var linesLayer:MovieClip = new MovieClip();
		
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
		private var mapImage:MapBackImage = new MapBackImage();
		
		//提示
		private var suggest:MapLine = new MapLine();
		
		//工具类型
		private var _toolEventType:String = null;
		
		//所有点的数组的数组
		private var pointAryAry:Array = new Array();
		
		private static const VIEW_COLOR:uint = 0xff0000;
		
		private static const VIEW_FILL_COLOR:uint = 0xffffff;
		
		private static const LINE_COLOR:uint = 0xff0000;
		
		private static const LINE_FILL_COLOR:uint = 0xffffff;
		
		private static const AREA_LINE_COLOR:uint = 0x0000ff;
		
		private static const AREA_FILL_COLOR:uint = 0xffff00;
		
		private static const AREA_FILL_MOUSE_OVER_COLOR:uint = 0x00ff00;
		
		public static const EVENT_MAP_AREA_CLICK:String = "EVENT_MAP_AREA_CLICK";
		
		private var _currentClickMapArea:MapArea = null;
		
		private var threadMouseMoveSign:Boolean = true;
		
		private var threadMouseClickSign:Boolean = true;
		
		private var scalePoint:Point = new Point(2,2);
		
		private var hitTestDvaluePoint:Point = new Point(5,5);
		
		/**
		 * 构造方法 
		 * 
		 */
		public function WorkSpace(sizePoint:Point) {
			super();
			if(sizePoint != null){
				this.width = sizePoint.x;
				this.height = sizePoint.y;
			}
			init();
		}
		
		/**
		 * 初始化 
		 * 
		 */		
		public function init():void{
			
			//点管理器
			var scaleHtdP:Point = MapUtil.creatInverseSaclePoint(hitTestDvaluePoint,this.scalePoint);
			this.manager = new MapPointsManager(new Point(this.width,this.height),scaleHtdP);
			
			//显示对象层
			this.addChild(mapImageLayer);//背景图片
			this.addChild(backLayer);//背影
			this.addChild(mapsLayer);//区块
			this.addChild(linesLayer);//点线
			this.addChild(viewLayer);//提示
			this.addChild(fastViewLayer);//快速画线
			this.addChild(penLayer);//画笔
			
			//显示对象
			this.penLayer.addChild(this.pen);//画笔
			this.pen.visible = false;
			
			this.mapImageLayer.addChild(this.mapImage);//背景图片
			this.mapImage.addEventListener(Event.COMPLETE,mapBackImageLoadComplete);
			this.backLayer.addChild(this.back);//背影
			this.refreshMapBack(null);
			
			this.viewLayer.addChild(this.suggest);//提示
			this.suggest.pointColor = VIEW_COLOR;
			this.suggest.lineColor = VIEW_COLOR;
			this.suggest.pointFillColor = VIEW_FILL_COLOR;
			this.suggest.scalePoint = this.scalePoint;
			this.viewLayer.mouseEnabled = false;
			this.viewLayer.buttonMode = false;
			this.viewLayer.mouseChildren = false;
			
			//注册事件  MOUSE_OVER / CLICK / MOUSE_MOVE / MOUSE_OUT
			this.addEventListener(MouseEvent.MOUSE_OVER,handlerMouseOverWorkSpace);
			this.addEventListener(MouseEvent.CLICK,handerMouseClickWorkSpace);
			this.addEventListener(MouseEvent.MOUSE_MOVE,handlerMouseMoveWorkSpase);
			this.addEventListener(MouseEvent.MOUSE_OUT,handlerMouseOutWorkSpase);
			
		}
		
		/**
		 * 缩放刷新工作区 
		 * 
		 */		
		public function refreshScale():void{
			//刷新地图块
			
			
			//刷新当前画线
			
		}
		
		public function refreshMapBack(imageUrl:String):void{
			var w:Number = this.width;
			var h:Number = this.height;
			if(imageUrl != null){
				this.mapImage.imageUrl = imageUrl;
				this.mapImage.refresh();
			}
			else {
				this.mapImage.width = w;
				this.mapImage.height = h;
				this.back.width = w;
				this.back.height = h;
				this.back.refresh();
			}
		}
		
		public function deleteMapArea(mapArea:MapArea):void{
			var ml:MovieClip = this.mapsLayer;
			var mado:MapAreaDO = mapArea.mapAreaDO;
			var name:String = MapPointsManager.creatHashArrayHashName(mado.pointArray);
			var ma:MapArea = ml.getChildByName(name) as MapArea;
			if(ma != null){
				ml.removeChild(ma);
			}
			var mpm:MapPointsManager = this.manager;
			mpm.deletePointAryAndDeleteHitTestPoint(mado);
		}
		
		public function mapBackImageLoadComplete(e:Event):void{
			this.width = this.mapImage.width;
			this.height = this.mapImage.height;
			trace(this.width,this.height);
			var w:Number = this.width;
			var h:Number = this.height;
			this.back.width = w;
			this.back.height = h;
			this.back.refresh();
		}
		
		/**
		 * 事件 MOUSE_OVER
		 * @param e
		 * 
		 */		
		private function handlerMouseOverWorkSpace(e:Event):void{
			
			var mousep:Point = new Point(this.mouseX,this.mouseY);
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
		private function handerMouseClickWorkSpace(e:Event):void{
			if(threadMouseClickSign){
				threadMouseClickSign = false;
				if(this.toolEventType == null || this.toolEventType != ToolsBar.TOOL_TYPE_LINE){
					return;
				}
				
				//画笔坐标
				var mousep:Point = new Point(pen.x,pen.y);
				var mouseScaleP:Point = MapUtil.creatInverseSaclePoint(mousep,this.scalePoint);
				
				//画笔状态
				if(this.pen.penState == Pen.PEN_STATE_START){ //画笔状态是开始画：起点未画，末点未画
					this.pen.penState = Pen.PEN_STATE_DOING;
				}
				else if(this.pen.penState == Pen.PEN_STATE_DOING) { //画笔状态是正在画：起点画完，末点未画
					mouseScaleP = this.suggest.endPoint;
				}
				
				//点管理器
				var pstate:MapPointManagerState = this.manager.addPoint(mouseScaleP); 
				var cpa:HashArray = this.manager.currentPointAry;
				var hitp:Point = pstate.hitPoint;
				var flha:HashArray = pstate.fastPointArray;
				
				//如果当前要画的点是闭合、碰撞、正常状态
				if(pstate.isState(MapPointManagerState.IS_CLOSE) 
					|| pstate.isState(MapPointManagerState.IS_NORMAL) 
					|| pstate.isState(MapPointManagerState.IS_HIT)){ //画笔状态，如果能继续画
					
					//把画线添加到线层
					if(flha != null && flha.length > 0){
						var sn:int = cpa.length - flha.length;
						var p1:Point = cpa.findByIndex(sn -1) as Point;
						for(var i:int =sn;i<cpa.length;i++){
							var p2:Point = cpa.findByIndex(i) as Point;
							var fml:MapLine = new MapLine(p1,p2,VIEW_COLOR,VIEW_COLOR,VIEW_FILL_COLOR,this.scalePoint);
							fml.refresh();
							this.linesLayer.addChild(fml);
							p1 = p2;
						}
					}
					else { 	
						var ml:MapLine = new MapLine(this.suggest.startPoint,this.suggest.endPoint,VIEW_COLOR,VIEW_COLOR,VIEW_FILL_COLOR,this.scalePoint);
						this.linesLayer.addChild(ml);
					}
					
					//如果当前要画的点是闭合状态
					if(pstate.isState(MapPointManagerState.IS_CLOSE)){ //如果当前链已关闭
						
						//初始化提示 view 和  画笔 pen
						this.pen.penState = Pen.PEN_STATE_START;
						this.suggest.startPoint = null;
						this.suggest.endPoint = null;
						this.suggest.refresh();
						
						//画区块
						var mado:MapAreaDO = this.manager.findLatestMapAreaDO();
						var ma:MapArea = new MapArea(mado,AREA_LINE_COLOR,AREA_FILL_COLOR,this.scalePoint);
						ma.name = MapPointsManager.creatHashArrayHashName(mado.pointArray);
						ma.refresh();
						this.mapsLayer.addChild(ma);
						this.addMapAreaEvent(ma);
						
						//删除画出的线
						MapUtil.deleteAllChild(this.linesLayer);
						MapUtil.deleteAllChild(this.fastViewLayer);
					}
					else{//如果当前链没有关闭
						this.suggest.startPoint = hitp;
						this.suggest.endPoint = hitp;
						this.suggest.refresh();
					}
				}
			}
			threadMouseClickSign = true;
		}
		
		
		
		/**
		 * 事件 MOUSE_MOVE
		 * @param e
		 * 
		 */		
		private function handlerMouseMoveWorkSpase(e:Event):void{
			
			if(threadMouseMoveSign){
				threadMouseMoveSign = false;
				//获得当前鼠标坐标，给画笔置位置
				var mousep:Point = new Point(this.mouseX,this.mouseY);
				var mouseScaleP:Point = MapUtil.creatInverseSaclePoint(mousep,this.scalePoint);
				this.pen.x = mousep.x;
				this.pen.y = mousep.y;
				
				this.mouseChildren = true;
				
				if(this.toolEventType == null){
					return;
				}
				else if(this.toolEventType == ToolsBar.TOOL_TYPE_SELECT){
					this.pen.penSkin = Pen.PEN_SELECT_DEFAULT_SKIN;
					this.pen.refresh();
					return;
				}
				else if(this.toolEventType == ToolsBar.TOOL_TYPE_DRAG){
					this.pen.penSkin = Pen.PEN_DRAG_DEFAULT_SKIN;
					this.pen.refresh();
					this.mouseChildren = false;
					return;
				}
				
				//当前点状态
				var pstate:MapPointManagerState = this.manager.hitTestPoint(mouseScaleP); 
				var hitp:Point = pstate.hitPoint;//检测返回结果点
				var cpa:HashArray = this.manager.currentPointAry;
				
				if(pstate.isState(MapPointManagerState.IS_CLOSE)) {//如果闭合链了
					this.pen.penSkin = Pen.PEN_LINE_CLOSE_SKIN;
				}
				else if(pstate.isState(MapPointManagerState.IS_IN_CPA)){//如果在当前链上，且不闭合
					this.pen.penSkin = Pen.PEN_LINE_UNABLE_SKIN;
				}
				else if (pstate.isState(MapPointManagerState.IS_HIT)) {//如果碰撞了，但不在当前链上
					this.pen.penSkin = Pen.PEN_LINE_POINT_SKIN;
				}
				else {//其它情况
					this.pen.penSkin = Pen.PEN_LINE_DEFAULT_SKIN;
				}
				this.pen.refresh();
				MapUtil.deleteAllChild(this.fastViewLayer);
				if(this.pen.penState == Pen.PEN_STATE_DOING){//画笔状态是正在画：起点画完，末点未画
					var fpa:HashArray = pstate.fastPointArray;
					if(fpa != null && fpa.length > 0){
						var p1:Point = cpa.findLast() as Point;
						for(var i:int =0;i<fpa.length;i++){
							var p2:Point = fpa.findByIndex(i) as Point;
							var ml:MapLine = new MapLine(p1,p2,VIEW_COLOR,VIEW_COLOR,VIEW_FILL_COLOR,this.scalePoint);
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
			threadMouseMoveSign = true;
		}
		
		/**
		 * 事件 MOUSE_OUT
		 * @param e
		 * 
		 */		
		private function handlerMouseOutWorkSpase(e:Event):void{
			Mouse.show();
			this.pen.visible = false;
		}
		
		/**
		 * 
		 * @param mapArea
		 * 
		 */		
		private function addMapAreaEvent(mapArea:MapArea):void{
			if(mapArea != null){
				mapArea.addEventListener(MouseEvent.MOUSE_DOWN,handlerMapAreaMouseDown);
				mapArea.addEventListener(MouseEvent.MOUSE_OVER,handlerMapAreaMouseOver);
				mapArea.addEventListener(MouseEvent.MOUSE_OUT,handlerMapAreaMouseOut);
				mapArea.addEventListener(MapArea.CUNTRY_NAME_MOVE_EVENT,handlerMapAreaCuntryNameMove);
			}
		}
		
		private function handlerMapAreaCuntryNameMove(e:Event):void{
			this.dispatchEvent(new Event(EVENT_MAP_AREA_CLICK));
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerMapAreaMouseDown(e:Event):void{
			if(this.toolEventType == null || this.toolEventType != ToolsBar.TOOL_TYPE_SELECT){
				return;
			}
			var ma:MapArea = e.currentTarget as MapArea;
			if(ma != null){
				this.mapsLayer.setChildIndex(ma,this.mapsLayer.numChildren - 1);
			}
			this._currentClickMapArea = ma;
			this.dispatchEvent(new Event(EVENT_MAP_AREA_CLICK));
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerMapAreaMouseOver(e:Event):void{
			if(this.toolEventType == null ){
				return;
			}
			if(this.toolEventType == ToolsBar.TOOL_TYPE_SELECT){
				this.removeEventListener(MouseEvent.MOUSE_OVER,handlerMouseOverWorkSpace);
				this.removeEventListener(MouseEvent.CLICK,handerMouseClickWorkSpace);
				this.removeEventListener(MouseEvent.MOUSE_MOVE,handlerMouseMoveWorkSpase);
				this.removeEventListener(MouseEvent.MOUSE_OUT,handlerMouseOutWorkSpase);
				var ma:MapArea = e.currentTarget as MapArea;
				if(ma != null){
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
		private function handlerMapAreaMouseOut(e:Event):void{
			if(this.toolEventType == null || this.toolEventType != ToolsBar.TOOL_TYPE_SELECT){
				return;
			}
			var ma:MapArea = e.currentTarget as MapArea;
			if(ma != null){
				ma.fillColor = AREA_FILL_COLOR;
				ma.refresh();
			}
			this.addEventListener(MouseEvent.MOUSE_OVER,handlerMouseOverWorkSpace);
			this.addEventListener(MouseEvent.CLICK,handerMouseClickWorkSpace);
			this.addEventListener(MouseEvent.MOUSE_MOVE,handlerMouseMoveWorkSpase);
			this.addEventListener(MouseEvent.MOUSE_OUT,handlerMouseOutWorkSpase);
		}
		
		public function get toolEventType():String
		{
			return _toolEventType;
		}
		
		public function set toolEventType(value:String):void
		{
			_toolEventType = value;
		}
		
		public function get currentClickMapArea():MapArea
		{
			return _currentClickMapArea;
		}
		
	}
}