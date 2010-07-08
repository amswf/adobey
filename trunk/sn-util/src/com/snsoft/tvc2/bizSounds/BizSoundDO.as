package com.snsoft.tvc2.bizSounds{
	public class BizSoundDO{
		
		private var _urlVV:Vector.<Vector.<String>>;
		
		private var _textVV:Vector.<Vector.<String>>;
		
		public function BizSoundDO()
		{
		}

		public function get urlVV():Vector.<Vector.<String>>
		{
			return _urlVV;
		}

		public function set urlVV(value:Vector.<Vector.<String>>):void
		{
			_urlVV = value;
		}

		public function get textVV():Vector.<Vector.<String>>
		{
			return _textVV;
		}

		public function set textVV(value:Vector.<Vector.<String>>):void
		{
			_textVV = value;
		}


	}
}