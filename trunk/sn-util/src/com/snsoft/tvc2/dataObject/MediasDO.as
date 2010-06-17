package com.snsoft.tvc2.dataObject{
	import com.snsoft.util.HashVector;

	public class MediasDO{
		
		private var _mediaDOHv:Vector.<MediaDO>;
		
		public function MediasDO()
		{
		}

		public function get mediaDOHv():Vector.<MediaDO>
		{
			return _mediaDOHv;
		}

		public function set mediaDOHv(value:Vector.<MediaDO>):void
		{
			_mediaDOHv = value;
		}

	}
}