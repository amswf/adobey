package com.snsoft.ens {

	public class EnsToolBtnDO {

		private var _defaultSkin:String = "ToolSelectDefaultSkin";

		private var _downSkin:String = "ToolSelectDownSkin";

		private var _overSkin:String = "ToolSelectOverSkin";

		private var _selected:Boolean = false;

		private var _type:String;

		public function EnsToolBtnDO(defaultSkin:String, downSkin:String, overSkin:String, selected:Boolean, type:String) {
			this.defaultSkin = defaultSkin;
			this.downSkin = downSkin;
			this.overSkin = overSkin;
			this.selected = selected;
			this.type = type;
		}

		public function get defaultSkin():String {
			return _defaultSkin;
		}

		public function set defaultSkin(value:String):void {
			_defaultSkin = value;
		}

		public function get downSkin():String {
			return _downSkin;
		}

		public function set downSkin(value:String):void {
			_downSkin = value;
		}

		public function get overSkin():String {
			return _overSkin;
		}

		public function set overSkin(value:String):void {
			_overSkin = value;
		}

		public function get selected():Boolean {
			return _selected;
		}

		public function set selected(value:Boolean):void {
			_selected = value;
		}

		public function get type():String {
			return _type;
		}

		public function set type(value:String):void {
			_type = value;
		}

	}
}
