package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.Common;
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.tsp3.net.DataLoader;
	import com.snsoft.tsp3.net.DataSet;
	import com.snsoft.tsp3.net.Params;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;

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

			var params:Params = new Params();
			params.addParam(Common.PARAM_PLATE, newsState.cPlateId);
			params.addParam(Common.PARAM_COLUMN, newsState.cColumnId);
			params.addParam(Common.PARAM_INFO, newsState.infoId);

			var dl:DataLoader = new DataLoader();
			dl.addEventListener(Event.COMPLETE, handlerInfoCmp);
			dl.addEventListener(IOErrorEvent.IO_ERROR, handlerInfoError);
			dl.loadData(url, code, Common.OPERATION_INFO, params);
		}

		private function handlerInfoCmp(e:Event):void {
			trace("handlerInfoCmp");
			var dl:DataLoader = e.currentTarget as DataLoader;
			var rsv:Vector.<DataSet> = dl.data;

			var itemv:Vector.<Sprite> = new Vector.<Sprite>();
			for (var i:int = 0; i < rsv.length; i++) {
				var rs:DataSet = rsv[i];
				for (var j:int = 0; j < rs.dtoList.length; j++) {
					var dto:DataDTO = rs.dtoList[j];

					var itype:String = newsState.infoViewType;
					var boardSize:Point = newsInfo.infoSize;

					var board:NewsBoardBase;
					if (itype == NewsBoardBase.INFO_TYPE_I) {
						board = new NewsBoardI(boardSize, dto);
					}
					else if (itype == NewsBoardBase.INFO_TYPE_II) {

					}
					else {
						board = new NewsBoardI(boardSize, dto);
					}
					newsInfo.refresh(board);
				}
			}
		}

		private function handlerInfoError(e:Event):void {

		}
	}
}
