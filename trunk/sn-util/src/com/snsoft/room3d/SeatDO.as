package com.snsoft.room3d{
	import com.snsoft.util.HashVector;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	/**
	 * 3D显示数据对象
	 * @author Administrator
	 * 
	 */	
	public class SeatDO{
		
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
		 * 描述信息 
		 */		
		private var _msg:String = null;
		
		/**
		 * 壁画，点击位置 
		 */
		private var _murals:Vector.<Vector3D> = new Vector.<Vector3D>();
		
		/**
		 * 去其它观察点，点击位置
		 */
		private var _placeLinks:Vector.<Vector3D> = new Vector.<Vector3D>();
		
		/**
		 * 正方体前面 
		 */		
		public static const FRONT:String = "front";
		
		/**
		 * 正方体后面 
		 */		
		public static const BACK:String = "back";
		
		/**
		 * 正方体顶面 
		 */		
		public static const TOP:String = "top";
		
		/**
		 *正方体底面 
		 */		
		public static const BOTTOM:String = "bottom";
		
		/**
		 * 正方体左面 
		 */	
		public static const LEFT:String = "left";
		
		/**
		 * 正方体右面 
		 */			
		public static const RIGHT:String = "right";
		
		/**
		 * 球面 
		 */	
		public static const BALL:String = "ball";
		
		/**
		 *图片地址列表 
		 */		
		private var _imageUrlHV:HashVector = new HashVector;
		
		/**
		 * 图片位图对象列表 
		 */		
		private var _imageBitMapData:HashVector = new HashVector;
		
		/**
		 * 球面图片地址 
		 */		
		private var _ballImageUrl:String;
		
		/**
		 * 球面位图对象 
		 */		
		private var _ballImageBitMapData:BitmapData;
		
		/**
		 * 当前观察点在房间平面图上的位置 
		 */		
		private var _place:Point = null;
		
		public function SeatDO()
		{
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

		/**
		 * 描述信息 
		 */
		public function get msg():String
		{
			return _msg;
		}

		/**
		 * @private
		 */
		public function set msg(value:String):void
		{
			_msg = value;
		}

		/**
		 * 壁画，点击位置 
		 */
		public function get murals():Vector.<Vector3D>
		{
			return _murals;
		}

		/**
		 * @private
		 */
		public function set murals(value:Vector.<Vector3D>):void
		{
			_murals = value;
		}

		/**
		 * 去其它观察点，点击位置
		 */
		public function get placeLinks():Vector.<Vector3D>
		{
			return _placeLinks;
		}

		/**
		 * @private
		 */
		public function set placeLinks(value:Vector.<Vector3D>):void
		{
			_placeLinks = value;
		}


	}
}