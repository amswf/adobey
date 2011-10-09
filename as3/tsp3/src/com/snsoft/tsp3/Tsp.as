package com.snsoft.tsp3 {
	import com.snsoft.tsp3.plugin.BPlugin;
	import com.snsoft.tsp3.plugin.BPluginEvent;
	import com.snsoft.util.rlm.rs.*;
	import com.snsoft.util.xmldom.XMLConfig;

	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowType;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	public class Tsp extends MySprite implements ITsp {

		private var xmlConfig:XMLConfig = null;

		private var rss:RSSwf = new RSSwf();

		private var PLUGIN_BASE_PATH:String = "plugin/";

		private var PLUGIN_SWF_NAME:String = "plugin.swf";

		private var pluginPath:String;

		private var welcome:Welcome;

		/**
		 * 背景层
		 */
		private var backLayer:Sprite = new Sprite();

		/**
		 * 启动界面层
		 */
		private var welcomeLayer:Sprite = new Sprite();

		/**
		 * 插件层
		 */
		private var pluginLayer:Sprite = new Sprite();

		/**
		 * 桌面插件层
		 */
		private var desktopLayer:Sprite = new Sprite();

		/**
		 * 应用插件层
		 */
		private var windowLayer:Sprite = new Sprite();

		/**
		 * 辅助插件层
		 */
		private var panelLayer:Sprite = new Sprite();

		/**
		 * 弹出信息层
		 */
		private var promptMsgLayer:Sprite = new Sprite();

		private var backSpr:Sprite;

		private var isLoadedPlugin:Boolean = false;

		private var plugins:Array = new Array();

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

			pluginLayer.addChild(desktopLayer);
			pluginLayer.addChild(windowLayer);
			pluginLayer.addChild(panelLayer);

			PromptMsgMng.instance().init(stage);

			Common.instance().initTsp(this);
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
			initTopScreen();
			initTsp();
		}

		private function initTopScreen():void {
			var sc1:Screen = Screen.screens[1];
			var options:NativeWindowInitOptions = new NativeWindowInitOptions();
			options.type = NativeWindowType.UTILITY;
			var win:NativeWindow = new NativeWindow(options);
			win.width = 800;
			win.height = 600;
			win.y = sc1.bounds.y;
			win.activate();
			win.stage.displayState = StageDisplayState.FULL_SCREEN;
			win.stage.scaleMode = StageScaleMode.NO_SCALE;
			Common.instance().initTopStage(win.stage);
			stage.nativeWindow.addEventListener(Event.CLOSE, function(e:Event):void {win.close()});
		}

		private function initTsp():void {
			if (!isLoadedPlugin) {
				isLoadedPlugin = true;
				xmlConfig = new XMLConfig();
				xmlConfig.addEventListener(Event.COMPLETE, handlerLoadCfgCmp);
				xmlConfig.load("tsp.xml");
			}
		}

		private function handlerLoadCfgCmp(e:Event):void {
			var pluginName:String = xmlConfig.getConfig("plugin");
			loadPlugin(pluginName);
		}

		public function loadPlugin(pluginName:String, params:Object = null, uuid:String = null):void {
			var sign:Boolean = true;
			var pld:PluginLoader = null;

			if (uuid != null) {
				pld = getPlugin(uuid);
			}

			if (pld == null) {
				pld = new PluginLoader(PLUGIN_BASE_PATH, pluginName, params, uuid);
				pld.addEventListener(Event.COMPLETE, handlerLoadPluginCmp);
				pld.load();
			}
			else {
				pluginView(pld);
			}
		}

		private function handlerLoadPluginCmp(e:Event):void {
			var pld:PluginLoader = e.currentTarget as PluginLoader;
			var plg:BPlugin = pld.plugin;
			plg.addEventListener(BPluginEvent.PLUGIN_CLOSE, handlerPluginClose);
			plg.addEventListener(BPluginEvent.PLUGIN_MINIMIZE, handlerPluginMinimize);
			addPlugin(pld);
			pluginView(pld);
		}

		private function pluginView(pld:PluginLoader):void {
			var plg:BPlugin = pld.plugin;
			var layer:Sprite = getLayer(plg.type);
			if (layer.numChildren > 0) {
				var tplg:BPlugin = layer.getChildAt(layer.numChildren - 1) as BPlugin;
				if (plg != tplg) {
					layer.swapChildren(plg, tplg);
				}
			}
			plg.visible = true;
		}

		private function getLayer(type:String):Sprite {
			var layer:Sprite;
			if (type == BPlugin.TYPE_DESKTOP) {
				layer = desktopLayer;
			}
			else if (type == BPlugin.TYPE_TOOL) {
				layer = panelLayer;
			}
			else {
				layer = windowLayer;
			}
			return layer;
		}

		private function addPlugin(pld:PluginLoader):void {
			var plg:BPlugin = pld.plugin;
			var layer:Sprite = getLayer(plg.type);
			layer.addChild(plg);
			Common.instance().pluginBarAddBtn(pld.uuid);
			var uuid:String = pld.uuid;
			if (uuid != null && uuid.length > 0) {
				plugins[uuid] = pld;
			}
		}

		private function removePlugin(uuid:String):void {
			var pld:PluginLoader = getPlugin(uuid);
			if (pld != null) {
				try {
					plugins[pld.uuid] = null;
				}
				catch (error:Error) {
					trace("删除plugin出错!");
				}
				try {
					Common.instance().pluginBarRemoveBtn(pld.uuid);
				}
				catch (error:Error) {
				}
				try {
					pld.plugin.removeEventListener(BPluginEvent.PLUGIN_CLOSE, handlerPluginClose);
					pld.plugin.removeEventListener(BPluginEvent.PLUGIN_MINIMIZE, handlerPluginMinimize);
					pld.plugin.parent.removeChild(pld.plugin);
				}
				catch (error:Error) {
					trace("删除plugin出错!");
				}

				try {
					pld.removeEventListener(Event.COMPLETE, handlerLoadPluginCmp);
					pld.close();
				}
				catch (error:Error) {
					trace("删除plugin出错!");
				}

			}
		}

		private function getPlugin(uuid:String):PluginLoader {
			return plugins[uuid] as PluginLoader;
		}

		private function handlerPluginClose(e:Event):void {
			var plg:BPlugin = e.currentTarget as BPlugin;
			removePlugin(plg.uuid);
		}

		private function handlerPluginMinimize(e:Event):void {
			var plg:BPlugin = e.currentTarget as BPlugin;
			plg.visible = false;
		}
	}
}
