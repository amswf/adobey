package com.snsoft.tsp3 {
	import com.snsoft.tsp3.plugin.desktop.IDesktop;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;

	public class Common {

		public static const OPERATION_PLATE:String = "plate";

		public static const OPERATION_COLUMN:String = "column";

		public static const OPERATION_CLASS:String = "class";

		public static const OPERATION_FILTER:String = "filter";

		public static const OPERATION_SEARCH:String = "search";

		public static const OPERATION_SEARCH_RELATED:String = "searchRelated";

		public static const OPERATION_INFO:String = "info";

		public static const PARAM_PLATE:String = "plateId";

		public static const PARAM_COLUMN:String = "columnId";

		public static const PARAM_CLASS:String = "classId";

		public static const PARAM_FILTER:String = "filter";

		public static const PARAM_PAGE_NUM:String = "pageNum";

		public static const PARAM_PAGE_SIZE:String = "pageSize";

		public static const PARAM_DIGEST_LENGTH:String = "digestLength";

		public static const PARAM_INFO:String = "infoId";

		public static const PARAM_WORD:String = "word";

		public static const PARAM_TYPE:String = "type";

		private static var lock:Boolean = false;

		private static var common:Common = new Common();

		private var _serverRootUrl:String = "";

		private var _dataUrl:String;

		private var _dataCode:String;

		private var tsp:ITsp;

		private var deskTop:IDesktop;

		private var topStage:Stage;

		private var defImg:BitmapData = new BitmapData(100, 100);

		private var player:IPlayer;

		public function Common() {
			if (lock) {
				throw(new Error("Common can not new"));
			}
			lock = true;
		}

		public function initPlayer(player:IPlayer):void {
			this.player = player;
		}

		public function playMp3(url:String, title:String):void {
			if (player != null) {
				player.setVisible(true);
				player.playMp3(url, title);
			}
		}

		public function playVideo(url:String, title:String):void {
			if (player != null) {
				player.setVisible(true);
				player.playVideo(url, title);
			}
		}

		public function initTopStage(stage:Stage):void {
			topStage = stage;
		}

		public function hasTopStage():Boolean {
			return (topStage != null);
		}

		public function topScreenPlayVideo(video:Sprite):void {
			if (topStage != null) {
				topStage.addChild(video);
			}
		}

		public function removeVideo():void {
			if (topStage != null) {
				while (topStage.numChildren > 0) {
					topStage.removeChildAt(0);
				}
			}
		}

		public function initTsp(tsp:ITsp):void {
			this.tsp = tsp;
		}

		public function initDesktop(deskTop:IDesktop):void {
			this.deskTop = deskTop;
		}

		public function pluginBarAddBtn(uuid:String):void {
			if (this.deskTop != null) {
				this.deskTop.pluginBarAddBtn(uuid);
			}
		}

		public function pluginBarRemoveBtn(uuid:String):void {
			if (this.deskTop != null) {
				this.deskTop.pluginBarRemoveBtn(uuid);
			}
		}

		public function loadPlugin(pluginName:String, params:Object = null, uuid:String = null, defVisible:Boolean = true):void {
			if (tsp != null) {
				tsp.loadPlugin(pluginName, params, uuid, defVisible);
			}
		}

		public static function instance():Common {
			return common;
		}

		public function get serverRootUrl():String {
			return _serverRootUrl;
		}

		public function set serverRootUrl(value:String):void {
			_serverRootUrl = value;
		}

		public function get dataUrl():String {
			return _dataUrl;
		}

		public function set dataUrl(value:String):void {
			_dataUrl = value;
		}

		public function get dataCode():String {
			return _dataCode;
		}

		public function set dataCode(value:String):void {
			_dataCode = value;
		}

	}
}
