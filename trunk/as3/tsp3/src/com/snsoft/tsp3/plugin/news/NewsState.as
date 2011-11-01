package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.Common;
	import com.snsoft.tsp3.net.ReqParams;
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

		private var _detailViewType:String;

		private var _listViewType:String;

		private var _searchText:String;

		private var _type:String;

		//显示列数（后台数据）
		private var _columnNumber:int;

		//显示列数（跟据样式处理后真实列数）
		private var _pageCol:int;

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
			ns.filter = filter;
			ns.infoId = infoId;
			ns.pageNum = pageNum;
			ns.pageSize = pageSize;
			ns.digestLength = digestLength;
			ns.detailViewType = detailViewType;
			ns.listViewType = listViewType;
			ns.searchText = searchText;
			ns.type = type;
			ns.pageCol = pageCol;

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

		public function toParams():ReqParams {
			var params:ReqParams = new ReqParams();
			params.addParam(Common.PARAM_PLATE, cPlateId);
			params.addParam(Common.PARAM_COLUMN, cColumnId);
			params.addParam(Common.PARAM_CLASS, cClassId);
			params.addParam(Common.PARAM_FILTER, filterStr());
			params.addParam(Common.PARAM_INFO, infoId);
			params.addParam(Common.PARAM_PAGE_NUM, String(pageNum));
			params.addParam(Common.PARAM_PAGE_SIZE, String(pageSize * pageCol));
			params.addParam(Common.PARAM_DIGEST_LENGTH, String(digestLength));
			params.addParam(Common.PARAM_WORD, searchText);
			params.addParam(Common.PARAM_TYPE, type);
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

		public function get detailViewType():String {
			return _detailViewType;
		}

		public function set detailViewType(value:String):void {
			_detailViewType = value;
		}

		public function get listViewType():String {
			return _listViewType;
		}

		public function set listViewType(value:String):void {
			_listViewType = value;
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

		public function get columnNumber():int {
			return _columnNumber;
		}

		public function set columnNumber(value:int):void {
			_columnNumber = value;
		}

		public function get pageCol():int {
			return _pageCol;
		}

		public function set pageCol(value:int):void {
			_pageCol = value;
		}

	}
}
