package com.snsoft.tvc2.dataObject{
	import com.snsoft.util.HashVector;

	public class MediasDO{
		
		private var _mediaDOHv:HashVector;
		public function MediasDO()
		{
		}

		public function get mediaDOHv():HashVector
		{
			return _mediaDOHv;
		}

		public function set mediaDOHv(value:HashVector):void
		{
			_mediaDOHv = value;
		}

	}
}