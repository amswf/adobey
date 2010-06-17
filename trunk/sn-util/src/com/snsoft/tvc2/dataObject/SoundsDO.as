package com.snsoft.tvc2.dataObject{
 

	public class SoundsDO{
		
		private var _soundDOHv:Vector.<SoundDO>;
		
		public function SoundsDO()
		{
		}

		public function get soundDOHv():Vector.<SoundDO>
		{
			return _soundDOHv;
		}

		public function set soundDOHv(value:Vector.<SoundDO>):void
		{
			_soundDOHv = value;
		}

	}
}