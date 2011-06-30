package com.snsoft.ltree {
	import com.snsoft.util.xmldom.Node;

	import flash.display.BitmapData;

	public class LNodeDO {

		private var _node:Node = null;

		private var _parentLNodeDO:LNodeDO = null;

		private var _placeType:int = 0;

		private var _placeTypeList:Vector.<int> = new Vector.<int>();

		private var _layer:int = 0;

		private var _folderClose:BitmapData;

		private var _folderOpen:BitmapData;

		private var _lineBottom:BitmapData;

		private var _lineCenter:BitmapData;

		private var _lineConn:BitmapData;

		private var _lineTop:BitmapData;

		private var _minusBottom:BitmapData;

		private var _minusCenter:BitmapData;

		private var _minusNoLine:BitmapData;

		private var _minusRoot:BitmapData;

		private var _minusTop:BitmapData;

		private var _plusBottom:BitmapData;

		private var _plusCenter:BitmapData;

		private var _plusNoLine:BitmapData;

		private var _plusRoot:BitmapData;

		private var _plusTop:BitmapData;

		private var _page:BitmapData;

		private var _icon:BitmapData;

		public function LNodeDO() {
		}

		public function get node():Node {
			return _node;
		}

		public function set node(value:Node):void {
			_node = value;
		}

		public function get layer():int {
			return _layer;
		}

		public function set layer(value:int):void {
			_layer = value;
		}

		public function get folderClose():BitmapData {
			return _folderClose;
		}

		public function set folderClose(value:BitmapData):void {
			_folderClose = value;
		}

		public function get folderOpen():BitmapData {
			return _folderOpen;
		}

		public function set folderOpen(value:BitmapData):void {
			_folderOpen = value;
		}

		public function get lineBottom():BitmapData {
			return _lineBottom;
		}

		public function set lineBottom(value:BitmapData):void {
			_lineBottom = value;
		}

		public function get lineCenter():BitmapData {
			return _lineCenter;
		}

		public function set lineCenter(value:BitmapData):void {
			_lineCenter = value;
		}

		public function get lineConn():BitmapData {
			return _lineConn;
		}

		public function set lineConn(value:BitmapData):void {
			_lineConn = value;
		}

		public function get lineTop():BitmapData {
			return _lineTop;
		}

		public function set lineTop(value:BitmapData):void {
			_lineTop = value;
		}

		public function get minusBottom():BitmapData {
			return _minusBottom;
		}

		public function set minusBottom(value:BitmapData):void {
			_minusBottom = value;
		}

		public function get minusCenter():BitmapData {
			return _minusCenter;
		}

		public function set minusCenter(value:BitmapData):void {
			_minusCenter = value;
		}

		public function get minusNoLine():BitmapData {
			return _minusNoLine;
		}

		public function set minusNoLine(value:BitmapData):void {
			_minusNoLine = value;
		}

		public function get minusRoot():BitmapData {
			return _minusRoot;
		}

		public function set minusRoot(value:BitmapData):void {
			_minusRoot = value;
		}

		public function get minusTop():BitmapData {
			return _minusTop;
		}

		public function set minusTop(value:BitmapData):void {
			_minusTop = value;
		}

		public function get plusBottom():BitmapData {
			return _plusBottom;
		}

		public function set plusBottom(value:BitmapData):void {
			_plusBottom = value;
		}

		public function get plusCenter():BitmapData {
			return _plusCenter;
		}

		public function set plusCenter(value:BitmapData):void {
			_plusCenter = value;
		}

		public function get plusNoLine():BitmapData {
			return _plusNoLine;
		}

		public function set plusNoLine(value:BitmapData):void {
			_plusNoLine = value;
		}

		public function get plusRoot():BitmapData {
			return _plusRoot;
		}

		public function set plusRoot(value:BitmapData):void {
			_plusRoot = value;
		}

		public function get plusTop():BitmapData {
			return _plusTop;
		}

		public function set plusTop(value:BitmapData):void {
			_plusTop = value;
		}

		public function get page():BitmapData {
			return _page;
		}

		public function set page(value:BitmapData):void {
			_page = value;
		}

		public function get icon():BitmapData {
			return _icon;
		}

		public function set icon(value:BitmapData):void {
			_icon = value;
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

		public function get parentLNodeDO():LNodeDO
		{
			return _parentLNodeDO;
		}

		public function set parentLNodeDO(value:LNodeDO):void
		{
			_parentLNodeDO = value;
		}


	}
}
