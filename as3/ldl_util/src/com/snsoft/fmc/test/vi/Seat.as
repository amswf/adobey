package com.snsoft.fmc.test.vi{
	public class Seat{
		
		/**
		 * 客户端ID 
		 */		
		private var _clientId:String;
		
		/**
		 * 用户名 
		 */		
		private var _userName:String;
		
		/**
		 * 视频地址 
		 */		
		private var _videoName:String;
		
		/**
		 * 登录验证串 
		 */		
		private var _checklogin:String;
		
		/**
		 * 等待接通 
		 */		
		private var _isWait:Boolean;
		
		/**
		 * 充许视频
		 */
		private var _isSuccess:Boolean;
		
		/**
		 * 用户类型
		 */
		private var _userType:String;
		
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

		/**
		 * 等待接通
		 */
		public function get isWait():Boolean
		{
			return _isWait;
		}

		/**
		 * @private
		 */
		public function set isWait(value:Boolean):void
		{
			_isWait = value;
		}

		/**
		 * 充许视频
		 */
		public function get isSuccess():Boolean
		{
			return _isSuccess;
		}

		/**
		 * @private
		 */
		public function set isSuccess(value:Boolean):void
		{
			_isSuccess = value;
		}

		/**
		 * 用户类型
		 */
		public function get userType():String
		{
			return _userType;
		}

		/**
		 * @private
		 */
		public function set userType(value:String):void
		{
			_userType = value;
		}

		public function get clientId():String
		{
			return _clientId;
		}

		public function set clientId(value:String):void
		{
			_clientId = value;
		}


	}
}