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
	public class XMLStaticConfig extends EventDispatcher {

		private static var configXmlUrl:String = null;

		private static var configHV:HashVector = new HashVector();

		private static var isLoaded:Boolean = false;

		private static var propertyTagName:String = null;

		private static var propertyName:String = null;

		private static var propertyValue:String = null;

		private static var isInstance:Boolean = false;

		public function XMLStaticConfig() {
			if (!isInstance) {
				throw new Error("XMLFastConfig 不能用new 初始化，请使用静态方法：XMLFastConfig.instance();");
			}
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
		public static function instance(configXmlUrl:String, handlerLoadComplete:Function, propertyTagName:String = "property", propertyName:String = "name", propertyValue:String = "value"):void {
			XMLStaticConfig.propertyTagName = propertyTagName;
			XMLStaticConfig.propertyName = propertyName;
			XMLStaticConfig.propertyValue = propertyValue;
			XMLStaticConfig.configXmlUrl = configXmlUrl;
			isInstance = true;
			var xmlfc:XMLStaticConfig = new XMLStaticConfig();
			isInstance = false;
			xmlfc.loadConfig();
			xmlfc.addEventListener(Event.COMPLETE, handlerLoadComplete);
		}

		public static function instanceByXML(configXml:XML, propertyTagName:String = "property", propertyName:String = "name", propertyValue:String = "value"):void {
			XMLStaticConfig.propertyTagName = propertyTagName;
			XMLStaticConfig.propertyName = propertyName;
			XMLStaticConfig.propertyValue = propertyValue;
			parseConfig(configXml);
		}

		/**
		 *
		 *
		 */
		public function loadConfig():void {
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
			isLoaded = true;
			dispatchEvent(new Event(Event.COMPLETE));
		}

		/**
		 *
		 * @param e
		 *
		 */
		private static function parseConfig(xml:XML):void {

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
		public static function getConfig(name:String):String {
			return configHV.findByName(name) as String;
		}
		
		/**
		 * 获得配置项值 
		 * @param name
		 * @return 
		 * 
		 */		
		public static function getCfgInt(name:String):int{
			return parseInt(getConfig(name));
		}
	}
}
