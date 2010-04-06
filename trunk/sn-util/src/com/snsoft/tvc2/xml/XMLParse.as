package com.snsoft.tvc2.xml{
	import com.snsoft.tvc2.dataObject.MainDO;
	import com.snsoft.tvc2.dataObject.VarDO;
	import com.snsoft.util.HashVector;
	
	/**
	 * xml解析 
	 * @author Administrator
	 * 
	 */	
	public class XMLParse{
		
		public function XMLParse(){
		}
		
		/**
		 * 解析主数据XML 
		 * @param xml
		 * @return 
		 * 
		 */		
		public function parseTvcMainXML(xml:XML):MainDO{
			var mdo:MainDO = new MainDO();
			var varXML:XML = xml.elements("vars")[0];
			var varDOHv:HashVector = this.parseVarsXML(varXML);
			
			return null;
		}
		
		/**
		 * 解析变量列表 "var" 
		 * @param varsXML
		 * @return 
		 * 
		 */		
		private function parseVarsXML(varsXML:XML):HashVector{
			var varList:XMLList = varsXML.elements("var");
			var v:HashVector = new HashVector();
			for(var i:int = 0;i<varList.length();i++){
				var varXML:XML = varList[i];
				var vdo:VarDO = new VarDO();
				var vdoName:String = String(varXML.attribute(VarDO.NAME));
				var varAttributeXMLList:XMLList = varXML.attributes();
				for(var j:int = 0;j<varAttributeXMLList.length();j++){
					var varAttributeXML:XML = varAttributeXMLList[j];
					var name:String = varAttributeXML.name();
					var value:String = varAttributeXML.toString(); 
					vdo.setAttribute(name,value);
				}
				v.put(vdoName,vdo);
			}
			return v;
		}
	}
}