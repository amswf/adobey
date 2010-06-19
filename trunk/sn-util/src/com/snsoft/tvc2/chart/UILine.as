package com.snsoft.tvc2.chart{
	import com.snsoft.tvc2.Business;
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
	
	[Style(name="line_default_skin", type="Class")]
	
	[Style(name="point_default_skin", type="Class")]
	
	[Style(name="myTextFormat", type="Class")]
	
	public class UILine extends Business{
		
		private var currentLine:MovieClip;
		
		private var currentLineLength:Number;
		
		private var currentLineParent:Sprite;
		
		private var currentIndex:int;
		
		private var timer:Timer;
		
		private var isAnimation:Boolean;
		
		private var _transformColor:uint;
		
		private var lineTextSprite:Sprite;
		
		private var perLen:Number = 2;
		
		private const PERLEN_BASE:Number = 2;
		
		private var charPointDOV:Vector.<CharPointDO>;
		
		public function UILine(charPointDOV:Vector.<CharPointDO> = null,isAnimation:Boolean = true,delayTime:Number = 0,timeLength:Number = 0,timeOut:Number = 0,lineTextSprite:Sprite = null,transformColor:uint = 0x000000){
			super();
			this.delayTime = delayTime;
			this.timeLength = timeLength;
			this.timeOut = timeOut;
			this.isAnimation = isAnimation;
			this._transformColor = transformColor;
			this.currentIndex = 0;
			
			this.lineTextSprite = lineTextSprite;
			this.charPointDOV = charPointDOV;
			
			this.currentLineParent = new Sprite();
			this.addChild(this.currentLineParent);
		}
		
		/**
		 * 获得当前点 
		 * @return 
		 * 
		 */		
		public function getCurrentPoint(index:int):Point{
			return charPointDOV[index].point;
		}
		
		public function getCurrentPointText(index:int):String{
			return charPointDOV[index].pointText;
		}
		
		public function getCurrentPointTextPlace(index:int):Point{
			return charPointDOV[index].pointTextPlace;
		}
		
		public static const LINE_DEFAULT_SKIN:String = "line_default_skin";
		
		public static const POINT_DEFAULT_SKIN:String = "point_default_skin";
		
		public static const TEXT_FORMAT:String = "myTextFormat";
		
		/**
		 * 
		 */		
		private static var defaultStyles:Object = {
			line_default_skin:"Line_default_skin",
			point_default_skin:"Point_default_skin",
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
		override protected function draw():void{
			
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
		 * @param p1
		 * @param p2
		 * 
		 */		
		override protected function play():void {
			
			if(charPointDOV != null && currentIndex < charPointDOV.length - 1){
				var p1:Point = null;
				this.currentIndex = findNextEffectiveIndex(charPointDOV,currentIndex);
				if(this.currentIndex >= 0){
					p1 = charPointDOV[this.currentIndex].point;
				}
				var index2:int = findNextEffectiveIndex(charPointDOV,currentIndex + 1);
				
				var p2:Point = null;
				if(this.currentIndex >= 0){
					p2 = charPointDOV[index2].point;
				}
				
				if(!isNaN(p1.y) && !isNaN(p2.y)){
					this.currentLineLength = lineLength(p1,p2);
					var l:MovieClip = getDisplayObjectInstance(getStyleValue(LINE_DEFAULT_SKIN)) as MovieClip;
					var lr:MovieClip = new MovieClip;
					lr.addChild(l);
					currentLine = l;
					this.currentLineParent.addChild(lr);
					drawLineText(currentIndex);
					
					var s:MovieClip = getDisplayObjectInstance(getStyleValue(POINT_DEFAULT_SKIN)) as MovieClip;
					s.x = p1.x;
					s.y = p1.y;
					this.currentLineParent.addChild(s);
					
					l.width = 0;
					lr.x = p1.x;
					lr.y = p1.y;
					
					var rate:Number = lineRate(p1,p2);
					
					lr.rotation = rate;
					
					perLen = PERLEN_BASE / Math.abs(Math.cos(rate * Math.PI / 180));
					timer = new Timer(20,0);
					timer.addEventListener(TimerEvent.TIMER,handlerTimer);
					timer.start();
					currentIndex = index2;//可能由于this.dispatchEvent(new Event(EVENT_POINT_CMP)); 执行慢了会出错。
				}
			}
		}
		
		private function handlerTimer(e:Event):void{
			if(charPointDOV != null &&　currentIndex < charPointDOV.length){
				
				currentLine.width += perLen;
				if((this.currentLineLength - currentLine.width) <= perLen){
					timer.removeEventListener(TimerEvent.TIMER,handlerTimer);
					currentLine.width = this.currentLineLength;
					var p2:Point = this.charPointDOV[currentIndex].point;
					var endPoint:MovieClip = getDisplayObjectInstance(getStyleValue(POINT_DEFAULT_SKIN)) as MovieClip;
					endPoint.x = p2.x;
					endPoint.y = p2.y;
					this.currentLineParent.addChild(endPoint);
					if(currentIndex < charPointDOV.length - 1){
						play();
					}
					else {
						drawLineText(currentIndex);
						this.isPlayCmp = true;
						dispatchEventState();
					}
				}
			}	
		}
		
		private function drawLines(points:Vector.<Point>):void{
			//静态折线图画线
		}
		
		/**
		 *  
		 * @param sprite
		 * 
		 */		
		private function drawLineText(index:int):void{	
			if(lineTextSprite != null){
				var p:Point = this.getCurrentPoint(index);
				var pt:String = this.getCurrentPointText(index);
				var ptp:Point = this.getCurrentPointTextPlace(index);
				var dsf:DropShadowFilter = new DropShadowFilter(0,45,0xffffff,1,3,3,1000,1);
				var dsf2:DropShadowFilter = new DropShadowFilter(0,45,0x000000,1,5,5,1,1);
				var filterAry:Array = new Array();
				filterAry.push(dsf,dsf2);
				
				var tft:TextFormat = getStyleValue(TEXT_FORMAT) as TextFormat;
				tft.color = this.transformColor;
				var tfd:TextField = new TextField();
				tfd.text = pt;
				tfd.selectable = false;
				
				tfd.x = ptp.x;
				tfd.y = ptp.y;
				lineTextSprite.addChild(tfd);
				tfd.setTextFormat(tft);
				tfd.filters = filterAry;
				TextFieldUtil.fitSize(tfd);
			}
		}
		
		private function findNextEffectivePoint(charPointDOV:Vector.<CharPointDO>,index:int):Point{
			var index1:int = findNextEffectiveIndex(charPointDOV,currentIndex);
			var p:Point = null;
			if(index >= 0 && index < charPointDOV.length){
				p = charPointDOV[index1].point;
			}
			return p;
		}
		
		private function findNextEffectiveIndex(charPointDOV:Vector.<CharPointDO>,index:int):int{
			if(index >= 0 && index < charPointDOV.length){
				for( var i:int = index;i<charPointDOV.length;i++){
					var p:Point = this.charPointDOV[i].point;
					if(!isNaN(p.y)){
						return i;
					}
				}
			}
			return -1;
		}
		
		/**
		 * 计算线长 
		 * @param p1
		 * @param p2
		 * @return 
		 * 
		 */		
		private function lineLength(p1:Point,p2:Point):Number{
			return Math.sqrt(Math.pow((p1.x - p2.x),2) + Math.pow((p1.y - p2.y),2));
		}
		
		/**
		 * 计算旋转角度 
		 * @param p1
		 * @param p2
		 * @return 
		 * 
		 */		
		private function lineRate(p1:Point,p2:Point):Number{
			var rate:Number = 0;
			
			if(p2.x - p1.x == 0){
				rate = p2.y - p1.y > 0 ? 90 : -90;
			}
			else {
				rate = Math.atan((p2.y - p1.y) / (p2.x - p1.x)) * 180 / Math.PI;
			}
			return rate;
		}
		
		public function get transformColor():uint
		{
			return _transformColor;
		}
		
		public function set transformColor(transformColor:uint):void
		{
			this._transformColor = transformColor;
		}
	}
}