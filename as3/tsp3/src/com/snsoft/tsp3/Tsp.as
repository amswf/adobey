package com.snsoft.tsp3 {
	import com.snsoft.tsp3.plugin.BPlugin;
	import com.snsoft.util.rlm.rs.*;
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

		private var backLayer:Sprite = new Sprite();

		private var welcomeLayer:Sprite = new Sprite();

		private var pluginLayer:Sprite = new Sprite();

		private var promptMsgLayer:Sprite = new Sprite();

		private var backSpr:Sprite;

		private var isLoadedPlugin:Boolean = false;

		public function Tsp() {
			//注册动态调用的类
			com.snsoft.util.rlm.rs.RSImages;
			com.snsoft.util.rlm.rs.RSEmbedFonts;
			com.snsoft.util.rlm.rs.RSSound;
			com.snsoft.util.rlm.rs.RSSwf;
			com.snsoft.util.rlm.rs.RSTextFile;

			super();

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			this.addChild(backLayer);
			this.addChild(welcomeLayer);
			this.addChild(pluginLayer);
			this.addChild(promptMsgLayer);

			PromptMsgMng.instance().init(stage);
		}

		override protected function init():void {

			backSpr = ViewUtil.creatRect(100, 100, 0xffffff, 1);
			backLayer.addChild(backSpr);

			//PromptMsgMng.instance().setMsg("a");

			welcome = new Welcome();
			welcomeLayer.addChild(welcome);
			welcome.addEventListener(Welcome.EVENT_CLICK_START, handlerStart);

			stage.nativeWindow.x = (stage.fullScreenWidth - welcome.width) / 2;
			stage.nativeWindow.y = (stage.fullScreenHeight - welcome.height) / 2;

			stage.addEventListener(Event.RESIZE, handlerStageResize);
		}

		private function handlerStageResize(e:Event):void {
			backSpr.width = stage.stageWidth;
			backSpr.height = stage.stageHeight;

			var sign:Boolean = stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE;
			welcome.visible = !sign;
			pluginLayer.visible = sign;
			backSpr.visible = sign;
		}

		private function handlerStart(e:Event):void {
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			initTsp();
		}

		private function initTsp():void {
			if (!isLoadedPlugin) {
				isLoadedPlugin = true;
				xmlConfig = new XMLConfig();
				xmlConfig.addEventListener(Event.COMPLETE, handlerLoadCfgCmp);
				xmlConfig.load("config.xml");
			}
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
			pluginLayer.addChild(plg);
		}
	}
}
