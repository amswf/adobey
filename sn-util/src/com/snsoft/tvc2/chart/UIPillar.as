﻿package com.snsoft.tvc2.chart{
	import com.snsoft.tvc2.Business;
	import com.snsoft.util.text.EffectText;
	import com.snsoft.util.text.TextStyles;
	import com.snsoft.util.TextFieldUtil;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	
	[Style(name="pillar_default_skin", type="Class")]
	
	[Style(name="myTextFormat", type="Class")]
	
	/**
	 * 柱体类 
	 * @author Administrator
	 * 
	 */	
	public class UIPillar extends Business{
		
		private var currentPillar:MovieClip;
		
		private var currentPillarLength:Number;
		
		private var currentPillarParent:Sprite;
		
		private var timer:Timer;
		
		private var isAnimation:Boolean;
		
		private var _transformColor:uint;
		
		private var pillarTextSprite:Sprite;
		
		private var perLen:Number = 2;
		
		private const PERLEN_BASE:Number = 2;
		
		private var charPointDO:CharPointDO;
		
		public function UIPillar(charPointDO:CharPointDO,isAnimation:Boolean = true,pillarTextSprite:Sprite = null,transformColor:uint = 0x000000,delayTime:Number = 0,timeLength:Number = 0,timeOut:Number = 0)	{
			super();
			this.delayTime = delayTime;
			this.timeLength = timeLength;
			this.timeOut = timeOut;
			this.isAnimation = isAnimation;
			this._transformColor = transformColor;			
			this.pillarTextSprite = pillarTextSprite;
			this.charPointDO = charPointDO;
			
			this.currentPillarParent = new Sprite();
			this.addChild(this.currentPillarParent);
		}
		
		public static const PILLAR_DEFAULT_SKIN:String = "pillar_default_skin";
		
		public static const TEXT_FORMAT:String = "myTextFormat";
		
		/**
		 * 
		 */		
		private static var defaultStyles:Object = {
			pillar_default_skin:"Pillar_default_skin",
			myTextFormat:new TextFormat("宋体",13,0x000000)
		};
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public static function getStyleDefinition():Object { 
			return UIComponent.mergeStyles(UIComponent.getStyleDefinition(), defaultStyles);
		}
		
		/**
		 * 
		 * 
		 */				
		override protected function configUI():void{			
			this.invalidate(InvalidationType.ALL,true);
			this.invalidate(InvalidationType.SIZE,true);
			this.width = 400;
			this.height = 300;
			super.configUI();	
		}
		
		/**
		 * 
		 * 
		 */		
		override protected function dispatchEventState():void{
			var sign:Boolean = false;
			if(this.isPlayCmp && this.isTimeLen){
				sign = true;
			}
			else if(this.isTimeOut){
				sign = true;
			}
			
			if(sign){
				timer.stop();
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		/**
		 * 
		 * 
		 */		
		override protected function draw():void{
			
		}
		
		override protected function play():void {
			if(charPointDO != null){
				currentPillar = getDisplayObjectInstance(getStyleValue(PILLAR_DEFAULT_SKIN)) as MovieClip;
				currentPillar.x = charPointDO.point.x;
				currentPillar.y = this.height;
				currentPillar.height = 0;
				currentPillar.width = this.width;
				this.addChild(currentPillar);
				this.currentPillarLength =this.height - charPointDO.point.y;
				timer = new Timer(20,0);
				timer.addEventListener(TimerEvent.TIMER,handlerTimer);
				timer.start();
			}
		}
		
		private function handlerTimer(e:Event):void{
			if(this.charPointDO != null){
				currentPillar.height += perLen;
				if((this.currentPillarLength - currentPillar.height) <= perLen){
					timer.removeEventListener(TimerEvent.TIMER,handlerTimer);
					currentPillar.height = this.currentPillarLength;
					drawPillarText(this.charPointDO);
					this.isPlayCmp = true;
					dispatchEventState();
				}
			}	
		}
		
		/**
		 *  
		 * @param sprite
		 * 
		 */		
		private function drawPillarText(charPointDO:CharPointDO):void{	
			if(pillarTextSprite != null){
				var pt:String = charPointDO.pointText;
				var ptp:Point = charPointDO.pointTextPlace;
				var tfd:TextField = EffectText.creatTextByStyleName(pt,TextStyles.STYLE_DATA_TEXT,this.transformColor);;
				tfd.x = ptp.x + this.x;
				tfd.y = ptp.y;
				pillarTextSprite.addChild(tfd);
			}
		}
		
		public function get transformColor():uint
		{
			return _transformColor;
		}
		
		public function set transformColor(value:uint):void
		{
			_transformColor = value;
		}
		
	}
}