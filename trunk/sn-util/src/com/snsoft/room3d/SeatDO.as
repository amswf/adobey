package com.snsoft.room3d{
	import com.snsoft.util.HashVector;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.BitmapData;
	import flash.geom.Point;

	public class SeatDO{
		
		private var _nameStr:String = null;
		
		private var _valueStr:String = null;
		
		private var _textStr:String = null;
		
		public static const FRONT:String = "front";
		
		public static const BACK:String = "back";
		
		public static const TOP:String = "top";
		
		public static const BOTTOM:String = "bottom";
		
		public static const LEFT:String = "left";
		
		public static const RIGHT:String = "right";
		
		public static const BALL:String = "ball";
		
		private var _imageUrlHV:HashVector = new HashVector;
		
		private var _imageBitMapData:HashVector = new HashVector;
		
		private var _ballImageUrl:String;
		
		private var _ballImageBitMapData:BitmapData;
		
		private var _place:Point = null;
		
		public function SeatDO()
		{
			super();
		}

		public function get nameStr():String
		{
			return _nameStr;
		}

		public function set nameStr(value:String):void
		{
			_nameStr = value;
		}

		public function get valueStr():String
		{
			return _valueStr;
		}

		public function set valueStr(value:String):void
		{
			_valueStr = value;
		}

		public function get textStr():String
		{
			return _textStr;
		}

		public function set textStr(value:String):void
		{
			_textStr = value;
		}

		public function get place():Point
		{
			return _place;
		}

		public function set place(value:Point):void
		{
			_place = value;
		}

		public function get imageUrlHV():HashVector
		{
			return _imageUrlHV;
		}

		public function set imageUrlHV(value:HashVector):void
		{
			_imageUrlHV = value;
		}

		public function get imageBitMapData():HashVector
		{
			return _imageBitMapData;
		}

		public function set imageBitMapData(value:HashVector):void
		{
			_imageBitMapData = value;
		}

		public function get ballImageUrl():String
		{
			return _ballImageUrl;
		}

		public function set ballImageUrl(value:String):void
		{
			_ballImageUrl = value;
		}

		public function get ballImageBitMapData():BitmapData
		{
			return _ballImageBitMapData;
		}

		public function set ballImageBitMapData(value:BitmapData):void
		{
			_ballImageBitMapData = value;
		}


	}
}