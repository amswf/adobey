package com.snsoft.tvc2.dataObject{
 
	/**
	 * 声音对象组对象 
	 * @author Administrator
	 * 
	 */
	public class SoundsDO{
		
		//声音对象列表
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