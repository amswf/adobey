package com.snsoft.map
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * 画线和两端点 
	 * @author Administrator
	 * 
	 */	
	public class MapLine extends MapComponent
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
		private var _pointColor:int;
		
		/**
		 * 线的颜色 
		 */		
		private var _lineColor:int;
		
		/**
		 * 填充色 
		 */		
		private var _pointFillColor:int;
		
		/**
		 * 缩放系数 
		 */		
		private var _scalePoint:Point = new Point(1,1);
		
		public function MapLine(startPoint:Point=null,endPoint:Point=null,pointColor:int=0x000000,lineColor:int=0x000000,pointFillColor:int = 0xffffff,scalePoint:Point = null) {
			//初始化参数
			this.startPoint = startPoint;
			this.endPoint = endPoint;
			this.pointColor = pointColor;
			this.lineColor = lineColor;
			this.pointFillColor = pointFillColor;
			if(scalePoint != null){
				this.scalePoint = scalePoint;
			}
			
			this.mouseEnabled = true;
			this.buttonMode = true;
			this.mouseChildren = true;
			
			//基类方法
			super();
		}
		
		/**
		 * 画线和点
		 * @return 
		 * 
		 */		
		override protected function draw():void{
			if(this.startPoint != null && this.endPoint != null){
				var l:Sprite = MapDraw.drawLine(this.startPoint,this.endPoint,0,this.lineColor,this.scalePoint);
				this.addChild(l);
				var s:Sprite = MapDraw.drawPoint(this.startPoint,0,2,this.pointColor,this.pointFillColor,this.scalePoint);
				this.addChild(s);
				var e:Sprite = MapDraw.drawPoint(this.endPoint,0,2,this.pointColor,this.pointFillColor,this.scalePoint);
				this.addChild(e);
			}
		}
	
		public function get lineColor():int
		{
			return _lineColor;
		}

		public function set lineColor(value:int):void
		{
			_lineColor = value;
		}

		public function get pointColor():int
		{
			return _pointColor;
		}

		public function set pointColor(value:int):void
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

		public function get pointFillColor():int
		{
			return _pointFillColor;
		}

		public function set pointFillColor(value:int):void
		{
			_pointFillColor = value;
		}

		public function get scalePoint():Point
		{
			return _scalePoint;
		}

		public function set scalePoint(value:Point):void
		{
			_scalePoint = value;
		}

	}
}