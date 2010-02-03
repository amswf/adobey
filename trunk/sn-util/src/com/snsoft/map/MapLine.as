package com.snsoft.map
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * 画线和两端点 
	 * @author Administrator
	 * 
	 */	
	public class MapLine extends MapMovieClip
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
		
		/**
		 * 填充色 
		 */		
		private var pointFillColor:uint;
		
		public function MapLine(startPoint:Point=null,endPoint:Point=null,pointColor:uint=0x000000,lineColor:uint=0x000000,pointFillColor:uint = 0xffffff) {
			//初始化参数
			this.startPoint = startPoint;
			this.endPoint = endPoint;
			this.pointColor = pointColor;
			this.lineColor = lineColor;
			this.pointFillColor = pointFillColor;
			
			//基类方法
			super();
		}
		
		/**
		 * 画线和点
		 * @return 
		 * 
		 */		
		override protected function draw():void{
			var l:Sprite = MapDraw.drawLine(this.startPoint,this.endPoint,0,this.lineColor);
			this.addChild(l);
			var s:Sprite = MapDraw.drawPoint(this.startPoint,0,2,this.pointColor,this.pointFillColor);
			this.addChild(s);
			var e:Sprite = MapDraw.drawPoint(this.endPoint,0,2,this.pointColor,this.pointFillColor);
			this.addChild(e);
		}
	
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