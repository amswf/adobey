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
		
		//所有点的数组的数组
		private var pointAryAry:Array = new Array();
		
		private static const VIEW_COLOR:uint = 0xff0000;
		
		private static const VIEW_FILL_COLOR:uint = 0xffffff;
		
		private static const LINE_COLOR:uint = 0xff0000;
		
		private static const LINE_FILL_COLOR:uint = 0xffffff;
		
		private static const HIT_DVALUE_POINT:Point = new Point(4,4);
		
		/**
		 * 构造方法 
		 * 
		 */
		public function WorkSpace() {
			super();
			init();
		}
		
		/**
		 * 初始化 
		 * 
		 */		
		public function init():void{
			//体积碰撞检测类
			this.hitTest = new HitTest(new Point(this.width,this.height),new Point(10,10));
			
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
			//点线
			if(this.pen.penState == Pen.PEN_STATE_START){
				this.pen.penState = Pen.PEN_STATE_DOING;
			}
			else if(this.pen.penState == Pen.PEN_STATE_DOING) {
				var ml:MapLine = new MapLine(this.suggest.startPoint,this.suggest.endPoint,VIEW_COLOR,VIEW_COLOR,VIEW_FILL_COLOR);
				this.linesLayer.addChild(ml);
			}
			
			var mousep:Point = new Point(pen.x,pen.y);
			
			var cpa:HashArray = this.currentPointAry;
			var isClose:Boolean = false;
			if(cpa.length >=3){
				var firstp:Point = cpa.findByIndex(0)as Point;
				if(hitTest.isHit2Point(mousep,firstp,this.hitTestDValue)){
					isClose = true;
				}
			}
			
			//提示
			if(pen.isCanDraw){
				var keyName:String = MapUtil.createPointHashName(mousep);
				this.currentPointAry.put(keyName,mousep);
				if(isClose){
					this.pen.penState = Pen.PEN_STATE_START;
					this.suggest.startPoint = null;
					this.suggest.endPoint = null;
					this.suggest.refresh();
					this.pointAryAry.push(this.currentPointAry);
					this.currentPointAry = new HashArray();
					this.tracePointAryAry(this.pointAryAry);
				}
				else{
					this.suggest.startPoint = mousep;
					this.suggest.endPoint = mousep;
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
			var mousep:Point = new Point(this.mouseX,this.mouseY);
			this.pen.x = mousep.x;
			this.pen.y = mousep.y;
			
			var pht:Point = this.hitTest.findPoint(mousep,HIT_DVALUE_POINT);
			var cpa:HashArray = this.currentPointAry;
			
			//判断闭合
			var cpap:Point = null;
			var isClose:Boolean = false;
			if(cpa.length >=3){
				var firstp:Point = cpa.findByIndex(0)as Point;
				if(hitTest.isHit2Point(mousep,firstp,this.hitTestDValue)){
					isClose = true;
					cpap = firstp;
				}
			}
			
			//判断点是否在当前链上，不包括开始点
			var isInCpa:Boolean = false;
			if(cpa.length >=3){
				for(var i:int = 1;i<cpa.length;i++){ 
					var p:Point = cpa.findByIndex(i)as Point;
					if(hitTest.isHit2Point(mousep,p,this.hitTestDValue)){
						isInCpa = true;
						break;
					}
				}
			}
			
			//判断是否碰撞
			var isHit:Boolean = false;
			if (pht != null) {
				isHit = true;
			}
			
			if(isClose) {
				mousep = cpap;
				pen.isCanDraw = true;
				this.pen.penSkin = Pen.PEN_LINE_CLOSE_SKIN;
				this.pen.refresh();
			}
			else if(isInCpa){
				this.pen.isCanDraw = false;
				this.pen.penSkin = Pen.PEN_LINE_UNABLE_SKIN;
				this.pen.refresh();
			}
			else if (isHit) {
				mousep = pht;
				pen.isCanDraw = true;
				this.pen.penSkin = Pen.PEN_LINE_POINT_SKIN;
				this.pen.refresh();
			}
			else {
				pen.isCanDraw = true;
				this.pen.penSkin = Pen.PEN_LINE_DEFAULT_SKIN;
				this.pen.refresh();
			}
			
			if(this.pen.penState == Pen.PEN_STATE_DOING){
				this.suggest.endPoint = mousep;
				this.suggest.refresh();
			}
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
		 * 测试帮助 
		 * 
		 */		
		private function tracePointAryAry(pointAryAry:Array):void{
			for(var i:int =0;i<pointAryAry.length;i++){
				var ha:HashArray = pointAryAry[i] as HashArray;
				if(ha != null){
					trace(ha.getArray());
				}
			}
		}
	}
}