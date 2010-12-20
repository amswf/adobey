package com.snsoft.fmc.test.vi{
	public class Seat{
		
		private var _userName:String;
		
		private var _videoName:String;
		
		private var _checklogin:String;
		
		public function Seat()
		{
		}

		public function get userName():String
		{
			return _userName;
		}

		public function set userName(value:String):void
		{
			_userName = value;
		}

		public function get videoName():String
		{
			return _videoName;
		}

		public function set videoName(value:String):void
		{
			_videoName = value;
		}

		public function get checklogin():String
		{
			return _checklogin;
		}

		public function set checklogin(value:String):void
		{
			_checklogin = value;
		}


	}
}