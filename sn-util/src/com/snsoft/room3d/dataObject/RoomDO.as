package com.snsoft.room3d.dataObject{
	import com.snsoft.util.HashVector;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * 房间数据对象 
	 * @author Administrator
	 * 
	 */	
	public class RoomDO {
		
		/**
		 * name XML标签属性 
		 */		
		private var _nameStr:String = null;
		
		/**
		 * value XML标签属性 
		 */		
		private var _valueStr:String = null;
		
		/**
		 * text XML标签属性 
		 */		
		private var _textStr:String = null;
		
		/**
		 * bgImg XML标签属性，背景图片
		 */		
		private var _bgImgUrl:String = null;
		
		/**
		 * 背景图片位图对象 
		 */		
		private var _bgImgBitmap:BitmapData = null;
		
		/**
		 * titleImg XML标签属性,标题图片 
		 */		
		private var _titleImgUrl:String = null;
		
		/**
		 * 标题图片位图对象 
		 */		
		private var _titleImgBitmap:BitmapData = null;
		
		/**
		 * 观察点在房间里的位置列表 
		 */		
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