package com.moas.domain{
	public class User {
		public function User() {
		}
		private var _userId:java.lang.Integer;
		private var _userName:string;
		private var _password:string;
		public function get userId():java.lang.Integer {
			return this._userId;
		}
		public function get userName():string {
			return this._userName;
		}
		public function get password():string {
			return this._password;
		}
		public function set userId(userId:java.lang.Integer):void {
			this._userId = userId;
		}
		public function set userName(userName:string):void {
			this._userName = userName;
		}
		public function set password(password:string):void {
			this._password = password;
		}
	}
}