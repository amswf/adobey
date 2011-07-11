package com.snsoft.ens {
	import flash.display.Sprite;

	public class EnsBooth extends Sprite {

		private var _id:String;

		private var _text:String;

		private var _isCurrentPosition:Boolean;

		public function EnsBooth() {
			super();
		}

		public function get id():String {
			return _id;
		}

		public function set id(value:String):void {
			_id = value;
		}

		public function get text():String {
			return _text;
		}

		public function set text(value:String):void {
			_text = value;
		}

		public function get isCurrentPosition():Boolean
		{
			return _isCurrentPosition;
		}

		public function set isCurrentPosition(value:Boolean):void
		{
			_isCurrentPosition = value;
		}


	}
}
