package com.snsoft.tsp3.plugin.news {
	import com.snsoft.util.di.DependencyInjection;

	public class NewsState {

		private var _cPlateId:String;

		private var _cColumnId:String;

		private var _cClassId:String;

		private var _filter:Object;

		private var _infoId:String;

		private var _digestLength:int;

		private var _infoViewType:String;

		private var _itemViewType:String;

		public function NewsState() {
		}

		public function clone():NewsState {
			var ns:NewsState = new NewsState();
			ns.cPlateId = cPlateId;
			ns.cColumnId = cColumnId;
			ns.cClassId = cClassId;
			ns.infoId = infoId;

			var obj:Object = new Object();
			DependencyInjection.diToObj(filter, obj);
			ns.filter = obj;
			return ns;
		}

		public function filterStr():String {
			var filterStr:String = "";
			for (var name:String in filter) {
				filterStr += (name + ":" + filter[name] + ",");
			}
			filterStr = filterStr.substr(0, filterStr.length - 1);
			return filterStr;
		}

		public function get cPlateId():String {
			return _cPlateId;
		}

		public function set cPlateId(value:String):void {
			_cPlateId = value;
		}

		public function get cColumnId():String {
			return _cColumnId;
		}

		public function set cColumnId(value:String):void {
			_cColumnId = value;
		}

		public function get cClassId():String {
			return _cClassId;
		}

		public function set cClassId(value:String):void {
			_cClassId = value;
		}

		public function get filter():Object {
			return _filter;
		}

		public function set filter(value:Object):void {
			_filter = value;
		}

		public function get infoId():String {
			return _infoId;
		}

		public function set infoId(value:String):void {
			_infoId = value;
		}

		public function get digestLength():int {
			return _digestLength;
		}

		public function set digestLength(value:int):void {
			_digestLength = value;
		}

		public function get infoViewType():String {
			return _infoViewType;
		}

		public function set infoViewType(value:String):void {
			_infoViewType = value;
		}

		public function get itemViewType():String
		{
			return _itemViewType;
		}

		public function set itemViewType(value:String):void
		{
			_itemViewType = value;
		}


	}
}
