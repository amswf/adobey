package com.snsoft.tsp3 {
	import com.snsoft.tsp3.plugin.BPlugin;
	import com.snsoft.util.di.DependencyInjection;
	import com.snsoft.util.di.ObjectProperty;
	import com.snsoft.util.xmldom.XMLConfig;

	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	[Event(name = "complete", type = "flash.events.Event")]
	[Event(name = "ioError", type = "flash.events.IOErrorEvent")]

	public class PluginLoader extends EventDispatcher {

		private var basePath:String;

		private var pluginName:String;

		private static const PLUGIN_XML_NAME:String = "version.xml";

		private var errorMsg:String = "";

		private var xmlUrl:String;

		private var xc:XMLConfig;

		private var pluginUrl:String;

		private var _plugin:BPlugin;

		private var relativeUrl:String;

		private var params:Object;

		private var plv:PluginVersion = new PluginVersion();

		private var _uuid:String;

		private var loader:Loader;

		public function PluginLoader(basePath:String, pluginName:String, params:Object = null, uuid:String = null) {
			this.basePath = basePath;
			this.pluginName = pluginName;
			this.params = params;
			this._uuid = uuid;

			relativeUrl = basePath + pluginName + "/";
			xmlUrl = relativeUrl + PLUGIN_XML_NAME;
		}

		public function load():void {

			xc = new XMLConfig();
			xc.addEventListener(Event.COMPLETE, handlerLoadXMLCMP);
			xc.addEventListener(IOErrorEvent.IO_ERROR, handlerLoadXMLError);
			xc.load(xmlUrl);
		}

		public function close():void {
			try {
				xc.removeEventListener(Event.COMPLETE, handlerLoadXMLCMP);
				xc.removeEventListener(IOErrorEvent.IO_ERROR, handlerLoadXMLError);
			}
			catch (e:Error) {
			}

			try {
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handlerLoadPluginCmp);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handlerLoadPluginError);
				loader.unloadAndStop();
			}
			catch (e:Error) {
			}
		}

		private function handlerLoadXMLError(e:Event):void {
			dispatchError("加载插件[" + pluginName + "]配置文件出错:" + xmlUrl);
		}

		private function handlerLoadXMLCMP(e:Event):void {

			for (var i:int = 0; i < xc.length(); i++) {
				var name:String = xc.getConfigName(i);
				try {
					plv[name] = xc.getConfigByIndex(i);
				}
				catch (e:Error) {
				}
			}

			var swfName:String = plv.start;
			if (pluginName == null) {
				dispatchError("加载插件[" + swfName + "]出错：找不到配置项  [start]");
			}
			else {
				pluginUrl = relativeUrl + swfName;

				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handlerLoadPluginCmp);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handlerLoadPluginError);
				loader.load(new URLRequest(pluginUrl));
			}
		}

		private function handlerLoadPluginCmp(e:Event):void {
			var info:LoaderInfo = e.currentTarget as LoaderInfo;
			var bp:BPlugin = info.content as BPlugin;
			if (bp == null) {
				dispatchError("加载插件[" + pluginName + "]出错:swf文件不是插件。");
			}
			else {
				if (bp.params != null) {
					DependencyInjection.diToObj(params, bp.params);
				}
				else {
					bp.params = params;
				}
				bp.pluginUrl = relativeUrl;
				bp.type = plv.type;
				bp.uuid = uuid;
				_plugin = bp;
				dispatchCmp();
			}
		}

		private function handlerLoadPluginError(e:Event):void {
			dispatchError("加载插件[" + pluginName + "]出错:" + pluginUrl);
		}

		private function dispatchError(errorMsg:String):void {
			this.errorMsg = errorMsg;
			trace(this.errorMsg);
			this.dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
		}

		private function dispatchCmp():void {
			this.dispatchEvent(new Event(Event.COMPLETE));
		}

		public function get plugin():BPlugin {
			return _plugin;
		}

		public function get uuid():String {
			return _uuid;
		}

	}
}
