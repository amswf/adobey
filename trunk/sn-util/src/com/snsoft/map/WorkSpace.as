﻿package com.snsoft.map{
	import com.snsoft.map.util.HashArray;
	import com.snsoft.map.util.HitTest;
	import com.snsoft.map.util.MapUtil;
	
	import fl.core.UIComponent;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Transform;
	import flash.ui.Mouse;
	import flash.utils.getDefinitionByName;
	
	/**
	 * 工作区 
	 * @author Administrator
	 * 
	 */	
	public class WorkSpace extends UIComponent {
		//碰撞检测的坐标差值域
		private static var hitTestDValue:Point = new Point(5,5);
		
		//画笔类型遇到已存在点时，皮夫MC的类名。
		private static var PEN_TYPE_LINE_POINT:String = "PenLinePointSkin";
		
		//画笔类型，皮夫MC的类名。
		private static var PEN_TYPE_LINE:String = "PenLineSkin";
		
		//点的显示MC
		private static var POINT_SKIN:String = "PointSkin";
		
		//红点的显示MC
		private static var POINT_RED_SKIN:String = "PointRedSkin";
		
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
		
		//画操作时起始点
		private var startPoint:Point = new Point(0,0);
		
		//当前画线的点数组
		private var currentPointAry:HashArray = new HashArray();
		
		//所有点的数组的数组
		private var pointAryAry:Array = new Array();
		
		//碰撞检测类对象
		private var hitTest:HitTest = null;
		
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
		private function init():void {
			
			
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
		private function handlerMouseMoveWorkSpase(e:Event):void {
			var p:Point = this.createMousePoint(this);
			this.setSpriteXY(this.penSkin,p);
			
			//获得碰撞点，和现有点非常接近时，就定位到它，形成闭合的点链。
			var pht:Point = this.findHitPoint(p);
			if (pht != null && ! pht.equals(this.startPoint)) {
				p = pht;
				refreshPenSkin(PEN_TYPE_LINE_POINT);
			}
			else {
				refreshPenSkin(this.penType);
			}
			if (this.penState == PEN_STATE_DOING) {
				refreshViewMC(this.startPoint,p);
			}
			
		}
		
		
		/**
		 * 鼠标事件 MouseOver
		 * @param e
		 * 
		 */
		private function handlerMouseOverWorkSpace(e:Event):void {
			
			Mouse.hide();
			refreshPenSkin(this.penType);
		}
		
		
		/**
		 * 鼠标事件 MouseClick
		 * @param e
		 * 
		 */
		private function handerMouseClickWorkSpace(e:Event):void {
			
			//获得鼠标相对工作区域的坐标
			var p:Point = this.createMousePoint(this);
			
			//获得碰撞点，和现有点非常接近时，就定位到它。
			var pht:Point = this.findHitPoint(p);
			var sign = true;
			if(pht != null){
				var cpafp:Point = this.currentPointAry.findByIndex(0) as Point;
				var phn:String = this.createPointHashName(pht);
				var hp:Point = this.currentPointAry.find(phn) as Point;
				if(cpafp != null && hp == null && !cpafp.equals(pht)){
					sign = false;
				}
			}
			if(sign){
				if (pht != null) {
					p = pht;
				}
				
				//创建要显示的点皮肤
				var ps:MovieClip = this.createPointSkin(p,POINT_RED_SKIN);
				
				//把点皮肤显示出来
				this.pointSkinsMC.addChild(ps);
				
				
				if (this.penState == PEN_STATE_START) {//画笔为开始状态时
					this.currentPointAry = new HashArray();
					
					//设置画笔状态
					this.penState = PEN_STATE_DOING;
				}
				else if (this.penState == PEN_STATE_DOING) {//画笔结束时
					var mu:MapUtil = new MapUtil();
					var shape:Shape = mu.drawLine(this.startPoint,p,0xff0000);
					var line:MovieClip = new MovieClip();
					line.addChild(shape);
					this.linesMC.addChild(line);
				}
				
				//添加点到碰撞检测中
				this.hitTest.addPoint(p);
				
				//把初始点放入当前点数组中
				this.putPointToHashArray(this.currentPointAry,p);
				
				//设置开始点
				this.startPoint = p;
				
				//闭合链
				if(this.currentPointAry.length > 2){
					//放入链的数组中
					var fp:Point = this.currentPointAry.findByIndex(0) as Point;
					if(fp != null && fp.equals(p)){
						this.pointAryAry.push(this.currentPointAry);
						this.penState = PEN_STATE_START;
						this.startPoint = new Point(0,0);
						tracePointAryAry();
						changePointSkinAndLineSkinColor();
					}
					//
				}
			}
		}
		
		/**
		 * 改变已画出的点的颜色 
		 * @param color
		 * 
		 */		
		private function changePointSkinAndLineSkinColor():void{
			var lmc:MovieClip = this.linesMC;
			var pmc:MovieClip = this.pointSkinsMC;
			var pmcnc:int = pmc.numChildren;
			for(var i:int =0;i<pmcnc;i++){
				var mc:MovieClip = pmc.getChildAt(i) as MovieClip;
				var nmc:MovieClip = this.createPointSkin(new Point(mc.x,mc.y),POINT_SKIN);
				pmc.addChild(nmc);
			}
			
			for(var i:int =0;i<pmcnc;i++){
				pmc.removeChildAt(0);
			}
			for(var i:int =0;i<lmc.numChildren;i++){
				var mc:MovieClip = lmc.getChildAt(i) as MovieClip;
				this.setPointSkinColor(mc);
				mc = nmc;
			}
		}
		
		private function setPointSkinColor(mc:MovieClip):void{
			var trfm:Transform = mc.transform;
			var ctrfm:ColorTransform = trfm.colorTransform;
			ctrfm.alphaMultiplier = 1;
			ctrfm.alphaOffset = 255;
			ctrfm.blueMultiplier = 1;
			ctrfm.blueOffset = -255;
			ctrfm.greenMultiplier = 1;
			ctrfm.greenOffset = -255;
			ctrfm.redMultiplier = 1;
			ctrfm.redOffset = -255;
			trfm.colorTransform = ctrfm;
			mc.transform = trfm;
		}	
		
		/**
		 * 把点放到hash表中 
		 * @param hary
		 * @param point
		 * 
		 */
		public function putPointToHashArray(hary:HashArray,...point):void {
			if (hary != null) {
				var pary:Array = point;
				if (pary != null) {
					for (var i:int = 0; i<pary.length; i++) {
						var p:Point = pary[i] as Point;
						if (p != null) {
							var hname:String = this.createPointHashName(p);
							hary.put(hname,p);
						}
					}
				}
			}
		}
		
		public function createPointHashName(point:Point):String {
			var str:String = String(point.x) + "|" + String(point.y);
			return str;
		}
		
		/**
		 * 刷新画笔图标 
		 * @param penSkin
		 * 
		 */
		private function refreshPenSkin(penSkin:String):void {
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
		private function refreshViewMC(startPoint:Point,endPoint:Point):void {
			var mu:MapUtil = new MapUtil();
			var shape:Shape = mu.drawLine(startPoint,endPoint,0xff0000);
			var mc:MovieClip = new MovieClip();
			mc.addChild(shape);
			this.refreshChild(this.viewMC,mc);
		}
		
		
		/**
		 * 设置MC鼠标不可用 
		 * @param mc
		 * @param type
		 * 
		 */
		private function putMouseEnable(mc:Sprite,type:Boolean = false):void {
			mc.mouseEnabled = type;
			mc.mouseChildren = type;
		}
		
		
		/**
		 * 碰撞检测，如果找到碰撞物体，返回它的坐标。 
		 * @return 
		 * 
		 */
		private function findHitPoint(p:Point):Point {
			var op:Point = this.hitTest.findPoint(p,hitTestDValue);
			return op;
		}
		
		
		/**
		 * 创建点皮肤 
		 * @param point
		 * @return 
		 * 
		 */
		private function createPointSkin(point:Point,skin:String):MovieClip {
			var pointSkin:MovieClip = this.createSkinByName(skin);
			this.setSpriteXY(pointSkin,point);
			return pointSkin;
		}
		
		
		/**
		 * 创建鼠标相对某个MC所在位置的点坐标 
		 * @param mc
		 * @return 点坐标
		 * 
		 */
		private function createMousePoint(mc:Sprite):Point {
			if (mc != null) {
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
		private function setSpriteXY(sprite:Sprite,point:Point):void {
			if (point != null && sprite != null) {
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
		private function refreshChild(mc:MovieClip,...childMC):void {
			
			if (mc != null && childMC != null) {
				var n:int = mc.numChildren;
				for (var i:int = 0; i<n; i++) {
					mc.removeChildAt(i);
				}
				for (var j:int = 0; j<childMC.length; j++) {
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
		
		
		/**
		 * 把一个hash按照hash里的起点和终点拆分相关的链
		 * 
		 * 当前链的中间点不可能在链上
		 * 
		 * 当前链起点是否在其它链上
		 * 
		 * 当前链的结束点是否在本链上，是否在其它链上
		 * 
		 * 
		 * @param hary
		 * @param chary
		 * @return 
		 * 
		 */		 
		private function breakPointHashArray(pointHashAryAry:Array,currentHashAry:HashArray):Array{
			
			var haryAry:Array = new Array();
			if(currentHashAry != null && pointHashAryAry != null){
				
				var cary:Array = currentHashAry.getArray();
				
				var p1:Point = cary[0];
				var p2:Point = cary[cary.length - 1];
				
				var p1haa:Array = this.findHashArrayAryByPoint(p1);
				var p2haa:Array = this.findHashArrayAryByPoint(p2);
				
				//未完成，太复杂了！！！！
			}
			return haryAry;
		}
		
		/**
		 * 查找所有包含指定点的链，返回链的数组 
		 * @param point
		 * 
		 */		
		private function findHashArrayAryByPoint(point:Point):Array{
			var ary:Array = new Array();
			var haa:Array = this.pointAryAry;
			var sign:Boolean = false;
			if(haa != null && haa.length > 0){
				for(var i:int =0;i<haa.length;i++){
					var ha:HashArray = haa[i] as HashArray;
					if(ha != null){
						
						var name:String = this.createPointHashName(point);
						var p:Point = ha.find(name) as Point;
						if(p != null){
							ary.push(ha);
							sign = true;
						}
					}
				}
			}
			if(sign){
				return ary;
			}
			else{
				return null;
			}
		}
		
		
		/**
		 * 判断一个hash是否在另一个hash围成的图形里面 
		 * @param hary1
		 * @param hary2
		 * @return 
		 * 
		 */		
		private function hashArrayInHashArray(hary1:HashArray,hary2:HashArray):Boolean{
			if(hary1 != null && hary2 != null){
				
				var ary1:Array = hary1.getArray();
				var ary2:Array = hary2.getArray();
				
				var mu:MapUtil = new MapUtil();
				
				if( ary1 != null && ary2 != null){
					return mu.checkShapeSurround(ary2,ary1);
				}
			}
			return false;
		}
		
		/**
		 * 判断hashArray的点列表是不是闭合的即首尾点是不是相同 
		 * @param hary
		 * @return 
		 * 
		 */		
		private function isCloseArray(ary:Array):Boolean{
			if(ary != null){
				var p1:Point = ary[0] as Point;
				var p2:Point = ary[ary.length -1] as Point;
				if(p1 != null && p2 != null && p1.equals(p2)){
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 把一个Array 按照两个下标截取数组存到HashArray 
		 * @param ary
		 * @param index1
		 * @param index2
		 * @return 
		 * 
		 */		
		private function findSubPointHashArray(ary:Array,index1:int,index2:int):HashArray{
			var hary:HashArray = new HashArray();
			if(ary != null && 0 <=index1 && index1 < ary.length && 0 <=index2 && index2 < ary.length ){
				if(this.isCloseArray(ary)){
					for(var i:int = 0;i<ary.length +1;i++){
						var p:Point = ary[index1] as Point;
						if(p != null){
							var name:String = this.createPointHashName(p);
							hary.put(name,p);
						}
						index1 ++;
						index1 = index1 % ary.length;
						if(index1 == index2){
							break;
						}
					}
				}
				else {
					if(index1 < index2){
						for(var i:int = index1;i<=index2;i++){
							var p:Point = ary[i] as Point;
							if(p != null){
								var name:String = this.createPointHashName(p);
								hary.put(name,p);
							}
						}
					}
				}
			}
			return hary;
		}
		
		private function tracePointAryAry():void{
			for(var i:int =0;i<this.pointAryAry.length;i++){
				var ha:HashArray = this.pointAryAry[i] as HashArray;
				if(ha != null){
					trace(ha.getArray());
				}
			}
		}
	}
}