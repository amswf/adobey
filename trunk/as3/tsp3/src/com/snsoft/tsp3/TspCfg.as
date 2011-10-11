package com.snsoft.tsp3 {

	public class TspCfg {

		private var _startPlugin:String;

		private var _serverRootUrl:String;

		private var _dataUrl:String;

		public function TspCfg() {
		}

		public function get startPlugin():String
		{
			return _startPlugin;
		}

		public function set startPlugin(value:String):void
		{
			_startPlugin = value;
		}

		public function get serverRootUrl():String
		{
			return _serverRootUrl;
		}

		public function set serverRootUrl(value:String):void
		{
			_serverRootUrl = value;
		}

		public function get dataUrl():String
		{
			return _dataUrl;
		}

		public function set dataUrl(value:String):void
		{
			_dataUrl = value;
		}


	}
}
