package com.snsoft.tvc2.chart{
	import flash.geom.Point;

	/**
	 * 图表显示数据对象 
	 * @author Administrator
	 * 
	 */	
	public class CharPointDO{
		
		public static const STYLE_DASHED:String = "dashed";
		
		private var _point:Point;//图型显示坐标
		
		private var _pointText:String;//显示的文本值
		
		private var _pointTextPlace:Point;//显示文本的位置
		
		private var _style:String;//样式，例如：虚线 dashed  /
		
		public function CharPointDO()
		{
		}

		public function get point():Point
		{
			return _point;
		}

		public function set point(value:Point):void
		{
			_point = value;
		}

		public function get pointText():String
		{
			return _pointText;
		}

		public function set pointText(value:String):void
		{
			_pointText = value;
		}

		public function get pointTextPlace():Point
		{
			return _pointTextPlace;
		}

		public function set pointTextPlace(value:Point):void
		{
			_pointTextPlace = value;
		}

		public function get style():String
		{
			return _style;
		}

		public function set style(value:String):void
		{
			_style = value;
		}

	}
}