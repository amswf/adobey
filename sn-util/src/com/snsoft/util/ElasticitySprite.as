package com.snsoft.util
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;

	public class ElasticitySprite
	{
		
		/**
		 * 弹性运动主动对象 
		 */		
		 
		private var mainSprite:DisplayObject = null;
		
		private var passiveSprite:Sprite = null;
		
		/**
		 * 当前被动对象 x坐标是否弹性运动 
		 */				
		private var xelst:Boolean = true;
		
		/**
		 * 当前被动对象 y坐标是否弹性运动 
		 */	
		private var yelst:Boolean = true;
		
		/**
		 * 弹行运动实现计时器 
		 */		
		private var timer:Timer = null;
		
		/**
		 * 主对象类型： mouse/sprite 
		 */		
		private var elstType:String = null;
		
		/**
		 * 处理事件时加速判断 sprite
		 */		
		private var elstTypeSprite:Boolean = false;
		
		/**
		 * 处理事件时加速判断 mouse
		 */			
		private var elstTypeMouse:Boolean = false;
		
		/**
		 * 弹性运动主对象类型：元件
		 */		
		private var ELST_TYPE_SPRITE = "SPRITE";
		
		/**
		 * 弹性运动主对象类型：鼠标
		 */
		private var ELST_TYPE_MOUSE = "MOUSE";
		
		/**
		 * 主对象的坐标 X 
		 */		
		private var mainX:Number = 0;
			
		/**
		 * 主对象的坐标 Y 
		 */
		private var mainY:Number = 0;
		
	
		/**
		 * 构造方法 
		 * 
		 */		
		public function ElasticitySprite(mainSprite:DisplayObject,passiveSprite:Sprite,elstType:String = "SPRITE",xelst:Boolean = true,yelst:Boolean = true)
		{
			if(mainSprite != null && passiveSprite != null){
				
				//设置属性
				this.mainSprite = mainSprite;
				this.passiveSprite = passiveSprite;
				this.elstType = elstType.toUpperCase();
				if(this.elstType == this.ELST_TYPE_MOUSE){
					this.elstTypeMouse = true;
				}
				else if(this.elstType == this.ELST_TYPE_SPRITE){
					this.elstTypeSprite = true;
				}
				
				//如果主对象是鼠标，那么要注册下面事件，实时把鼠标坐标记录下来
				if(this.elstTypeMouse){
					var stage:Stage = this.passiveSprite.stage;
					if(stage != null){
						stage.addEventListener(MouseEvent.MOUSE_MOVE,handlerElasticityMouseMove);
					}
				}
				
				//添加定时器
				this.timer = new Timer(10,0);
				timer.start();
				timer.addEventListener(TimerEvent.TIMER,handlerElasticityTimer);
			}
		}
		
		/**
		 * 鼠标移动事件 
		 * @param e
		 * 
		 */		
		private function handlerElasticityMouseMove(e:Event):void{
			this.setMouseMovePoint();
		}
		
		/**
		 * 设置鼠标坐标 
		 * 
		 */		
		private function setMouseMovePoint():void{
			if(this.mainSprite != null){
				this.mainX = this.mainSprite.mouseX;
				this.mainY = this.mainSprite.mouseY;
			}
		}
		
		/**
		 * 定时器定时处理事件
		 * @param e
		 * 
		 */		
		private function handlerElasticityTimer(e:Event):void
		{
			this.elasticity();
		}
		
		
		/**
		 * 弹性运动主方法 
		 * 
		 */		
		private function elasticity():void
		{
			
			if(this.elstTypeSprite){
				mainX = this.mainSprite.x;
				mainY = this.mainSprite.y;
			}
			
			if(mainSprite != null && passiveSprite != null){
				if(this.yelst){
					var pY:Number = mainY - this.passiveSprite.y;
					var plusY:Number = 0;
					if (pY >= 0) {
						plusY = 1;
					}
					else {
						plusY = -1;
					}
					var vY:Number = Math.abs(pY) * 0.05;
					if (vY < 0.1) {
						vY = 0.1;
					}
					if (-0.1 < pY && pY < 0.1) {
						this.passiveSprite.y = mainY;
					}
					else {
						this.passiveSprite.y += vY * plusY;
					}
				}
				if(this.xelst){
					var pX:Number = mainX - this.passiveSprite.x;
					var plusX:Number = 0;
					if (pX >= 0) {
						plusX = 1;
					}
					else {
						plusX = -1;
					}
					var vX:Number = Math.abs(pX) * 0.05;
					if (vX < 0.1) {
						vX = 0.1;
					}
					if (-0.1 < pX && pX < 0.1) {
						this.passiveSprite.x = mainX;
					}
					else {
						this.passiveSprite.x += vX * plusX;
					}
				}
			}
		}
	}
}