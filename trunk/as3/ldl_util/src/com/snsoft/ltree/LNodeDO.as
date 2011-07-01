package com.snsoft.ltree {
	import com.snsoft.util.xmldom.Node;

	import flash.display.BitmapData;

	public class LNodeDO {

		private var _name:String;

		private var _id:String;

		private var _text:String;

		private var _open:Boolean;

		private var _parent:Boolean;

		private var _dync:Boolean;

		private var _icon:String;

		private var _parentLNodeDO:LNodeDO = null;

		private var _placeType:int = 0;

		private var _placeTypeList:Vector.<int> = new Vector.<int>();

		private var _layer:int = 0;

		private var _images:LNodeImgs;

		public function LNodeDO() {
		}

		public function get layer():int {
			return _layer;
		}

		public function set layer(value:int):void {
			_layer = value;
		}

		public function get placeTypeList():Vector.<int> {
			return _placeTypeList;
		}

		public function set placeTypeList(value:Vector.<int>):void {
			_placeTypeList = value;
		}

		public function get placeType():int {
			return _placeType;
		}

		public function set placeType(value:int):void {
			_placeType = value;
		}

		public function get parentLNodeDO():LNodeDO {
			return _parentLNodeDO;
		}

		public function set parentLNodeDO(value:LNodeDO):void {
			_parentLNodeDO = value;
		}

		public function get images():LNodeImgs {
			return _images;
		}

		public function set images(value:LNodeImgs):void {
			_images = value;
		}

		public function get name():String {
			return _name;
		}

		public function set name(value:String):void {
			_name = value;
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

		public function get open():Boolean {
			return _open;
		}

		public function set open(value:Boolean):void {
			_open = value;
		}

		public function get parent():Boolean {
			return _parent;
		}

		public function set parent(value:Boolean):void {
			_parent = value;
		}

		public function get dync():Boolean
		{
			return _dync;
		}

		public function set dync(value:Boolean):void
		{
			_dync = value;
		}

		public function get icon():String
		{
			return _icon;
		}

		public function set icon(value:String):void
		{
			_icon = value;
		}


	}
}
