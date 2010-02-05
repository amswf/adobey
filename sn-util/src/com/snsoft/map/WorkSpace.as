package com.snsoft.map{
	import com.snsoft.map.util.HashArray;
	import com.snsoft.map.util.HitTest;
	import com.snsoft.map.util.MapUtil;
	
	import fl.core.UIComponent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
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
		
		//闭合线框层Layer**************************************************************************************************************************
		private var closeFoldLinesLayer:MovieClip = new MovieClip();
		
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
		
		private static const AREA_LINE_COLOR:uint = 0x0000ff;
		
		private static const AREA_FILL_COLOR:uint = 0xffff00;
		
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
			var mousep:Point = new Point(pen.x,pen.y);
			var cpa:HashArray = this.currentPointAry;
			
			//画笔状态
			if(this.pen.penState == Pen.PEN_STATE_START){//画笔状态是开始画：起点未画，末点未画
				this.pen.penState = Pen.PEN_STATE_DOING;
			}
			else if(this.pen.penState == Pen.PEN_STATE_DOING) {//画笔状态是正在画：起点画完，末点未画
				mousep = this.suggest.endPoint;
			}
			
			//判断闭合
			var isClose:Boolean = false;
			if(cpa.length >=3){//最少3个点组成一个区块
				var firstp:Point = cpa.findByIndex(0)as Point;
				if(hitTest.isHit2Point(mousep,firstp,this.hitTestDValue)){
					isClose = true;
				}
			}
			
			//判断是否与现有点碰撞
			var isHit:Boolean = false;
			var pht:Point = this.hitTest.findPoint(mousep,HIT_DVALUE_POINT);
			if (pht != null) {
				mousep = pht;
			}
			
			//提示
			if(pen.isCanDraw){//画笔状态，如果能继续画
				//把画线添加到线层
				var ml:MapLine = new MapLine(this.suggest.startPoint,this.suggest.endPoint,VIEW_COLOR,VIEW_COLOR,VIEW_FILL_COLOR);
				this.linesLayer.addChild(ml);
				
				var keyName:String = MapUtil.createPointHashName(mousep);//获得当前所画点的hash名称
				this.currentPointAry.put(keyName,mousep);//把点添加到当前链中
				this.hitTest.addPoint(mousep);//把点注册到碰撞检测
				
				if(isClose){//如果当前链已关闭
					
					//初始化提示 view 和  画笔 pen
					this.pen.penState = Pen.PEN_STATE_START;
					this.suggest.startPoint = null;
					this.suggest.endPoint = null;
					this.suggest.refresh();
					
					//画区块
					var paa:Array = new Array();
					var pa:Array = cpa.getArray();
					paa.push(pa);
					var ma:MapArea = new MapArea(paa,AREA_LINE_COLOR,AREA_FILL_COLOR);
					ma.refresh();
					this.mapsLayer.addChild(ma);
					
					//刷新闭合链的颜色
					MapUtil.deleteAllChild(this.linesLayer);
					
					//把当前链添加到链的数组中，并清空当前链
					this.pointAryAry.push(cpa);
					this.currentPointAry = new HashArray();
					
					//测试，最后删除本行
					this.tracePointAryAry(this.pointAryAry);
				}
				else{//如果当前链没有关闭
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
			
			//获得当前鼠标坐标，给画笔置位置
			var mousep:Point = new Point(this.mouseX,this.mouseY);
			this.pen.x = mousep.x;
			this.pen.y = mousep.y;
			
			//获得碰撞点
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
			if(cpa.length >0){
				for(var i:int = 0;i<cpa.length;i++){ 
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
			
			if(isClose) {//如果闭合链了
				mousep = cpap;
				pen.isCanDraw = true;
				this.pen.penSkin = Pen.PEN_LINE_CLOSE_SKIN;
				this.pen.refresh();
			}
			else if(isInCpa){//如果在当前链上，且不闭合
				this.pen.isCanDraw = false;
				this.pen.penSkin = Pen.PEN_LINE_UNABLE_SKIN;
				this.pen.refresh();
			}
			else if (isHit) {//如果碰撞了，但不在当前链上
				mousep = pht;
				pen.isCanDraw = true;
				this.pen.penSkin = Pen.PEN_LINE_POINT_SKIN;
				this.pen.refresh();
			}
			else {//其它情况
				pen.isCanDraw = true;
				this.pen.penSkin = Pen.PEN_LINE_DEFAULT_SKIN;
				this.pen.refresh();
			}
			
			if(this.pen.penState == Pen.PEN_STATE_DOING){//画笔状态是正在画：起点画完，末点未画
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