package com.snsoft.ensview {

	public class EnsvBoothDO {

		private var _id:String;

		private var _text:String;

		private var _isCurrentPosition:Boolean;

		private var _paneDOs:Vector.<EnsvPaneDO> = new Vector.<EnsvPaneDO>();

		private var _msg:EnsvBoothMsgDO;

		public function EnsvBoothDO() {
		}

		public function addPane(pane:EnsvPaneDO):void {
			this.paneDOs.push(pane);
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

		public function get paneDOs():Vector.<EnsvPaneDO> {
			return _paneDOs;
		}

		public function set paneDOs(value:Vector.<EnsvPaneDO>):void {
			_paneDOs = value;
		}

		public function get isCurrentPosition():Boolean {
			return _isCurrentPosition;
		}

		public function set isCurrentPosition(value:Boolean):void {
			_isCurrentPosition = value;
		}

		public function get msg():EnsvBoothMsgDO
		{
			return _msg;
		}

		public function set msg(value:EnsvBoothMsgDO):void
		{
			_msg = value;
		}


	}
}
