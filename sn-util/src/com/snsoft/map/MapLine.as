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
		private var _pointColor:uint;
		
		/**
		 * 线的颜色 
		 */		
		private var _lineColor:uint;
		
		//线的粗细		
		private static var THICKNESS:uint = 0;
		
		//画点的填充色
		private static var POINT_FILL_COLOR:uint = 0xffffff;
		
		//画点半径
		private static var POINT_R:uint = 2;
		
		
		public function MapLine(startPoint:Point=null,endPoint:Point=null,pointColor:uint=0x000000,lineColor:uint=0x000000) {
			//初始化参数
			this.startPoint = startPoint;
			this.endPoint = endPoint;
			this.pointColor = pointColor;
			this.lineColor = lineColor;
			
			//基类方法
			super();
		}

		/**
		 * 刷新显示 
		 * 
		 */		

		public function get lineColor():uint
		{
			return _lineColor;
		}

		public function set lineColor(value:uint):void
		{
			_lineColor = value;
		}

		public function get pointColor():uint
		{
			return _pointColor;
		}

		public function set pointColor(value:uint):void
		{
			_pointColor = value;
		}

		public function refresh():void{
			this.deleteAllChildMC();
			this.draw();
		}
		
		/**
		 * 画线和点
		 * @return 
		 * 
		 */		
		private function draw():void{
			var l:Sprite = this.drawLine(this.startPoint,this.endPoint,this.lineColor);
			this.addChild(l);
			var s:Sprite = this.drawPoint(this.startPoint,POINT_R,this.pointColor);
			this.addChild(s);
			var e:Sprite = this.drawPoint(this.endPoint,POINT_R,this.pointColor);
			this.addChild(e);
		}
		
		/**
		 * 删除所有字MC 
		 * 
		 */		
		private function deleteAllChildMC():void{
			while(this.numChildren >0){
				this.removeChildAt(0);
			}
		}
		
		/**
		 * 画圆
		 * @return 
		 * 
		 */		
		private function drawPoint(point:Point,r:uint,color:uint):Sprite{
			var sprite:Sprite = new Sprite();
			var shape:Shape = new Shape();
			sprite.addChild(shape);
			var gra:Graphics = shape.graphics;
			gra.lineStyle(THICKNESS,color);
			gra.beginFill(POINT_FILL_COLOR,1);
			gra.drawCircle(point.x - r/2,point.y -r/2,r);
			gra.endFill();
			return sprite;
		}
		
		/**
		 * 画线
		 * @return 
		 * 
		 */		
		private function drawLine(startPoint:Point,endPoint:Point,color:uint):Sprite{
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