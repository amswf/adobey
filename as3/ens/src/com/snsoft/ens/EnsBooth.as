package com.snsoft.ens {
	import flash.display.Sprite;

	public class EnsBooth extends Sprite {

		private var _id:String;

		public function EnsBooth() {
			super();
		}

		public function get id():String
		{
			return _id;
		}

		public function set id(value:String):void
		{
			_id = value;
		}

	}
}
