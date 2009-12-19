package
{
	public class User
	{
		public function User()
		{
		}
		
		private var _propertyNames:Array = new Array("userName","password");
		
		private var _userName:String;
		
		private var _password:String;
		
		private function get propertyNames():Array{
			return this._propertyNames;
		}
		
		private function get userName():String{
			return this._userName;
		}
		
		private function get password():String{
			return this._password;
		}
		
		private function set userName(userName:String):void{
			this._userName = userName;
		}
		
		private function set password(password:String):void{
			this._password = password;
		}
	}
}