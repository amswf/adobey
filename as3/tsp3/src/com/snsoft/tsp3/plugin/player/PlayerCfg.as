package com.snsoft.tsp3.plugin.player {

	public class PlayerCfg {

		private var _playerWidth:String;

		private var _playerHeight:String;

		public function PlayerCfg() {
		}

		public function get playerWidth():String
		{
			return _playerWidth;
		}

		public function set playerWidth(value:String):void
		{
			_playerWidth = value;
		}

		public function get playerHeight():String
		{
			return _playerHeight;
		}

		public function set playerHeight(value:String):void
		{
			_playerHeight = value;
		}


	}
}
