package com.snsoft.tsp3 {
	import com.snsoft.tsp3.plugin.BPlugin;
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

		private static const XML_CFG_PLUGIN:String = "start";

		private var errorMsg:String = "";

		private var xmlUrl:String;

		private var xc:XMLConfig;

		private var pluginUrl:String;

		private var _plugin:BPlugin;

		public function PluginLoader(basePath:String, pluginName:String) {
			this.basePath = basePath;
			this.pluginName = pluginName;
			xmlUrl = basePath + "/" + pluginName + "/" + PLUGIN_XML_NAME;
		}

		public function load():void {

			xc = new XMLConfig();
			xc.addEventListener(Event.COMPLETE, handlerLoadXMLCMP);
			xc.addEventListener(IOErrorEvent.IO_ERROR, handlerLoadXMLError);
			xc.load(xmlUrl);
		}

		private function handlerLoadXMLError(e:Event):void {
			dispatchError("加载插件[" + pluginName + "]配置文件出错:" + xmlUrl);
		}

		private function handlerLoadXMLCMP(e:Event):void {
			var swfName:String = xc.getConfig(XML_CFG_PLUGIN);
			if (pluginName == null) {
				dispatchError("加载插件[" + swfName + "]出错：找不到配置项 " + XML_CFG_PLUGIN);
			}
			else {
				pluginUrl = basePath + "/" + pluginName + "/" + swfName;

				var loader:Loader = new Loader();
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

		public function get plugin():BPlugin
		{
			return _plugin;
		}


	}
}
