package com.snsoft.tsp3 {
	import com.snsoft.tsp3.plugin.desktop.IDesktop;

	import flash.display.Sprite;
	import flash.display.Stage;

	public class Common {

		private static var lock:Boolean = false;

		private static var common:Common = new Common();

		private var _serverRootUrl:String = "";

		private var _dataUrl:String;

		private var tsp:ITsp;

		private var deskTop:IDesktop;

		private var topStage:Stage;

		public function Common() {
			if (lock) {
				throw(new Error("Common can not new"));
			}
			lock = true;
		}

		public function initTopStage(stage:Stage):void {
			topStage = stage;
		}

		public function hasTopStage():Boolean {
			return (topStage != null);
		}

		public function playVideo(video:Sprite):void {
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

		public function loadPlugin(pluginName:String, params:Object = null, uuid:String = null):void {
			if (tsp != null) {
				tsp.loadPlugin(pluginName, params, uuid);
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

	}
}
