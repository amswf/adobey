package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.net.DataParam;

	public class NewsDataParam {

		private static const PARAM_TITLE:String = "title";
		private static const PARAM_DATE:String = "date";
		private static const PARAM_DIGEST:String = "digest";
		private static const PARAM_KEYWORDS:String = "keywords";
		private static const PARAM_CONTENT:String = "content";

		private var _titleParam:DataParam = new DataParam();

		private var _dateParam:DataParam = new DataParam();

		private var _digestParam:DataParam = new DataParam();

		private var _keywordsParam:DataParam = new DataParam();

		private var _contentParam:DataParam = new DataParam();

		private var _extParams:Vector.<DataParam> = new Vector.<DataParam>();

		public function NewsDataParam(params:Vector.<DataParam>) {

			if (params != null) {
				for (var i:int = 0; i < params.length; i++) {
					var param:DataParam = params[i];
					if (param.name == PARAM_TITLE) {
						_titleParam = param;
					}
					else if (param.name == PARAM_DATE) {
						_dateParam = param;
					}
					else if (param.name == PARAM_DIGEST) {
						_digestParam = param;
					}
					else if (param.name == PARAM_KEYWORDS) {
						_keywordsParam = param;
					}
					else if (param.name == PARAM_CONTENT) {
						_contentParam = param;
					}
					else {
						extParams.push(param);
					}
				}
			}
		}

		public function get titleParam():DataParam {
			return _titleParam;
		}

		public function get dateParam():DataParam {
			return _dateParam;
		}

		public function get digestParam():DataParam {
			return _digestParam;
		}

		public function get keywordsParam():DataParam {
			return _keywordsParam;
		}

		public function get extParams():Vector.<DataParam> {
			return _extParams;
		}

		public function get contentParam():DataParam {
			return _contentParam;
		}

	}
}
