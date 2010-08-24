package com.snsoft.room3d{
	import com.snsoft.util.HashVector;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class RoomDO {
		
		private var _nameStr:String = null;
		
		private var _valueStr:String = null;
		
		private var _textStr:String = null;
		
		private var _bgImgUrl:String = null;
		
		private var _bgImgBitmap:BitmapData = null;
		
		private var _titleImgUrl:String = null;
		
		private var _titleImgBitmap:BitmapData = null;
		
		private var _placeHV:HashVector = null;
		
		public function RoomDO()
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

		public function get placeHV():HashVector
		{
			return _placeHV;
		}

		public function set placeHV(value:HashVector):void
		{
			_placeHV = value;
		}

		public function get titleImgUrl():String
		{
			return _titleImgUrl;
		}

		public function set titleImgUrl(value:String):void
		{
			_titleImgUrl = value;
		}

		public function get bgImgUrl():String
		{
			return _bgImgUrl;
		}

		public function set bgImgUrl(value:String):void
		{
			_bgImgUrl = value;
		}

		public function get bgImgBitmap():BitmapData
		{
			return _bgImgBitmap;
		}

		public function set bgImgBitmap(value:BitmapData):void
		{
			_bgImgBitmap = value;
		}

		public function get titleImgBitmap():BitmapData
		{
			return _titleImgBitmap;
		}

		public function set titleImgBitmap(value:BitmapData):void
		{
			_titleImgBitmap = value;
		}


	}
}