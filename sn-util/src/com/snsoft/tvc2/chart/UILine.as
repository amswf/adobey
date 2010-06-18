package com.snsoft.tvc2.chart{
	import com.snsoft.tvc2.Business;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	[Style(name="line_default_skin", type="Class")]
	
	[Style(name="point_default_skin", type="Class")]
	
	[Style(name="myTextFormat", type="Class")]
	
	public class UILine extends Business{
		
		public static const EVENT_POINT_CMP:String = "EVENT_POINT_CMP";
		
		private var currentLine:MovieClip;
		
		private var currentLineLength:Number;
		
		private var currentLineParent:Sprite;
		
		private var _currentIndex:int;
		
		private var points:Vector.<Point>;
		
		private var pointsText:Vector.<String>;
		
		private var pointsTextPlace:Vector.<Point>;
		
		private var timer:Timer;
		
		private var isAnimation:Boolean;
		
		private var _serialNumber:int;
		
		private var _transformColor:uint;
		
		public function UILine(points:Vector.<Point> = null,pointsText:Vector.<String> = null,pointsTextPlace:Vector.<Point> = null,isAnimation:Boolean = true,delayTime:Number = 0,timeLength:Number = 0,timeOut:Number = 0,serialNumber:int = 0,transformColor:uint = 0x000000){
			this.delayTime = delayTime;
			this.timeLength = timeLength;
			this.timeOut = timeOut;
			this.points = points;
			this.pointsText = pointsText;
			this.pointsTextPlace = pointsTextPlace;
			this.isAnimation = isAnimation;
			this._serialNumber = serialNumber;
			this._transformColor = transformColor;
			this._currentIndex = 0;
			this.currentLineParent = new Sprite();
			this.addChild(this.currentLineParent);
		}
		
		/**
		 * 获得当前点 
		 * @return 
		 * 
		 */		
		public function getCurrentPoint():Point{
			return points[currentIndex];
		}
		
		public function getCurrentPointText():String{
			return pointsText[currentIndex];
		}
		
		public function getCurrentPointTextPlace():Point{
			return pointsTextPlace[currentIndex];
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
			
			if(points != null && currentIndex < points.length - 1){
				var p1:Point = null;
				this._currentIndex = findNextEffectiveIndex(points,currentIndex);
				if(this._currentIndex >= 0){
					p1 = points[this._currentIndex];
				}
				var index2:int = findNextEffectiveIndex(points,currentIndex + 1);
				
				var p2:Point = null;
				if(this._currentIndex >= 0){
					p2 = points[index2];
				}
				
				if(!isNaN(p1.y) && !isNaN(p2.y)){
					trace(p1,p2,lineLength(p1,p2));
					this.currentLineLength = lineLength(p1,p2);
					var l:MovieClip = getDisplayObjectInstance(getStyleValue(LINE_DEFAULT_SKIN)) as MovieClip;
					var lr:MovieClip = new MovieClip;
					lr.addChild(l);
					currentLine = l;
					this.currentLineParent.addChild(lr);
					this.dispatchEvent(new Event(EVENT_POINT_CMP));
					
					var s:MovieClip = getDisplayObjectInstance(getStyleValue(POINT_DEFAULT_SKIN)) as MovieClip;
					s.x = p1.x;
					s.y = p1.y;
					this.currentLineParent.addChild(s);
					
					l.width = 0;
					lr.x = p1.x;
					lr.y = p1.y;
					
					var rate:Number = lineRate(p1,p2);
					
					lr.rotation = rate;
					
					timer = new Timer(20,0);
					timer.addEventListener(TimerEvent.TIMER,handlerTimer);
					
					timer.start();
					_currentIndex = index2;//可能由于this.dispatchEvent(new Event(EVENT_POINT_CMP)); 执行慢了会出错。
				}
			}
		}
		
		private function handlerTimer(e:Event):void{
			if(points != null &&　currentIndex < points.length){
				var perLen:Number = 2; 
				currentLine.width += perLen;
				if((this.currentLineLength - currentLine.width) <= perLen){
					timer.removeEventListener(TimerEvent.TIMER,handlerTimer);
					currentLine.width = this.currentLineLength;
					var p2:Point = this.points[currentIndex];
					var endPoint:MovieClip = getDisplayObjectInstance(getStyleValue(POINT_DEFAULT_SKIN)) as MovieClip;
					endPoint.x = p2.x;
					endPoint.y = p2.y;
					this.currentLineParent.addChild(endPoint);
					if(currentIndex < points.length - 1){
						play();
					}
					else {
						this.dispatchEvent(new Event(EVENT_POINT_CMP));
						this.isPlayCmp = true;
						dispatchEventState();
					}
				}
			}	
		}
		
		private function drawLines(points:Vector.<Point>):void{
			
		}
		
		private function findNextEffectivePoint(points:Vector.<Point>,index:int):Point{
			var index1:int = findNextEffectiveIndex(points,currentIndex);
			var p:Point = null;
			if(index >= 0 && index < points.length){
				p = points[index1];
			}
			return p;
		}
		
		private function findNextEffectiveIndex(points:Vector.<Point>,index:int):int{
			if(index >= 0 && index < points.length){
				for( var i:int = index;i<points.length;i++){
					var p:Point = this.points[i];
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
		
		public function get currentIndex():int
		{
			return _currentIndex;
		}
		
		public function get serialNumber():int
		{
			return _serialNumber;
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