package com.snsoft.map
{
	import flash.display.Shape;
	
	
	
	/**
	 * 画区域 
	 * @author Administrator
	 * 
	 */	
	public class MapArea extends MapMovieClip
	{
		
		//线色
		private var _lineColor:uint = 0x000000;
		
		//填充色
		private var _fillColor:uint = 0x000000;
		
		//画区域的点列表的数组，一个图形可有多个点围成，但可以是多个点组成的链组成。
		private var _pointArrayArray:Array = null;
		
		public function MapArea(pointArrayArray:Array,lineColor:uint,fillColor:uint)
		{
			this.pointArrayArray = pointArrayArray;
			this.lineColor = lineColor;
			this.fillColor = fillColor;
			super();
		}
		
		/**
		 * 画图并添加到当MC中 
		 * 
		 */		
		override protected function draw():void{
			var shape:Shape = MapDraw.drawFill(this.pointArrayArray,this.lineColor,this.fillColor);
			this.addChild(shape);
		}
		
		/**
		 *  
		 * @return 
		 * 
		 */		
		public function get pointArrayArray():Array
		{
			return _pointArrayArray;
		}

		/**
		 * 
		 * @param value
		 * 
		 */		
		public function set pointArrayArray(value:Array):void
		{
			_pointArrayArray = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get fillColor():uint
		{
			return _fillColor;
		}

		/**
		 * 
		 * @param value
		 * 
		 */		
		public function set fillColor(value:uint):void
		{
			_fillColor = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get lineColor():uint
		{
			return _lineColor;
		}

		/**
		 * 
		 * @param value
		 * 
		 */		
		public function set lineColor(value:uint):void
		{
			_lineColor = value;
		}
	}
}