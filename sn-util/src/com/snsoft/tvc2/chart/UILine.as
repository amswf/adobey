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
		
		private var currentLine:MovieClip;
		
		private var currentLineLength:Number;
		
		private var currentLineParent:Sprite;
		
		private var currentIndex:int;
		
		private var points:Vector.<Point>;
		
		private var timer:Timer;
		
		private var isAnimation:Boolean;
		
		public function UILine(points:Vector.<Point> = null,isAnimation:Boolean = true,delayTime:Number = 0,timeLength:Number = 0,timeOut:Number = 0){
			super();
			this.delayTime = delayTime;
			this.timeLength = timeLength;
			this.timeOut = timeOut;
			this.points = points;
			this.isAnimation = isAnimation;
			currentIndex = 0;
			this.currentLineParent = new Sprite();
			this.addChild(this.currentLineParent);
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
				var p1:Point = new Point();
				for( var i:int = currentIndex;i<points.length -1;i++){
					p1 = this.points[i];
					if(!isNaN(p1.y)){
						currentIndex = i;
						break;
					}
				}
				var p2:Point = new Point();
				
				for( var ii:int = currentIndex + 1;ii<points.length;ii++){
					p2 = this.points[ii];
					if(!isNaN(p2.y)){
						currentIndex = ii - 1;
						break;
					}
				}
				if(!isNaN(p1.y) && !isNaN(p2.y)){
					this.currentLineLength = Math.sqrt(Math.pow((p1.x - p2.x),2) + Math.pow((p1.y - p2.y),2));
					
					var l:MovieClip = getDisplayObjectInstance(getStyleValue(LINE_DEFAULT_SKIN)) as MovieClip;
					var lr:MovieClip = new MovieClip;
					lr.addChild(l);
					currentLine = l;
					this.currentLineParent.addChild(lr);
					
					
					var s:MovieClip = getDisplayObjectInstance(getStyleValue(POINT_DEFAULT_SKIN)) as MovieClip;
					s.x = p1.x;
					s.y = p1.y;
					this.currentLineParent.addChild(s);
					
					l.width = 0;
					lr.x = p1.x;
					lr.y = p1.y;
					
					var rate:Number = Math.atan((p2.y - p1.y) / (p2.x - p1.x)) * 180 / Math.PI;
					
					lr.rotation = rate;
					
					timer = new Timer(20,0);
					timer.addEventListener(TimerEvent.TIMER,handlerTimer);
					if(isAnimation){
						timer.start();
					}
					else {
						timer.dispatchEvent(new Event(TimerEvent.TIMER));
					}
				}
			}
		}
		
		private function handlerTimer(e:Event):void{
			if(points != null &&　currentIndex < points.length - 1){
				
				var perLen:Number = 2;
				if(isAnimation){
					currentLine.width += perLen;
				}
				else {
					currentLine.width = this.currentLineLength;
				}
				if((this.currentLineLength - currentLine.width) <= perLen){
					timer.removeEventListener(TimerEvent.TIMER,handlerTimer);
					currentLine.width = this.currentLineLength;
					var p2:Point = this.points[currentIndex + 1];
					var endPoint:MovieClip = getDisplayObjectInstance(getStyleValue(POINT_DEFAULT_SKIN)) as MovieClip;
					endPoint.x = p2.x;
					endPoint.y = p2.y;
					this.currentLineParent.addChild(endPoint);
					currentIndex ++;
					if(currentIndex < points.length - 1){
						play();
					}
					else {
						this.isPlayCmp = true;
						dispatchEventState();
					}
				}
			}	
		}
	}
}