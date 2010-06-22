package com.snsoft.tvc2.dataObject{
	import flash.display.DisplayObject;
	import flash.geom.Point;

	public class MediaDO{
		
		private var _name:String;
		
		private var _timeOffset:int;
		
		private var _timeLength:int;
		
		private var _timeout:int;
		
		private var _text:String;
		
		private var _url:String;
		
		private var _place:Point;
		
		private var _mediaList:Vector.<DisplayObject>;
		
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


	}
}