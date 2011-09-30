package com.snsoft.util.xmldom {
	import com.snsoft.util.HashVector;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * 配置信息快速访问类
	 *
	 * 默认XML为：〈xml〉〈property name="" value="" /〉〈/xml〉
	 *
	 * <xml><property name="" value="" /></xml>
	 *
	 * @author Administrator
	 *
	 */

	[Event(name = "complete", type = "flash.events.Event")]
	[Event(name = "ioError", type = "flash.events.IOErrorEvent")]

	public class XMLConfig extends EventDispatcher {

		private var configXmlUrl:String = null;

		private var configHV:HashVector = new HashVector();

		private var propertyTagName:String = null;

		private var propertyName:String = null;

		private var propertyValue:String = null;

		public function XMLConfig() {

		}

		/**
		 * 默认XML为：〈xml〉〈property name="" value="" /〉〈/xml〉,
		 *
		 * @param configXmlUrl
		 * @param propertyTagName 对应 〈property〉
		 * @param propertyName 对应 name
		 * @param propertyValue 对应 value
		 *
		 */
		public function load(configXmlUrl:String, propertyTagName:String = "property", propertyName:String = "name", propertyValue:String = "value"):void {
			this.propertyTagName = propertyTagName;
			this.propertyName = propertyName;
			this.propertyValue = propertyValue;
			this.configXmlUrl = configXmlUrl;
			this.loadConfig();
		}

		/**
		 * 默认XML为：〈xml〉〈property name="" value="" /〉〈/xml〉,
		 * @param configXml
		 * @param propertyTagName
		 * @param propertyName
		 * @param propertyValue
		 *
		 */
		public function parse(configXml:XML, propertyTagName:String = "property", propertyName:String = "name", propertyValue:String = "value"):void {
			this.propertyTagName = propertyTagName;
			this.propertyName = propertyName;
			this.propertyValue = propertyValue;
			this.parseConfig(configXml);
		}

		/**
		 *
		 *
		 */
		private function loadConfig():void {
			var request:URLRequest = new URLRequest(configXmlUrl);
			var loader:URLLoader = new URLLoader();
			loader.load(request);
			loader.addEventListener(Event.COMPLETE, handlerConfigLoadComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, handlerConfigLoadIOError);
		}

		/**
		 *
		 * @param e
		 *
		 */
		private function handlerConfigLoadIOError(e:Event):void {
			trace("地址错误：", configXmlUrl);
			dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
		}

		/**
		 *
		 * @param e
		 *
		 */
		private function handlerConfigLoadComplete(e:Event):void {
			var loader:URLLoader = e.currentTarget as URLLoader;
			var xml:XML = new XML(loader.data);
			parseConfig(xml);
			dispatchEvent(new Event(Event.COMPLETE));
		}

		/**
		 *
		 * @param e
		 *
		 */
		private function parseConfig(xml:XML):void {

			var xmldom:XMLDom = new XMLDom(xml);
			var configNode:Node = xmldom.parse();
			var propertyNodeList:NodeList = configNode.getNodeList(propertyTagName);
			for (var i:int = 0; i < propertyNodeList.length(); i++) {
				var propertyNode:Node = propertyNodeList.getNode(i);
				var name:String = propertyNode.getAttributeByName(propertyName);
				var value:String = propertyNode.getAttributeByName(propertyValue);
				if (name != null && name.length > 0) {
					configHV.push(value, name);
				}
			}
		}

		/**
		 * 获得配置项值
		 * @param name
		 * @return
		 *
		 */
		public function getConfig(name:String):String {
			return configHV.findByName(name) as String;
		}

		public function getConfigName(i:int):String {
			return configHV.findNameByIndex(i);
		}

		public function getConfigByIndex(i:int):String {
			return configHV.findByIndex(i) as String;
		}

		public function configToObj(obj:Object):void {
			for (var i:int = 0; i < configHV.length; i++) {
				var name:String = configHV.findNameByIndex(i);
				trace(obj);
				try {
					obj[name] = configHV.findByIndex(i);
					trace("hasOwnProperty", name);
				}
				catch (e:Error) {
					trace(e.getStackTrace());
				}
			}
		}

		public function length():int {
			return configHV.length;
		}

		/**
		 * 获得配置项值
		 * @param name
		 * @return
		 *
		 */
		public function getCfgInt(name:String):int {
			return parseInt(getConfig(name));
		}
	}
}
