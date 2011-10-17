package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.Common;
	import com.snsoft.tsp3.net.Params;
	import com.snsoft.util.di.DependencyInjection;

	public class NewsState {

		private var _cPlateId:String;

		private var _cColumnId:String;

		private var _cClassId:String;

		private var _filter:Object;

		private var _infoId:String;

		private var _pageNum:int;

		private var _pageSize:int;

		private var _digestLength:int;

		private var _infoViewType:String;

		private var _itemViewType:String;

		private var _searchText:String;

		private var _type:String;

		/**
		 * 关键词搜索
		 */
		public static const TYPE_SEARCH:String = "search";

		/**
		 * 筛选条件
		 */
		public static const TYPE_FACTOR:String = "factor";

		/**
		 * 和某条信息相关的
		 */
		public static const TYPE_RELATED:String = "related";

		public function NewsState() {
		}

		public function clone():NewsState {
			var ns:NewsState = new NewsState();
			ns.cPlateId = cPlateId;
			ns.cColumnId = cColumnId;
			ns.cClassId = cClassId;
			ns.infoId = infoId;
			ns.pageNum = pageNum;
			ns.digestLength = digestLength;
			ns.infoViewType = infoViewType;
			ns.itemViewType = itemViewType;
			ns.searchText = searchText;
			ns.type = type;

			var obj:Object = new Object();
			DependencyInjection.diToObj(filter, obj, false);
			ns.filter = obj;
			return ns;
		}

		public function filterStr():String {
			var filterStr:String = "";
			if (filter != null) {
				for (var name:String in filter) {
					filterStr += (name + ":" + filter[name] + ",");
				}
				filterStr = filterStr.substr(0, filterStr.length - 1);
			}
			return filterStr;
		}

		public function toParams():Params {
			var params:Params = new Params();
			params.addParam(Common.PARAM_PLATE, cPlateId);
			params.addParam(Common.PARAM_COLUMN, cColumnId);
			params.addParam(Common.PARAM_CLASS, cClassId);
			params.addParam(Common.PARAM_INFO, infoId);
			params.addParam(Common.PARAM_DIGEST_LENGTH, String(digestLength));
			params.addParam(Common.PARAM_WORD, searchText);
			params.addParam(Common.PARAM_TYPE, type);
			params.addParam(Common.PARAM_PAGE_NUM, String(pageNum));
			params.addParam(Common.PARAM_PAGE_SIZE, String(pageSize));
			params.addParam("filter", filterStr());
			return params;
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

		public function get itemViewType():String {
			return _itemViewType;
		}

		public function set itemViewType(value:String):void {
			_itemViewType = value;
		}

		public function get searchText():String {
			return _searchText;
		}

		public function set searchText(value:String):void {
			_searchText = value;
		}

		public function get type():String {
			return _type;
		}

		public function set type(value:String):void {
			_type = value;
		}

		public function get pageNum():int {
			return _pageNum;
		}

		public function set pageNum(value:int):void {
			_pageNum = value;
		}

		public function get pageSize():int {
			return _pageSize;
		}

		public function set pageSize(value:int):void {
			_pageSize = value;
		}

	}
}
