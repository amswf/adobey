package tvc.config
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * 解析配置文件,获得程序中用到的静态参数.
	 * 
	 */
	public class ParseConfigXML
	{
		//解析成功标识
		private var isParseComplete:Boolean = false;
		
		//解析成功得到的结果集
		private var resultSet:TextViewList = null;
		
		
		public function getIsParseComplete():Boolean{
			return this.isParseComplete;
		}
		
		public function getResultSet():TextViewList{
			return this.resultSet;
		}
		/**
		 * 构造方法
		 */
		public function ParseConfigXML(){
			
		}
		
		/**
		 * 解析XML文件,得到结果集放到
		 * 
		 */
		public function parseXML(xmlurl:String):void{
			//读取XML文件
			var configRequest:URLRequest = new URLRequest(xmlurl);
			var configLoader:URLLoader = new URLLoader();
			configLoader.addEventListener(Event.COMPLETE,handlerConfigLoader);
			configLoader.load(configRequest);
		}
		/**
		 * 读取XML,Event.COMPLETE(完成)事件句柄.
		 * 
		 * 解析文件放到结果集中
		 * 
		 */
		private function handlerConfigLoader(eventObj:Event):void{
			var configXML:XML = new XML(eventObj.currentTarget.data);
			var configXMLList:XMLList = configXML.children();
			//文本信息记录集
			var tvl:TextViewList = new TextViewList();
			for(var i:int = 0 ;i < configXMLList.length(); i ++){
				var textOutXML:XML = configXMLList[i];
				var textOutXMLList:XMLList = textOutXML.children();
				var tv:TextView = new TextView();
				//输出文本
				var textXML:XML = textOutXMLList[0];
				tv.setTextOut(textXML.text());
				//文本X坐标
				var xXML:XML = textOutXMLList[1];
				tv.setX(xXML.text());
				//文本Y坐标
				var yXML:XML = textOutXMLList[2];
				tv.setY(yXML.text());
				tvl.push(tv);
			}
			if(tvl.getLength() > 0){
				this.resultSet = tvl;
				this.isParseComplete = true;
			}
		}
		
	}
}