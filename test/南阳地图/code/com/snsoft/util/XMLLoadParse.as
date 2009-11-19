package com.snsoft.util
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class XMLLoadParse extends EventDispatcher
	{	
		//XML
		private var xmlUrl:String = null;
		
		private var recordSet:RecordSet = new RecordSet();
		
		/**
		 * 
		 */
		public function XMLLoadParse(xmlUrl:String)
		{
			this.xmlUrl = xmlUrl;
			//super(this);
		}
		
		public function parse():void{
			if (this.xmlUrl != null) {
				var xmlUrl:String = this.xmlUrl;
				var xmlLoader:URLLoader = new URLLoader();
				xmlLoader.addEventListener(Event.COMPLETE, completeHandler);
				xmlLoader.load(new URLRequest(xmlUrl));
				
				xmlLoader.addEventListener(Event.COMPLETE, completeHandler);
				xmlLoader.load(new URLRequest(xmlUrl));
			}
		}
		
		/**
		 * 解析XML文件,针对类似数据结果集的结构的XML文件进行解析.
		 * XML分二层，根级(结果集)名称xml,二级(一个结果，对应类似数据的一个记录)名称record
		 */
		public function completeHandler(eventObj:Event):void {
			var xml:XML = new XML(eventObj.currentTarget.data);
			var xmlList:XMLList = xml.children();
			for (var i:int = 0; i<xmlList.length(); i ++) {
				var record:XML = xmlList[i];
				var recordList:XMLList = record.children();
				var rcd:Record = new Record();
				for (var j:int =0; j<recordList.length(); j++) {
					var value:XML = recordList[j];
					rcd.setValue(value.name(),value.text());
				}
				recordSet.push(rcd);
			}
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * 
		 */
		public function getRecordSet():RecordSet {
			return this.recordSet;
		} 
	}
}