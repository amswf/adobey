package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.net.DataParam;

	public class NewsDataParam {

		public static const PARAM_TITLE:String = "title";
		public static const PARAM_DATE:String = "date";
		public static const PARAM_DIGEST:String = "digest";
		public static const PARAM_KEYWORDS:String = "keywords";
		public static const PARAM_CONTENT:String = "content";
		public static const PARAM_COMEFROM:String = "comefrom";
		public static const PARAM_AUTHOR:String = "author";
		//导演
		public static const PARAM_VIDEO_DIRECTOR:String = "director";
		//主演
		public static const PARAM_VIDEO_PROTAGONIST:String = "protagonist";

		//供/求
		public static const PARAM_EBUY_TYPE:String = "ebuyType";

		//发布日期
		public static const PARAM_EBUY_PUBLISH_DATE:String = "fabushijian";

		private var intrParams:Array = new Array();

		public static const EBUY_TYPE_SUPL:String = "供应";

		public static const EBUY_TYPE_BUY:String = "求购";

		private var _extParams:Vector.<DataParam> = new Vector.<DataParam>();

		public function NewsDataParam(params:Vector.<DataParam>) {

			if (params != null) {
				for (var i:int = 0; i < params.length; i++) {
					var param:DataParam = params[i];
					if (param.name == PARAM_TITLE
						|| param.name == PARAM_DATE
						|| param.name == PARAM_DIGEST
						|| param.name == PARAM_KEYWORDS
						|| param.name == PARAM_CONTENT
						|| param.name == PARAM_EBUY_TYPE
						|| param.name == PARAM_COMEFROM
						|| param.name == PARAM_AUTHOR
						|| param.name == PARAM_VIDEO_DIRECTOR
						|| param.name == PARAM_VIDEO_PROTAGONIST
						|| param.name == PARAM_EBUY_PUBLISH_DATE) {
						addIntrParam(param, param.name);
					}
					else {
						_extParams.push(param);
					}
				}
			}
		}

		private function addIntrParam(param:DataParam, name:String):void {
			intrParams[name] = param;
		}

		public function getIntrParam(name:String):DataParam {
			return intrParams[name] as DataParam;
		}

		public function get extParams():Vector.<DataParam> {
			return _extParams;
		}

	}
}
