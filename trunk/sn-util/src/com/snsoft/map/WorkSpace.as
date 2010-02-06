package com.snsoft.map{
	import com.snsoft.map.util.HashArray;
	import com.snsoft.map.util.HitTest;
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
		
		//碰撞检测的坐标差值域
		private var hitTestDValue:Point = new Point(5,5);
		
		//碰撞检测类对象
		private var hitTest:HitTest = null;
		
		private var manager:MapPointsManager = null;
		
		//画出的线所在的层Layer
		private var linesLayer:MovieClip = new MovieClip();
		
		//画笔所在的层Layer
		private var penLayer:MovieClip = new MovieClip();
		
		//操作提示层Layer
		private var viewLayer:MovieClip = new MovieClip();
		
		//地图分块层Layer
		private var mapsLayer:MovieClip = new MovieClip();
		
		//背景层Layer	
		private var backLayer:MovieClip = new MovieClip();
		
		//画笔对象
		private var pen:Pen = new Pen();
		
		//背景对象
		private var back:MapBack = new MapBack();
		
		//提示
		private var suggest:MapLine = new MapLine();
		
		//当前画线的点数组
		private var currentPointAry:HashArray = new HashArray();
		
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
		
		private static const HIT_DVALUE_POINT:Point = new Point(4,4);
		
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
			
			//体积碰撞检测类
			this.hitTest = new HitTest(new Point(this.width,this.height),new Point(10,10));
			
			//点管理器
			this.manager = new MapPointsManager(new Point(this.width,this.height));
			
			//显示对象层
			this.addChild(backLayer);//背影
			this.addChild(mapsLayer);//区块
			this.addChild(linesLayer);//点线
			this.addChild(viewLayer);//提示
			this.addChild(penLayer);//画笔
			
			//显示对象
			this.penLayer.addChild(this.pen);//画笔
			this.pen.visible = false;
			
			this.backLayer.addChild(this.back);//背影
			this.back.width = this.width;
			this.back.height = this.height;
			this.back.refresh();	
			
			this.viewLayer.addChild(this.suggest);//提示
			this.suggest.pointColor = VIEW_COLOR;
			this.suggest.lineColor = VIEW_COLOR;
			this.suggest.pointFillColor = VIEW_FILL_COLOR;
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
		 * 事件 MOUSE_OVER
		 * @param e
		 * 
		 */		
		private function handlerMouseOverWorkSpace(e:Event):void{
			if(this.toolEventType == null || this.toolEventType != ToolsBar.TOOL_TYPE_LINE){
				return;
			}
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
			if(this.toolEventType == null || this.toolEventType != ToolsBar.TOOL_TYPE_LINE){
				return;
			}
			var mousep:Point = new Point(pen.x,pen.y);
			
			//画笔状态
			if(this.pen.penState == Pen.PEN_STATE_START){//画笔状态是开始画：起点未画，末点未画
				this.pen.penState = Pen.PEN_STATE_DOING;
			}
			else if(this.pen.penState == Pen.PEN_STATE_DOING) {//画笔状态是正在画：起点画完，末点未画
				mousep = this.suggest.endPoint;
			}
			
			var pstate:MapPointManagerState = this.manager.addPoint(mousep); 
			var hitp:Point = pstate.hitPoint;
			
			//如果当前要画的点是闭合、碰撞、正常状态
			if(pstate.isState(MapPointManagerState.IS_CLOSE) 
				|| pstate.isState(MapPointManagerState.IS_NORMAL) 
				|| pstate.isState(MapPointManagerState.IS_HIT)){//画笔状态，如果能继续画
				
				//把画线添加到线层
				var ml:MapLine = new MapLine(this.suggest.startPoint,this.suggest.endPoint,VIEW_COLOR,VIEW_COLOR,VIEW_FILL_COLOR);
				this.linesLayer.addChild(ml);
				
				//如果当前要画的点是闭合状态
				if(pstate.isState(MapPointManagerState.IS_CLOSE)){//如果当前链已关闭
					
					//初始化提示 view 和  画笔 pen
					this.pen.penState = Pen.PEN_STATE_START;
					this.suggest.startPoint = null;
					this.suggest.endPoint = null;
					this.suggest.refresh();
					
					//画区块
					var hpa:HashArray = this.manager.findLatestClosedPointArray();
					var paa:Array = new Array();
					var pa:Array = hpa.getArray();
					paa.push(pa);
					var ma:MapArea = new MapArea(paa,AREA_LINE_COLOR,AREA_FILL_COLOR);
					ma.refresh();
					this.mapsLayer.addChild(ma);
					this.addMapAreaEvent(ma);
					
					//删除画出的线
					MapUtil.deleteAllChild(this.linesLayer);
				}
				else{//如果当前链没有关闭
					this.suggest.startPoint = hitp;
					this.suggest.endPoint = hitp;
					this.suggest.refresh();
				}
			}
		}
		
		/**
		 * 事件 MOUSE_MOVE
		 * @param e
		 * 
		 */		
		private function handlerMouseMoveWorkSpase(e:Event):void{
			if(this.toolEventType == null || this.toolEventType != ToolsBar.TOOL_TYPE_LINE){
				return;
			}
			//获得当前鼠标坐标，给画笔置位置
			var mousep:Point = new Point(this.mouseX,this.mouseY);
			this.pen.x = mousep.x;
			this.pen.y = mousep.y;
			
			//当前点状态
			var pstate:MapPointManagerState = this.manager.hitTestPoint(mousep); 
			var hitp:Point = pstate.hitPoint;//检测返回结果点
			
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
			
			if(this.pen.penState == Pen.PEN_STATE_DOING){//画笔状态是正在画：起点画完，末点未画
				this.suggest.endPoint = hitp;
				this.suggest.refresh();
			}
		}
		
		/**
		 * 事件 MOUSE_OUT
		 * @param e
		 * 
		 */		
		private function handlerMouseOutWorkSpase(e:Event):void{
			if(this.toolEventType == null || this.toolEventType != ToolsBar.TOOL_TYPE_LINE){
				return;
			}
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
			}
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
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerMapAreaMouseOver(e:Event):void{
			if(this.toolEventType == null || this.toolEventType != ToolsBar.TOOL_TYPE_SELECT){
				return;
			}
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


	}
}