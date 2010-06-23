﻿package com.snsoft.tvc2.xml{
	import ascb.util.StringUtilities;
	
	import com.snsoft.tvc2.dataObject.BizDO;
	import com.snsoft.tvc2.dataObject.DataDO;
	import com.snsoft.tvc2.dataObject.ListDO;
	import com.snsoft.tvc2.dataObject.MainDO;
	import com.snsoft.tvc2.dataObject.MarketCoordDO;
	import com.snsoft.tvc2.dataObject.MarketCoordsDO;
	import com.snsoft.tvc2.dataObject.MarketMainDO;
	import com.snsoft.tvc2.dataObject.MediaDO;
	import com.snsoft.tvc2.dataObject.MediasDO;
	import com.snsoft.tvc2.dataObject.SoundDO;
	import com.snsoft.tvc2.dataObject.SoundsDO;
	import com.snsoft.tvc2.dataObject.TextOutDO;
	import com.snsoft.tvc2.dataObject.TextOutsDO;
	import com.snsoft.tvc2.dataObject.TextPointDO;
	import com.snsoft.tvc2.dataObject.TimeLineDO;
	import com.snsoft.tvc2.dataObject.VarDO;
	import com.snsoft.util.HashVector;
	
	import flash.geom.Point;
	
	 
	
	/**
	 * xml解析 
	 * @author Administrator
	 * 
	 */	
	public class XMLParse{
		
		/**
		 * tag name 
		 */		
		
		public static const TAG_VARS:String = "vars";
		
		public static const TAG_VAR:String = "var";
		
		public static const TAG_TIMELINE:String = "timeLine";
		
		public static const TAG_BIZ:String = "biz";
		
		public static const TAG_SOUNDS:String = "sounds";
		
		public static const TAG_SOUND:String = "sound";
		
		public static const TAG_TEXTOUTS:String = "textOuts";
		
		public static const TAG_TEXTOUT:String = "textOut";
		
		public static const TAG_MEDIAS:String = "medias";
		
		public static const TAG_MEDIA:String = "media";
		
		public static const TAG_DATA:String = "data";
		
		public static const TAG_CHART:String = "chart";
		
		public static const X_GRADUATION_TEXT:String = "xGraduationText";
		
		public static const Y_GRADUATION_TEXT:String = "yGraduationText";
		
		public static const TAG_DISTRIBUTE:String = "distribute";
		
		public static const TAG_BROADCAST:String = "broadcast";
		
		public static const TAG_LIST:String = "list";
		
		public static const TAG_TEXTPOINT:String = "textPoint";
		
		public static const TAG_MARKET_COORDS:String = "marketCoords";
		
		public static const TAG_MARKET_COORD:String = "marketCoord";
		
		/**
		 * Attribute name 
		 */
		
		public static const ATT_NAME:String = "name";
		
		public static const ATT_VALUE:String = "value";
		
		public static const ATT_TEXT:String = "text";
		
		public static const ATT_URL:String = "url";
		
		public static const ATT_TYPE:String = "type";
		
		public static const ATT_X:String = "x";
		
		public static const ATT_Y:String = "y";
		
		public static const ATT_Z:String = "z";
		
		public static const ATT_S:String = "s";
		
		public static const ATT_SCALEX:String = "scaleX";
		
		public static const ATT_SCALEY:String = "scaleY";
		
		public static const ATT_TIMEOFFSET:String = "timeOffset";
		
		public static const ATT_TIMELENGTH:String = "timeLength";
		
		public static const ATT_TIMEOUT:String = "timeout";
		
		public static const ATT_STYLE:String = "style";
		
		public function XMLParse(){
			
		}
		
		/**
		 * 解析主数据XML 
		 * @param xml
		 * @return 
		 * 
		 */		
		public function parseTvcMainXML(xml:XML):MainDO{
			
			//全数据对象
			var mdo:MainDO = new MainDO();
			
			//解析 全局 var
			var varsXMLList:XMLList = xml.elements(TAG_VARS); 
			mdo.mainVarDOHv = this.parseVarsXML(varsXMLList);
			
			//解析timeLine
			var timeLinesXMLList:XMLList = xml.elements(TAG_TIMELINE);
			mdo.timeLineDOHv = this.parseTimeLinesXML(timeLinesXMLList);
			
			return mdo;
		}
		
		/**
		 * 解析市场主方法 
		 * @param xml
		 * @return 
		 * 
		 */		
		public function parseMarketCoordsMain(xml:XML):MarketMainDO{
			var mmdo:MarketMainDO = new MarketMainDO();
			var marketCoordsXMLList:XMLList = xml.elements(TAG_MARKET_COORDS);
			var mcsdoHv:HashVector = parseMarketCoords(marketCoordsXMLList);
			mmdo.marketCoordsDOHV = mcsdoHv;
			return mmdo;
		}
		
		/**
		 * 解析某市场区域坐标  
		 * @param marketCoordsXMLList
		 * @return 
		 * 
		 */		
		private function parseMarketCoords(marketCoordsXMLList:XMLList):HashVector{
			var hv:HashVector = new HashVector();
			for(var i:int = 0;i<marketCoordsXMLList.length();i++){
				var marketCoordsDO:MarketCoordsDO = new MarketCoordsDO();
				var marketCoordsXML:XML = marketCoordsXMLList[i];
				var  mcsaHv:HashVector = getXMLAttributes(marketCoordsXML);
				marketCoordsDO.name = String(mcsaHv.findByName(ATT_NAME));
				marketCoordsDO.value = String(mcsaHv.findByName(ATT_VALUE));
				marketCoordsDO.text = String(mcsaHv.findByName(ATT_TEXT));
				marketCoordsDO.x = Number(mcsaHv.findByName(ATT_X));
				marketCoordsDO.y = Number(mcsaHv.findByName(ATT_Y));
				marketCoordsDO.z = Number(mcsaHv.findByName(ATT_Z));
				marketCoordsDO.s = Number(mcsaHv.findByName(ATT_S));
				var marketCoordXMLList:XMLList = marketCoordsXML.elements(TAG_MARKET_COORD);
				var mcdoHv:HashVector = parseMarketCoord(marketCoordXMLList);
				marketCoordsDO.marketCoordDOHV = mcdoHv;
				trace("marketCoordsDO.name",marketCoordsDO.name);
				hv.put(marketCoordsDO.name,marketCoordsDO);
			}
			return hv;
		}
		
		/**
		 * 解析市场坐标 
		 * @param marketCoordXMLList
		 * @return 
		 * 
		 */		
		private function parseMarketCoord(marketCoordXMLList:XMLList):HashVector{
			var hv:HashVector = new HashVector();
			for(var i:int = 0;i<marketCoordXMLList.length();i++){
				var marketCoordDO:MarketCoordDO = new MarketCoordDO();
				var marketCoordXML:XML = marketCoordXMLList[i];
				var  mcaHv:HashVector = getXMLAttributes(marketCoordXML);
				marketCoordDO.name = String(mcaHv.findByName(ATT_NAME));
				marketCoordDO.value = String(mcaHv.findByName(ATT_VALUE));
				marketCoordDO.text = String(mcaHv.findByName(ATT_TEXT));
				marketCoordDO.x = Number(mcaHv.findByName(ATT_X));
				marketCoordDO.y = Number(mcaHv.findByName(ATT_Y));
				marketCoordDO.z = Number(mcaHv.findByName(ATT_Z));
				marketCoordDO.s = Number(mcaHv.findByName(ATT_S));
				trace("marketCoordDO.name",marketCoordDO.name);
				hv.put(marketCoordDO.name,marketCoordDO);
			}
			return hv;
		}
		
		/**
		 * 解析时间线列表
		 * @param timeLinesXMLList
		 * @return 
		 * 
		 */		
		private function parseTimeLinesXML(timeLinesXMLList:XMLList):HashVector{
			var timeLinesDOHv:HashVector = new HashVector();
			for(var i:int = 0;i<timeLinesXMLList.length();i++){
				//时间线属性
				var timeLineDO:TimeLineDO = new TimeLineDO();
				var timeLineXML:XML = timeLinesXMLList[i];
				var timeLineAttributeHv:HashVector = getXMLAttributes(timeLineXML);
				timeLineDO.name = timeLineAttributeHv.findByName(ATT_NAME) as String;
				timeLineDO.text = timeLineAttributeHv.findByName(ATT_TEXT) as String;
				
				//解析业务列表
				var bizsXMLList:XMLList = timeLineXML.elements(TAG_BIZ);
				timeLineDO.bizDOHv = this.parseBizsXML(bizsXMLList);
				timeLinesDOHv.put(String(i),timeLineDO);
			}
			return timeLinesDOHv;
		}
		
		/**
		 * 解析业务列表
		 * @param bizsXMLList
		 * @return 
		 * 
		 */		
		private function parseBizsXML(bizsXMLList:XMLList):HashVector{
			var bizDOHv:HashVector = new HashVector();
			for(var i:int = 0;i<bizsXMLList.length();i++){
				var bizXML:XML = bizsXMLList[i];
				var bizDO:BizDO = new BizDO();
				
				//解析  biz 的  var 变量
				var varsXMLList:XMLList = bizXML.elements(TAG_VARS);
				bizDO.varDOHv = this.parseVarsXML(varsXMLList);
				
				var bizAtr:HashVector = getXMLAttributes(bizXML);
				bizDO.type = bizAtr.findByName("type") as String;
				
				//解析 data 数据
				var dataXMLList:XMLList = bizXML.elements(TAG_DATA);
				var dataDO:DataDO = this.parseDataXML(dataXMLList);
				bizDO.dataDO = dataDO;
				
				
				//解析声音
				var soundsXMLList:XMLList = bizXML.elements(TAG_SOUNDS);
				bizDO.soundsHv = this.parseSoundsXML(soundsXMLList);
				
				//解析输出文字
				var textOutsXMLList:XMLList = bizXML.elements(TAG_TEXTOUTS);
				bizDO.textOutsHv = this.parseTextOutsXML(textOutsXMLList);
				
				//解析媒体文件，图片、flash
				var mediasXMLList:XMLList = bizXML.elements(TAG_MEDIAS);
				bizDO.mediasHv = this.parseMediasXML(mediasXMLList);
				bizDOHv.put(String(i),bizDO);
			}
			return bizDOHv;
		}
		
		/**
		 * 解析声音列表
		 * @param soundsXMLList
		 * @return 
		 * 
		 */		
		private function parseSoundsXML(soundsXMLList:XMLList):HashVector{
			var ssv:HashVector = new HashVector();
			for(var i:int = 0;i<soundsXMLList.length();i++){
				var soundsXML:XML = soundsXMLList[i];
				var soundXMLList:XMLList = soundsXML.elements(TAG_SOUND);
				var soundsDO:SoundsDO = new SoundsDO();
				var soundv:Vector.<SoundDO> = new Vector.<SoundDO>();
				for(var j:int = 0;j<soundXMLList.length();j++){
					var soundXML:XML = soundXMLList[i];
					var soundDO:SoundDO = new SoundDO();
					var soundAttributeHv:HashVector = this.getXMLAttributes(soundXML);
					soundDO.name = soundAttributeHv.findByName(ATT_NAME)as String;
					soundDO.text = soundAttributeHv.findByName(ATT_TEXT)as String;
					soundDO.timeLength = int(soundAttributeHv.findByName(ATT_TIMELENGTH)as String);
					soundDO.timeOffset = int(soundAttributeHv.findByName(ATT_TIMEOFFSET)as String);
					soundDO.timeout = int(soundAttributeHv.findByName(ATT_TIMEOUT)as String);
					soundDO.url = soundAttributeHv.findByName(ATT_URL)as String;
					soundv.push(soundDO);
				}
				soundsDO.soundDOHv = soundv;
				ssv.put(String(i),soundsDO);
			}
			return ssv;
		}
		
		/**
		 * 解析输出文字列表
		 * @param textOutsXMLList
		 * @return 
		 * 
		 */		
		private function parseTextOutsXML(textOutsXMLList:XMLList):HashVector{
			trace("parseTextOutsXML");
			var ssv:HashVector = new HashVector();
			for(var i:int = 0;i<textOutsXMLList.length();i++){
				var textOutsXML:XML = textOutsXMLList[i];
				var textOutXMLList:XMLList = textOutsXML.elements(TAG_TEXTOUT);
				var textOutsDO:TextOutsDO = new TextOutsDO();
				var textOutv:Vector.<TextOutDO> = new Vector.<TextOutDO>();
				for(var j:int = 0;j<textOutXMLList.length();j++){
					var textOutXML:XML = textOutXMLList[j];
					var textOutDO:TextOutDO = new TextOutDO();
					trace(textOutXML);
					var textOutAttributeHv:HashVector = this.getXMLAttributes(textOutXML);
					textOutDO.name = textOutAttributeHv.findByName(ATT_NAME)as String;
					textOutDO.text = textOutAttributeHv.findByName(ATT_TEXT)as String;
					textOutDO.timeLength = int(textOutAttributeHv.findByName(ATT_TIMELENGTH)as String);
					textOutDO.timeOffset = int(textOutAttributeHv.findByName(ATT_TIMEOFFSET)as String);
					textOutDO.timeout = int(textOutAttributeHv.findByName(ATT_TIMEOUT)as String);
					var x:int = int(textOutAttributeHv.findByName(ATT_X)as String);
					var y:int = int(textOutAttributeHv.findByName(ATT_Y)as String);
					textOutDO.place = new Point(x,y);
					textOutDO.style = textOutAttributeHv.findByName(ATT_STYLE)as String;
					textOutv.push(textOutDO);
				}
				textOutsDO.textOutDOHv = textOutv;
				ssv.put(String(i),textOutsDO);
			}
			return ssv;
		}
		
		/**
		 * 
		 * @param textOutsXMLList
		 * @return 
		 * 
		 */		
		private function parseMediasXML(mediasXMLList:XMLList):HashVector{
			trace("parseMediasXML");
			var msv:HashVector = new HashVector();
			for(var i:int = 0;i<mediasXMLList.length();i++){
				var mediasXML:XML = mediasXMLList[i];
				var mediaXMLList:XMLList = mediasXML.elements(TAG_MEDIA);
				var mediasDO:MediasDO = new MediasDO();
				var mediav:Vector.<MediaDO> = new Vector.<MediaDO>();
				for(var j:int = 0;j<mediaXMLList.length();j++){
					var mediaXML:XML = mediaXMLList[j];
					var mediaDO:MediaDO = new MediaDO();
					trace(mediaXML);
					var mediaAttributeHv:HashVector = this.getXMLAttributes(mediaXML);
					mediaDO.name = mediaAttributeHv.findByName(ATT_NAME)as String;
					mediaDO.text = mediaAttributeHv.findByName(ATT_TEXT)as String;
					mediaDO.timeLength = int(mediaAttributeHv.findByName(ATT_TIMELENGTH)as String);
					mediaDO.timeOffset = int(mediaAttributeHv.findByName(ATT_TIMEOFFSET)as String);
					mediaDO.timeout = int(mediaAttributeHv.findByName(ATT_TIMEOUT)as String);
					var x:int = int(mediaAttributeHv.findByName(ATT_X)as String);
					var y:int = int(mediaAttributeHv.findByName(ATT_Y)as String);
					mediaDO.place = new Point(x,y);
					mediaDO.url = mediaAttributeHv.findByName(ATT_URL)as String
					mediav.push(mediaDO);
				}
				mediasDO.mediaDOHv = mediav;
				msv.put(String(i),mediasDO);
			}
			return msv;
		}
		
		/**
		 * 解析业务主数据
		 * @param datasXMLList
		 * @return 
		 * 
		 */		
		private function parseDataXML(datasXMLList:XMLList):DataDO{
			trace("parseDataXML");
			var dataDO:DataDO = new DataDO();
			for(var i:int = 0;i<datasXMLList.length();i++){
				var dataXML:XML = datasXMLList[i];
				var dataXMLList:XMLList;
				var listsXMLList:XMLList;
				var disXMLList:XMLList = dataXML.elements(TAG_DISTRIBUTE);
				if(disXMLList != null && disXMLList.length() > 0){
					dataXMLList = disXMLList;
					dataDO.type = TAG_DISTRIBUTE;
				}
				
				var chrXMLList:XMLList = dataXML.elements(TAG_CHART);
				if(chrXMLList != null && chrXMLList.length() > 0){
					dataXMLList = chrXMLList;
					dataDO.type = TAG_CHART;
				}
				if(dataXMLList != null && dataXMLList.length() > 0){
					listsXMLList = dataXMLList.elements(TAG_LIST);
					dataDO.data = this.parseListsXML(listsXMLList);
				}
				
				var xGraduationTextList:XMLList;
				var xgrXMLList:XMLList = dataXML.elements(X_GRADUATION_TEXT);
				if(xgrXMLList != null && xgrXMLList.length() > 0){
					xGraduationTextList = xgrXMLList;
				}
				if(xGraduationTextList != null && xGraduationTextList.length() > 0){
					var xGraduationXMLList:XMLList = xGraduationTextList.elements(TAG_LIST);
					dataDO.xGraduationText = this.parseListsXML(xGraduationXMLList);
				}
				
				var broadcastList:XMLList;
				var brXMLList:XMLList = dataXML.elements(TAG_BROADCAST);
				if(brXMLList != null && brXMLList.length() > 0){
					broadcastList = brXMLList;
				}
				if(broadcastList != null && broadcastList.length() > 0){
					var broadcastXMLList:XMLList = broadcastList.elements(TAG_LIST);
					dataDO.broadcast = this.parseListsXML(broadcastXMLList);
				}
			}
			return dataDO;
		}
		
		/**
		 * 解析业务主数据列表
		 * @param listsXMLList
		 * @return 
		 * 
		 */		
		private function parseListsXML(listsXMLList:XMLList):Vector.<ListDO>{
			trace("parseListsXML");
			var lv:Vector.<ListDO> = new Vector.<ListDO>();
			for(var i:int = 0;i<listsXMLList.length();i++){
				var listXML:XML = listsXMLList[i];
				var listAttrHv:HashVector = this.getXMLAttributes(listXML);
				var listDO:ListDO = new ListDO();
				listDO.name = listAttrHv.findByName(ATT_NAME) as String;
				listDO.text = listAttrHv.findByName(ATT_TEXT) as String;
				listDO.style = listAttrHv.findByName(ATT_STYLE) as String;
				trace(listDO.name);
				var tpv:Vector.<TextPointDO> = new Vector.<TextPointDO>();
				var textPointsXMLList:XMLList = listXML.elements(TAG_TEXTPOINT);
				for(var j:int = 0;j<textPointsXMLList.length();j++){
					var textPointXML:XML = textPointsXMLList[j];
					var textPointDO:TextPointDO = new TextPointDO();
					var texPointHv:HashVector = this.getXMLAttributes(textPointXML);
					textPointDO.name = texPointHv.findByName(ATT_NAME) as String;
					textPointDO.text = texPointHv.findByName(ATT_TEXT) as String;
					textPointDO.value = texPointHv.findByName(ATT_VALUE) as String;
					trace("textPointDO:",textPointDO.name,textPointDO.text,textPointDO.value);
					tpv.push(textPointDO);
				}
				listDO.listHv = tpv;
				lv.push(listDO);
			}
			return lv;
		}
		
		/**
		 * 解析变量列表 TAG_VAR 
		 * @param varsXML
		 * @return 
		 * 
		 */		
		private function parseVarsXML(varsXMLList:XMLList):HashVector{
			var v:HashVector = new HashVector();
			for(var i:int = 0;i<varsXMLList.length();i++){
				var varsXML:XML = varsXMLList[i];
				var varList:XMLList = varsXML.elements(TAG_VAR);
				for(var j:int = 0;j<varList.length();j++){
					var varXML:XML = varList[j];
					var vdo:VarDO = new VarDO();
					var vdoName:String = String(varXML.attribute(VarDO.NAME));
					var varAttributeHv:HashVector = getXMLAttributes(varXML);
					for(var k:int = 0;k < varAttributeHv.length;k++){
						var name:String = varAttributeHv.findNameByIndex(i);
						var value:String = varAttributeHv.findByIndex(i) as String;
						vdo.setAttribute(name,value);
					}
					v.put(vdoName,vdo);
				}
			}
			trace(v.length);
			return v;
		}
		
		/**
		 * 解析XML结点属性列表
		 * @param xml
		 * @return 
		 * 
		 */		
		private function getXMLAttributes(xml:XML):HashVector{
			var hv:HashVector = new HashVector();
			var attributeXMLList:XMLList = xml.attributes();
			for(var i:int = 0;i < attributeXMLList.length();i++){
				var varAttributeXML:XML = attributeXMLList[i];
				var name:String = varAttributeXML.name();
				var value:String = varAttributeXML.toString();
				trace(name,value,isTextInvalid(name));
				if(isTextInvalid(name)){
					hv.put(name,value);
				}
			}
			return hv;
		}
		
		/**
		 * 检测标签文本是否为有效文本
		 * @param value
		 * 
		 */		
		private function isTextInvalid(...value):Boolean{
			var values:Array = value;
			if(values == null && values.length == 0){
				return false;
			}
			for(var i:int = 0;i<values.length;i++){
				var vl:String = values[i];	
				if(vl == null || vl == "NaN" || StringUtilities.trim(vl).length == 0){
					return false;
				}
			}
			return true;
		}
	}
}