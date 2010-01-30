package com.snsoft.map
{
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class MapLine extends MovieClip
	{
		/**
		 * 开始点 
		 */		
		private var _startPoint:Point;
		
		/**
		 * 结束点 
		 */		
		private var _endPoint:Point;
		
		/**
		 * 点的颜色 
		 */		
		private var pointColor:uint;
		
		/**
		 * 线的颜色 
		 */		
		private var lineColor:uint;
		
		//线的粗细		
		private static var THICKNESS:uint = 0;
		
		//画点的填充色
		private static var POINT_FILL_COLOR:uint = 0xffffff;
		
		
		public function MapLine() {
			super();
		}
		
		public function MapLine(startPoint:Point,endPoint:Point,pointColor:uint=0x000000,lineColor:uint=0x000000) {
			super();
		}

		public function refresh(){
			this.deleteAllChildMC();
			this.draw();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function draw(){
			var l:Sprite = this.drawLine(this.startPoint,this.endPoint,this.lineColor);
			this.addChild(l);
			var s:Sprite = this.drawPoint(this.startPoint,this.pointColor);
			this.addChild(s);
			var e:Sprite = this.drawPoint(this.endPoint,this.pointColor);
			this.addChild(e);
		}
		
		public function deleteAllChildMC(){
			while(this.numChildren >0){
				this.removeChildAt(0);
			}
		}
		
		/**
		 * 画圆
		 * @return 
		 * 
		 */		
		public function drawPoint(point:Point,r:uint,color:uint):Sprite{
			var sprite:Sprite = new Sprite();
			var shape:Shape = new Shape();
			sprite.addChild(shape);
			var gra:Graphics = shape.graphics;
			gra.lineStyle(THICKNESS,color);
			gra.beginFill(POINT_FILL_COLOR,1);
			gra.drawCircle(point.x - r,point.y -r,r);
			gra.endFill();
			return sprite;
		}
		
		/**
		 * 画线
		 * @return 
		 * 
		 */		
		public function drawLine(startPoint:Point,endPoint:Point,color:uint):Sprite{
			var sprite:Sprite = new Sprite();
			var shape:Shape = new Shape();
			sprite.addChild(shape);
			var gra:Graphics = shape.graphics;
			gra.lineStyle(THICKNESS,color);
			gra.moveTo(startPoint.x,startPoint.y);
			gra.lineTo(endPoint.x,endPoint.y);
			return sprite;
		}
		
		/**
		 * 结束点 
		 * @return 
		 * 
		 */		
		public function get endPoint():Point
		{
			return _endPoint;
		}

		/**
		 * 结束点 
		 * @param value
		 * 
		 */		
		public function set endPoint(value:Point):void
		{
			_endPoint = value;
		}

		/**
		 * 开始点
		 * @return 
		 * 
		 */		
		public function get startPoint():Point
		{
			return _startPoint;
		}

		/**
		 * 开始点
		 * @param value
		 * 
		 */		
		public function set startPoint(value:Point):void
		{
			_startPoint = value;
		}

	}
}