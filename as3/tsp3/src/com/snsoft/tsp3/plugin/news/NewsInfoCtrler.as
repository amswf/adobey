package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.Common;
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.tsp3.net.DataLoader;
	import com.snsoft.tsp3.net.DataSet;
	import com.snsoft.tsp3.net.ReqParams;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;

	public class NewsInfoCtrler extends EventDispatcher {

		private var newsInfo:NewsInfo;

		private var url:String;

		private var code:String;

		private var newsState:NewsState;

		public function NewsInfoCtrler(newsInfo:NewsInfo) {
			this.newsInfo = newsInfo;
			super();
		}

		public function refresh(url:String, code:String, newsState:NewsState):void {
			this.url = url;
			this.code = code;
			this.newsState = newsState.clone();
			loadInfo();
		}

		private function loadInfo():void {

			var params:ReqParams = new ReqParams();
			params.addParam(Common.PARAM_PLATE, newsState.cPlateId);
			params.addParam(Common.PARAM_COLUMN, newsState.cColumnId);
			params.addParam(Common.PARAM_INFO, newsState.infoId);

			var dl:DataLoader = new DataLoader();
			dl.addEventListener(Event.COMPLETE, handlerInfoCmp);
			dl.addEventListener(IOErrorEvent.IO_ERROR, handlerInfoError);
			dl.loadData(url, code, Common.OPERATION_INFO, params);
		}

		private function handlerInfoCmp(e:Event):void {
			//trace("handlerInfoCmp");
			var dl:DataLoader = e.currentTarget as DataLoader;
			var rsv:Vector.<DataSet> = dl.data;

			var boardSize:Point = newsInfo.infoSize;
			var itemv:Vector.<Sprite> = new Vector.<Sprite>();
			for (var i:int = 0; i < rsv.length; i++) {
				var rs:DataSet = rsv[i];
				var itype:String = newsState.infoViewType;
				if (itype == null) {
					itype = NewsItemBase.ITEM_TYPE_I;
				}
				for (var j:int = 0; j < rs.dtoList.length; j++) {
					var dto:DataDTO = rs.dtoList[j];
					var board:NewsBoardBase;
					try {
						var MClass:Class;
						MClass = getDefinitionByName("com.snsoft.tsp3.plugin.news.NewsBoard" + itype) as Class;
						board = new MClass(boardSize, dto);
					}
					catch (error:Error) {
						trace(error.getStackTrace());
					}
					if (board != null) {
						newsInfo.refresh(board);
					}
				}
			}
		}

		private function handlerInfoError(e:Event):void {

		}
	}
}
