package com.snsoft.map
{
	import com.snsoft.map.util.HashArray;
	
	import flash.geom.Point;

	/**
	 * 地图块的数据对象 
	 * @author Administrator
	 * 
	 */	
	public class MapAreaDO
	{
		//地图块的点链
		private var _pointArray:HashArray = null;
		
		//地图块的显示名称
		private var _areaName:String = null;
		
		private var _areaId:String = null;
		
		//地图块的显示名称坐标修正
		private var _areaNamePlace:Point = new Point();
		
		public function MapAreaDO()
		{
		}

		public function get pointArray():HashArray
		{
			return _pointArray;
		}

		public function set pointArray(value:HashArray):void
		{
			_pointArray = value;
		}

		public function get areaName():String
		{
			return _areaName;
		}

		public function set areaName(value:String):void
		{
			_areaName = value;
		}

		public function get areaNamePlace():Point
		{
			return _areaNamePlace;
		}

		public function set areaNamePlace(value:Point):void
		{
			_areaNamePlace = value;
		}

		public function get areaId():String
		{
			return _areaId;
		}

		public function set areaId(value:String):void
		{
			_areaId = value;
		}


	}
}