package com.snsoft.core
{
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	import fl.events.ComponentEvent;
	
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class DynamicScrollPane extends UIComponent
	{
		/**
		 *滚动框宽度 
		 */		
		private var _paneWidth:Number = 0;
		
		/**
		 *滚动框高度 
		 */		
		private var _paneHeight:Number = 0;
		
		/**
		 *滚动显示的对象 
		 */		
		private var _scrollSprite:Sprite;
		
		
		/**
		 *向上滚动按钮 
		 */		
		private var scrollUpBtn:SimpleButton;
		
		/**
		 *向下滚动按钮 
		 */		
		private var scrollDownBtn:SimpleButton;
		
		/**
		 *拖动按钮 
		 */		
		private var scrollDragBtn:SimpleButton;
		
		/**
		 *滚动遮罩 
		 */		
		private var scrollMask:Sprite;
		
		/**
		 *拖动条背景 
		 */		
		private var scrollDragBack:Sprite;
		
		/**
		 *滚动按钮鼠标按下时鼠标Y坐标和滚动按钮Y坐标的差值 
		 */		
		private var mouseDownPY:Number = 0;
		
		/**
		 *拖动按钮是否按下的标记 
		 */		
		private var scrollMouseDown:Boolean = false;
		
		/**
		 *拖动按钮按下状态时，记录鼠标的Y坐标 
		 */		
		private var ary:Array = new Array();
		
		/**
		 * scrollSprite 更新Y坐标的定时器 
		 */		
		private var timerScroll:Timer = new Timer(12,0);
		
		
		private var thisHeight:Number = 0;
		
		/**
		 * 
		 */		
		private var timer:Timer;
		
		/**
		 * 构造方法 
		 * 
		 */	
		public function DynamicScrollPane(){
			super();
			this.invalidate(InvalidationType.SIZE) as Sprite;
			this.addEventListener(ComponentEvent.RESIZE,handlerResize) as Sprite;
			this.addEventListener(Event.ENTER_FRAME,handlerEnterFrame) as Sprite;
			this.scrollUpBtn = this.getDisplayObjectInstance("ScrollUpButton") as SimpleButton;
			this.scrollDownBtn = this.getDisplayObjectInstance("ScrollDownButton") as SimpleButton;
			this.scrollDragBtn = this.getDisplayObjectInstance("ScrollDragButton") as SimpleButton;
			this.scrollDragBack = this.getDisplayObjectInstance("ScrollDragBack") as Sprite;
			this.scrollMask = this.createAccessorySprite(this.width,this.height) as Sprite;
			
			
		}
		
		/**
		 * 当前项目改变宽高事件 
		 * @param e
		 * 
		 */		
		private function handlerResize(e:Event):void{
			this.refeshList();
		}
		
		/**
		 * 当前项目进跳入帧事件 
		 * @param e
		 * 
		 */		
		private function handlerEnterFrame(e:Event):void{
			//删除监听器
			try{
				this.removeEventListener(Event.ENTER_FRAME,handlerEnterFrame);
			}
			catch(e:Error){
			}
			//向上按钮
			if(this.scrollUpBtn != null){
				this.addChild(this.scrollUpBtn);
				
				//向上按钮MOUSE_OVER事件
				this.scrollUpBtn.addEventListener(MouseEvent.MOUSE_OVER,handlerBtnUpMouseOver);
				this.scrollUpBtn.addEventListener(MouseEvent.MOUSE_OUT,handlerBtnUpMouseOut);
			}
			
			//向下按钮
			if(this.scrollDownBtn != null){
				this.addChild(this.scrollDownBtn);
				
				//向下按钮MOUSE_OVER事件
				this.scrollDownBtn.addEventListener(MouseEvent.MOUSE_OVER,handlerBtnDownMouseOver);
				this.scrollDownBtn.addEventListener(MouseEvent.MOUSE_OUT,handlerBtnDownMouseOut);
			}
			
			//滚动按钮背景
			if(this.scrollDragBack != null){
				this.addChild(this.scrollDragBack);
			}
			
			//滚动按钮
			if(this.scrollDragBtn != null){
				this.addChild(this.scrollDragBtn);
				//滚动按钮MOUSE_DOWN事件
				this.scrollDragBtn.addEventListener(MouseEvent.MOUSE_DOWN,handlerBtnScroMouseDown);
				this.stage.addEventListener(MouseEvent.MOUSE_UP,handlerBtnScroMouseUp);
			}
			
			//滚轮滚动事件
			this.addEventListener(MouseEvent.MOUSE_WHEEL,handlerMouseWheel);
			
			//scrollSprite 更新坐标定时器事件
			timerScroll.addEventListener(TimerEvent.TIMER,handlerTimerScroll);
			timerScroll.start();
			//滚动项目及遮罩
			if(this.scrollSprite != null && this.scrollMask != null){
				this.addChild(this.scrollSprite);
				this.addChild(this.scrollMask);
				this.scrollSprite.mask = this.scrollMask;
			}
			this.refeshList();
		}
		
		/**
		 * 刷新显示列表 
		 * @return 
		 * 
		 */		
		public function refeshList():void {
			//
			if(this.scrollUpBtn != null){
				this.scrollUpBtn.x = this.width;
				this.scrollUpBtn.y = 0;
			}
			if(this.scrollDownBtn != null){
				this.scrollDownBtn.x = this.width;
				this.scrollDownBtn.y = this.height;
			}
			if(this.scrollSprite != null){
				if (this.scrollSprite.y < this.scrollMask.y) {
			  		if (this.scrollSprite.y + this.scrollSprite.height < this.scrollMask.y + this.scrollMask.height) {
						var ssy:Number = this.scrollMask.y + this.scrollMask.height - this.scrollSprite.height;
						if(ssy > 0){
							ssy = 0;
						}
						this.scrollSprite.y = ssy;
			  		}
				}
			}
			if(this.scrollDragBtn != null){
				this.scrollDragBtn.x = this.width;
				if(this.scrollSprite != null){
					var by:Number = 0;
					if(this.scrollSprite.height - this.scrollMask.height > 0){
						by = this.scrollSprite.y * (this.scrollDragBtn.height - this.scrollMask.height) / (this.scrollSprite.height - this.scrollMask.height);
						if (by <= this.scrollMask.y) {
							by = this.scrollMask.y;
						}
						else if (by + this.scrollDragBtn.height >= this.scrollMask.height) {
							by = this.scrollMask.height - this.scrollDragBtn.height;
						}
					}
					else {
						by = 0; 
					}
					this.scrollDragBtn.y = by;
				}
			}
			if(this.scrollDragBack != null){
				this.scrollDragBack.x = this.width;
				this.scrollDragBack.y = 0;
				this.scrollDragBack.height = this.height;
			}
			if(this.scrollMask != null){
				this.scrollMask.width = this.width;
				this.scrollMask.height = this.height;
			}
		}
		
		/**
		 * 鼠标滚轮事件 
		 * @param e
		 * 
		 */		
		private function handlerMouseWheel(e:MouseEvent):void{
			if(e.delta > 0){
				scrollText(35);
			}
			else if(e.delta <0 ){
				scrollText(-35);
			}
		}
		
		/**
		 * 向上滚动按钮 MouseOver 事件
		 * @param e
		 * 
		 */		
		private function handlerBtnUpMouseOver(e:Event):void {
			if (! scrollMouseDown) {
		
				try {
					timer.removeEventListener(TimerEvent.TIMER,handlerTimerBtnUpMouseOver);
				} catch (e:Error) {
				}
				timer = new Timer(5,0);
		
				timer.addEventListener(TimerEvent.TIMER,handlerTimerBtnUpMouseOver);
		
				timer.start();
			}
		}
		
		/**
		 * 向上滚动按钮 MouseOut 事件
		 * @param e
		 * 
		 */
		private function handlerBtnUpMouseOut(e:Event):void {
			try {
				timer.removeEventListener(TimerEvent.TIMER,handlerTimerBtnUpMouseOver);
			} catch (e:Error) {
			}
		
		}
		
		/**
		 * 向下滚动按钮 MouseOver 事件
		 * @param e
		 * 
		 */
		private function handlerBtnDownMouseOver(e:Event):void {
			if (! scrollMouseDown) {
				try {
					timer.removeEventListener(TimerEvent.TIMER,handlerTimerBtnUpMouseOver);
				} catch (e:Error) {
				}
				timer = new Timer(5,0);
		
				timer.addEventListener(TimerEvent.TIMER,handlerTimerBtnDownMouseOver);
		
				timer.start();
			}
		}
		
		
		/**
		 * 向下滚动按钮 MouseOut 事件
		 * @param e
		 * 
		 */
		private function handlerBtnDownMouseOut(e:Event):void {
			try {
				timer.removeEventListener(TimerEvent.TIMER,handlerTimerBtnDownMouseOver);
			} catch (e:Error) {
			}
		
		}
		
		
		/**
		 * 拖动按钮 MouseDown 事件
		 * @param e
		 * 
		 */		
		private function handlerBtnScroMouseDown(e:Event):void {
			try {
				stage.removeEventListener(MouseEvent.MOUSE_MOVE,handlerStageMouseMove);
			} catch (e:Error) {
			}
			scrollMouseDown = true;
			mouseDownPY = this.mouseY - this.scrollDragBtn.y;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,handlerStageMouseMove);
		}
		
		
		/**
		 * 拖动按钮 MouseUp 事件
		 * @param e
		 * 
		 */		
		private function handlerBtnScroMouseUp(e:Event):void {
			scrollMouseDown = false;
			try {
				stage.removeEventListener(MouseEvent.MOUSE_MOVE,handlerStageMouseMove);
			} catch (e:Error) {
			}
		}
		
		
		/**
		 * 拖动按钮 MouseDown 状态 下的  MouseMove 事件
		 * @param e
		 * 
		 */		
		private function handlerStageMouseMove(e:Event):void {
		
			var by:Number = this.mouseY - mouseDownPY;
		
			if (by <= this.scrollMask.y) {
				by = this.scrollMask.y;
			}
			else if (by + this.scrollDragBtn.height >= this.scrollMask.height) {
				by = this.scrollMask.height - this.scrollDragBtn.height;
			}
			this.scrollDragBtn.y = by;
			ary.push(this.scrollDragBtn.y);
		
		}
		
		/**
		 * 滚动显示对象
		 * @param e
		 * 
		 */		
		private function handlerTimerScroll(e:Event):void {
			
			if (ary.length > 0 && this.scrollSprite != null) {
				var ty:Number = ary[0];
				ary.splice(0,1);
				
				var tty:Number = ty * (this.scrollSprite.height - this.scrollMask.height) / (this.scrollDragBtn.height - this.scrollMask.height);
				if (tty >= this.scrollMask.y) {
					//trace(">");
					tty = this.scrollMask.y;
				}
				else if (tty + this.scrollSprite.height <= this.scrollMask.x + this.scrollMask.height) {
					//trace("<");
					tty = this.scrollMask.x + this.scrollMask.height - this.scrollSprite.height;
				}
				this.scrollSprite.y = tty;
			}
		}
		
		/**
		 * 向上滚动按钮 MouseOver 事件
		 * @param e
		 * 
		 */		
		private function handlerTimerBtnUpMouseOver(e:Event):void {
		
			if (! scrollText(1)) {
				try {
					timer.removeEventListener(TimerEvent.TIMER,handlerTimerBtnUpMouseOver);
				} catch (e:Error) {
				}
			}
		}
		
		
		/**
		 * 向下滚动按钮 MouseOver 事件
		 * @param e
		 * 
		 */		
		private function handlerTimerBtnDownMouseOver(e:Event):void {
		
			if (! scrollText(-1)) {
				try {
					timer.removeEventListener(TimerEvent.TIMER,handlerTimerBtnDownMouseOver);
				} catch (e:Error) {
				}
			}
		}
		
		/**
		 * 向上向下滚动 
		 * @param type
		 * @return 
		 * 
		 */		
		private function scrollText(type:int):Boolean {
			var boo:Boolean = true;
			if(this.scrollSprite != null){
				var tty:Number = this.scrollSprite.y;
				if (type > 0) {
					//trace("+");
					tty = tty + type;
				}
				else if (type < 0) {
					//trace("-");
					tty = tty + type;
				}
				if (tty >= this.scrollMask.y) {
					//trace(">");
					tty = this.scrollMask.y;
					boo = false;
				}
				else if (tty + this.scrollSprite.height <= this.scrollMask.x + this.scrollMask.height) {
					//trace("<");
					tty = this.scrollMask.x + this.scrollMask.height - this.scrollSprite.height;
					boo = false;
				}
				if(boo){
					this.scrollSprite.y = tty;
					if (this.scrollMask.height - this.scrollSprite.height < 0) {
						this.scrollDragBtn.y = tty * (this.scrollMask.height - this.scrollDragBtn.height) / (this.scrollMask.height - this.scrollSprite.height);
					}
				}
			}
			return boo;
		}
		
		
		/**
		 * 初始化方法 
		 * 
		 */		
		public function init():void{
			
		}
		
		
		/**
		 * 创建一个辅助用的不可见元件用来确定sprite相对位置信息
		 * @param width
		 * @param height
		 * @param visible
		 * @return 
		 * 
		 */
		private function createAccessorySprite(width:Number,height:Number,visible:Boolean = true):MovieClip {

			var uvmc:MovieClip = new MovieClip();
			uvmc.visible = visible;
			var shape:Shape = new Shape();
			var gra:Graphics = shape.graphics;
			gra.beginFill(0x000000,0.1);
			gra.drawRect(0,0,width,height);
			gra.endFill();
			uvmc.addChild(shape);
			return uvmc;
		}
		
		/**
		 * 
		 * @param width
		 * 
		 */			
		public function set paneWidth(width:Number):void{
			this._paneWidth = width;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get paneWidth():Number{
			return this._paneWidth;
		}
		
		/**
		 * 
		 * @param height
		 * 
		 */		
		public function set paneHeight(height:Number):void{
			this._paneHeight = height;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get paneHeight():Number{
			return this._paneHeight;
		}
		
		
		/**
		 * 
		 * @param height
		 * 
		 */		
		public function set scrollSprite(sprite:Sprite):void{
			this._scrollSprite = sprite;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get scrollSprite():Sprite{
			return this._scrollSprite;
		}
	}
}