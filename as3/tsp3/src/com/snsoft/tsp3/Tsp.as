package com.snsoft.tsp3 {
	import com.snsoft.tsp3.plugin.BPlugin;
	import com.snsoft.util.rlm.rs.RSSwf;
	import com.snsoft.util.xmldom.XMLConfig;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.System;

	public class Tsp extends MyMovieClip {

		private var xmlConfig:XMLConfig = null;

		private var rss:RSSwf = new RSSwf();

		private var PLUGIN_BASE_PATH:String = "plugin";

		private var PLUGIN_SWF_NAME:String = "plugin.swf";

		private var pluginPath:String;

		private var welcome:Welcome;

		private var welcomeLayer:Sprite = new Sprite();

		private var pluginLayer:Sprite = new Sprite();

		private var promptMsgLayer:Sprite = new Sprite();

		public function Tsp() {
			super();
			stage.displayState = StageDisplayState.FULL_SCREEN;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			this.addChild(welcomeLayer);
			this.addChild(pluginLayer);
			this.addChild(promptMsgLayer);

			PromptMsgMng.instance().init(stage);
		}

		override protected function init():void {
			PromptMsgMng.instance().setMsg("a");
			welcome = new Welcome();
			welcome.x = (stage.stageWidth - welcome.width) / 2;
			welcome.y = (stage.stageHeight - welcome.height) / 2;
			welcomeLayer.addChild(welcome);
			welcome.addEventListener(Welcome.EVENT_CLICK_START, handlerStart);
		}

		private function handlerStart(e:Event):void {
			//welcome.visible = false;
			initTsp();
		}

		private function initTsp():void {
			xmlConfig = new XMLConfig();
			xmlConfig.addEventListener(Event.COMPLETE, handlerLoadCfgCmp);
			xmlConfig.load("config.xml");
		}

		private function handlerLoadCfgCmp(e:Event):void {
			trace("handlerLoadCfgCmp");
			var pluginName:String = xmlConfig.getConfig("plugin");

			var pld:PluginLoader = new PluginLoader(PLUGIN_BASE_PATH, pluginName);
			pld.addEventListener(Event.COMPLETE, handlerLoadPluginCmp);
			pld.load();
		}

		private function handlerLoadPluginCmp(e:Event):void {
			trace("handlerLoadPluginCmp");
			var pld:PluginLoader = e.currentTarget as PluginLoader;
			var plg:BPlugin = pld.plugin;
			plg.promptMsgMng
			pluginLayer.addChild(plg);
		}
	}
}
