package com.snsoft.map
{
	import com.snsoft.map.util.HitTest;
	import com.snsoft.map.util.MapUtil;
	
	import fl.core.UIComponent;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.utils.getDefinitionByName;

	public class WorkSpace extends UIComponent
	{
		//碰撞检测的坐标差值域
		private static var hitTestDValue:Point = new Point(5,5);
		
		//画笔类型遇到已存在点时，皮夫MC的类名。
		private static var PEN_TYPE_LINE_POINT:String = "PenLinePointSkin";
		
		//画笔类型，皮夫MC的类名。
		private static var PEN_TYPE_LINE:String = "PenLineSkin";
		
		//点的显示MC
		private static var POINT_SKIN:String = "PointSkin";
		
		//背景MC
		private static var BASE_BACK:String = "BaseBack";
		
		//画笔状态：起始
		private static var PEN_STATE_START:int = 0;
		
		//画笔状态：正在画
		private static var PEN_STATE_DOING:int = 1;
		
		//画笔类型
		private var penType:String = PEN_TYPE_LINE;
		
		//画笔显示对象
		private var penSkin:MovieClip = new MovieClip();
		
		//画笔状态
		private var penState:int = PEN_STATE_START;
		
		//画出的线所在的MC
		private var linesMC:MovieClip = new MovieClip();
		
		//画笔所在的MC
		private var penMC:MovieClip = new MovieClip();
		
		//操作友好显示MC
		private var viewMC:MovieClip = new MovieClip();
		
		//地图分块MC
		private var mapsMC:MovieClip = new MovieClip();
		
		//显示画的点
		private var pointSkinsMC:MovieClip = new MovieClip();
		
		private var currentMousePoint:Point = new Point(0,0);
		
		//画操作时起始点
		private var startPoint:Point = new Point(0,0);
		
		//当前画线的点数组
		private var currentPointAry:Array = new Array();
		
		//所有点的数组的数组
		private var pointAryAry:Array = new Array();
		
		private var hitTest:HitTest = null;
		
		
		public function WorkSpace()
		{
			super();
			init();
		}
		
		/**
		 * 初始化
		 * 
		 */		
		private function init():void{
			
			
			//体积碰撞检测类
			this.hitTest = new HitTest(new Point(this.width,this.height),new Point(10,10));
			
			//初始化各功能显示的分层
			
			//背景
			var baseBack:MovieClip = this.createSkinByName(BASE_BACK);
			baseBack.width = this.width;
			baseBack.height = this.height;
			this.addChild(baseBack);
			
			//地图
			this.addChild(this.mapsMC);
			
			//画出的线
			this.addChild(this.linesMC);
			
			//画出的点
			this.addChild(this.pointSkinsMC);
			
			//操作友好显示
			this.addChild(this.viewMC);
			this.putMouseEnable(this.viewMC,false);
			
			//画笔
			this.addChild(this.penMC);
			
			this.penMC.mouseEnabled = false;
			
			//注册事件 MOUSE_OVER
			this.addEventListener(MouseEvent.MOUSE_OVER,handlerMouseOverWorkSpace);
			
			//注册事件 CLICK
			this.addEventListener(MouseEvent.CLICK,handerMouseClickWorkSpace);
			
			//注册事件 MOUSE_MOVE
			this.addEventListener(MouseEvent.MOUSE_MOVE,handlerMouseMoveWorkSpase);
			
		}
		
		/**
		 * 鼠标事件 MouseMove
		 * @param e
		 * 
		 */		
		private function handlerMouseMoveWorkSpase(e:Event):void{
			var p:Point = this.createMousePoint(this);
			this.setSpriteXY(this.penSkin,p);
			
			//获得碰撞点，和现有点非常接近时，就定位到它，形成闭合的点链。
			var pht:Point = this.findHitPoint(p);
			if(pht != null && !pht.equals(this.startPoint)){
				p = pht;
				refreshPenSkin(PEN_TYPE_LINE_POINT);
			}
			else{
				refreshPenSkin(this.penType);
			}
			if(this.penState == PEN_STATE_DOING){
				refreshViewMC(this.startPoint,p);
			}
			
		}
		
		
		/**
		 * 鼠标事件 MouseOver
		 * @param e
		 * 
		 */		
		private function handlerMouseOverWorkSpace(e:Event):void{
			 
			Mouse.hide();
			refreshPenSkin(this.penType);
		}
		
		/**
		 * 刷新画笔图标 
		 * @param penSkin
		 * 
		 */		
		private function refreshPenSkin(penSkin:String):void{
			var p:Point = this.createMousePoint(this);
			var ps:MovieClip = this.createSkinByName(penSkin);
			ps.mouseEnabled = false;
			ps.buttonMode = false;
			ps.mouseChildren = false;
			this.penSkin = ps;
			this.setSpriteXY(ps,p);
			this.refreshChild(this.penMC,this.penSkin);
		}
		
		/**
		 * 刷新友好提示 
		 * @param penSkin
		 * 
		 */		
		private function refreshViewMC(startPoint:Point,endPoint:Point):void{
			var mu:MapUtil = new MapUtil();
			var shape:Shape = mu.drawLine(startPoint,endPoint,0xff0000);
			var mc:MovieClip = new MovieClip();
			mc.addChild(shape);
			this.refreshChild(this.viewMC,mc);
		}
		
		
		/**
		 * 鼠标事件 MouseClick
		 * @param e
		 * 
		 */		
		private function handerMouseClickWorkSpace(e:Event):void{
			
			//获得鼠标相对工作区域的坐标
			var p:Point = this.createMousePoint(this);
			
			//获得碰撞点，和现有点非常接近时，就定位到它，形成闭合的点链。
			var pht:Point = this.findHitPoint(p);
			if(pht != null && !pht.equals(this.startPoint)){
				p = pht;
			}
			
			//创建要显示的点皮肤
			var ps:MovieClip = this.createPointSkin(p);
			
			//把点皮肤显示出来
			this.pointSkinsMC.addChild(ps);
			
			//画笔为开始状态时
			if(this.penState == PEN_STATE_START){
				
				//把当前的点列表放入点数组的数组，刷新数组列表
				var cpa:Array = this.currentPointAry;
				if(cpa != null && cpa.length >=2){
					this.pointAryAry.push(cpa);
				}
				this.currentPointAry = new Array();
				
				//设置画笔状态
				this.penState = PEN_STATE_DOING;
			}
			else if(this.penState == PEN_STATE_DOING){
				var mu:MapUtil = new MapUtil();
				var shape:Shape = mu.drawLine(this.startPoint,p,0x000000);
				var line:MovieClip = new MovieClip();
				line.addChild(shape);
				this.linesMC.addChild(line);
			}
			
			//碰撞检测
			this.hitTest.addPoint(p);
			
			//设置开始点
			this.startPoint = p;
			
			//把初始点放入当前点数组中
			this.currentPointAry.push(this.startPoint);
			 
		}
		
		/**
		 * 设置MC鼠标不可用 
		 * @param mc
		 * @param type
		 * 
		 */		
		private function putMouseEnable(mc:Sprite,type:Boolean = false):void{
			mc.mouseEnabled = type;
			mc.mouseChildren = type;
		}
		
		/**
		 * 碰撞检测，如果找到碰撞物体，返回它的坐标。 
		 * @return 
		 * 
		 */		
		private function findHitPoint(p:Point):Point{
			var op:Point = this.hitTest.findPoint(p,hitTestDValue);
			return op;
		}
		
		
		/**
		 * 创建点皮肤 
		 * @param point
		 * @return 
		 * 
		 */		
		private function createPointSkin(point:Point):MovieClip{
			var pointSkin:MovieClip = this.createSkinByName(POINT_SKIN);
			this.setSpriteXY(pointSkin,point);
			return pointSkin;
		}
		
		/**
		 * 创建鼠标相对某个MC所在位置的点坐标 
		 * @param mc
		 * @return 点坐标
		 * 
		 */		
		private function createMousePoint(mc:Sprite):Point{
			if(mc != null){
				var p:Point = new Point(mc.mouseX,mc.mouseY);
				return p;
			}
			return null;
		}
		
		/**
		 * 设置物件的坐标
		 * @param sprite
		 * @param point
		 * 
		 */		
		private function setSpriteXY(sprite:Sprite,point:Point):void{
			if(point != null && sprite != null){
				sprite.x = point.x;
				sprite.y = point.y;
			}
		}
		
		/**
		 * 刷新物件的子物件
		 * @param mc
		 * @param childMC
		 * 
		 */		
		private function refreshChild(mc:MovieClip,...childMC):void{
			
			if(mc != null && childMC != null){
				var n:int = mc.numChildren;
				for(var i:int = 0;i<n;i++){
					mc.removeChildAt(i);
				}
				for(var j:int = 0;j<childMC.length;j++){
					mc.addChild(childMC[j]);
				}
			}
		}
		
		/**
		 * 通过皮肤名称动态创建皮肤对象 
		 * @param skinName
		 * @return 
		 * 
		 */		
		private function createSkinByName(skinName:String):MovieClip {
			var main:MovieClip = new MovieClip();
			var mc:MovieClip;
			try {
				var MClass:Class = getDefinitionByName(skinName) as Class;
				mc = new MClass() as MovieClip;
			} catch (e:Error) {
				trace("动态加载找不到类：" +skinName);
			}
			return mc;
		}
				
	}
}