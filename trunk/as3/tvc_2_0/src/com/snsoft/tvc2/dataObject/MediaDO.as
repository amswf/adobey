package com.snsoft.tvc2.dataObject{
	import com.snsoft.util.rlm.rs.ResSet;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;

	/**
	 * 多媒体（图片、动画）数据对象 
	 * @author Administrator
	 * 
	 */	
	public class MediaDO{
		
		//名称
		private var _name:String;
		
		//延时播放的时间（多长时间后开始播放）
		private var _timeOffset:int;
		
		//最小播放时长
		private var _timeLength:int;
		
		//最大播放时长
		private var _timeout:int;
		
		//文本
		private var _text:String;
		
		//文件地址
		private var _url:String;
		
		//显示位置
		private var _place:Point;
		
		//位置类型，参考PlaceType类
		private var _placeType:String;
		
		//图片、动画列表
		private var _mediaList:Vector.<DisplayObject>;
		
		private var _resSet:ResSet;
		
		public function MediaDO()
		{
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get timeOffset():int
		{
			return _timeOffset;
		}

		public function set timeOffset(value:int):void
		{
			_timeOffset = value;
		}

		public function get timeLength():int
		{
			return _timeLength;
		}

		public function set timeLength(value:int):void
		{
			_timeLength = value;
		}

		public function get timeout():int
		{
			return _timeout;
		}

		public function set timeout(value:int):void
		{
			_timeout = value;
		}

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text = value;
		}

		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
		}

		public function get place():Point
		{
			return _place;
		}

		public function set place(value:Point):void
		{
			_place = value;
		}

		public function get mediaList():Vector.<DisplayObject>
		{
			return _mediaList;
		}

		public function set mediaList(value:Vector.<DisplayObject>):void
		{
			_mediaList = value;
		}

		public function get placeType():String
		{
			return _placeType;
		}

		public function set placeType(value:String):void
		{
			_placeType = value;
		}

		public function get resSet():ResSet
		{
			return _resSet;
		}

		public function set resSet(value:ResSet):void
		{
			_resSet = value;
		}


	}
}