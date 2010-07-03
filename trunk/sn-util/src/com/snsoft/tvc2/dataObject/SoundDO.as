package com.snsoft.tvc2.dataObject{
	import flash.display.DisplayObject;
	import flash.media.Sound;

	public class SoundDO{
		
		private var _name:String;
		
		private var _timeOffset:int;
		
		private var _timeLength:int;
		
		private var _timeout:int;
		
		private var _text:String;
		
		private var _url:String;
		
		private var _soundList:Vector.<Sound>;
		
		public function SoundDO()
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

		public function get soundList():Vector.<Sound>
		{
			return _soundList;
		}

		public function set soundList(value:Vector.<Sound>):void
		{
			_soundList = value;
		}


	}
}