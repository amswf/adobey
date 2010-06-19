package com.snsoft.tvc2.chart{
	import flash.geom.Point;

	public class CharPointDO{
		
		private var _point:Point;
		
		private var _pointText:String;
		
		private var _pointTextPlace:Point;
		
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
	}
}