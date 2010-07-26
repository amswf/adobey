package com.snsoft.tvc2.xml{
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
	import com.snsoft.tvc2.text.TextStyle;
	import com.snsoft.tvc2.text.TextStyles;
	import com.snsoft.tvc2.util.StringUtil;
	import com.snsoft.util.HashVector;
	import com.snsoft.xmldom.Node;
	import com.snsoft.xmldom.NodeList;
	import com.snsoft.xmldom.XMLDom;
	
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
		
		public static const TAG_EXPONENTIAL:String = "exponential";
		
		public static const X_GRADUATION_TEXT:String = "xGraduationText";
		
		public static const Y_GRADUATION_TEXT:String = "yGraduationText";
		
		public static const TAG_DISTRIBUTE:String = "distribute";
		
		public static const TAG_DISTRIBUTE_DES:String = "distributeDes";
		
		public static const TAG_DISTRIBUTE_AREA:String = "distributeArea";
		
		public static const TAG_BROADCAST:String = "broadcast";
		
		public static const TAG_LIST:String = "list";
		
		public static const TAG_TEXTPOINT:String = "textPoint";
		
		public static const TAG_MARKET_COORDS:String = "marketCoords";
		
		public static const TAG_MARKET_COORD:String = "marketCoord";
		
		public static const TAG_STYLES:String = "styles";
		
		public static const TAG_STYLE:String = "style";
		
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
		
		public static const ATT_PLACE_TYPE:String = "placeType";
		
		public static const ATT_SCALEX:String = "scaleX";
		
		public static const ATT_SCALEY:String = "scaleY";
		
		public static const ATT_TIMEOFFSET:String = "timeOffset";
		
		public static const ATT_TIMELENGTH:String = "timeLength";
		
		public static const ATT_TIMEOUT:String = "timeout";
		
		public static const ATT_STYLE:String = "style";
		
		public static const ATT_UNIT_X:String = "unitX";
		
		public static const ATT_UNIT_Y:String = "unitY";
		
		public static const ATT_FONT:String = "font";
		
		public static const ATT_SIZE:String = "size";
		
		public static const ATT_COLOR:String = "color";
		
		public static const ATT_INSCOLOR:String = "inSColor";
		
		public static const ATT_OUTSCOLOR:String = "outSColor";
		
		public static const ATT_ISEMBEDFONT:String = "isEmbedFont";
		
		public function XMLParse(){
			
		}
		
		/**
		 * 解析样式XML，并且初始化样式到类TextStyles的静态属性中
		 * @param xml
		 * 
		 */		
		public function parseStyles(xml:XML):void{
			var styles:Vector.<TextStyle> = new Vector.<TextStyle>();
			var xc:XMLDom = new XMLDom(xml);
			var node:Node = xc.parse();
			var nodeList:NodeList = node.getNodeList(TAG_STYLES);
			for(var i:int = 0;i<nodeList.length();i++){
				var cnode:Node = nodeList.getNode(i);
				var cnodeList:NodeList = cnode.getNodeList(TAG_STYLE);
				for(var j:int = 0;j<cnodeList.length();j++){
					var ccnode:Node = cnodeList.getNode(j);
					var name:String = ccnode.getAttributeByName(ATT_NAME);
					var font:String = ccnode.getAttributeByName(ATT_FONT);
					var color:uint = uint(ccnode.getAttributeByName(ATT_COLOR));
					var size:uint = uint(ccnode.getAttributeByName(ATT_SIZE));
					var inSColor:uint = uint(ccnode.getAttributeByName(ATT_INSCOLOR));
					var outSColor:uint = uint(ccnode.getAttributeByName(ATT_OUTSCOLOR));
					var isEmbedFont:Boolean = Boolean(ccnode.getAttributeByName(ATT_ISEMBEDFONT));
					var x:int = int(ccnode.getAttributeByName(ATT_X));
					var y:int = int(ccnode.getAttributeByName(ATT_Y));
					var textStyle:TextStyle = new TextStyle(font,size,color,inSColor,outSColor,isEmbedFont,x,y);
					TextStyles.pushTextStyle(name,textStyle);
				}
			}
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
				//trace("marketCoordsDO.name",marketCoordsDO.name);
				hv.push(marketCoordsDO,marketCoordsDO.name);
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
				//trace("marketCoordDO.name",marketCoordDO.name);
				hv.push(marketCoordDO,marketCoordDO.name);
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
				timeLinesDOHv.push(timeLineDO);
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
				var sign:Boolean = false;
				
				//解析  biz 的  var 变量
				var varsXMLList:XMLList = bizXML.elements(TAG_VARS);
				bizDO.varDOHv = this.parseVarsXML(varsXMLList);
				
				var bizAtr:HashVector = getXMLAttributes(bizXML);
				bizDO.type = bizAtr.findByName(ATT_TYPE) as String;
				
				//解析 data 数据
				var dataXMLList:XMLList = bizXML.elements(TAG_DATA);
				var dataDO:DataDO = this.parseDataXML(dataXMLList);
				bizDO.dataDO = dataDO;
				if(bizDO.dataDO != null && bizDO.dataDO.data != null && bizDO.dataDO.data.length > 0){
					sign = true;		
				}
				
				//解析声音
				var soundsXMLList:XMLList = bizXML.elements(TAG_SOUNDS);
				bizDO.soundsHv = this.parseSoundsXML(soundsXMLList);
				if(bizDO.soundsHv != null && bizDO.soundsHv.length > 0){
					sign = true;
				}
				
				//解析输出文字
				var textOutsXMLList:XMLList = bizXML.elements(TAG_TEXTOUTS);
				bizDO.textOutsHv = this.parseTextOutsXML(textOutsXMLList);
				if(bizDO.textOutsHv != null && bizDO.textOutsHv.length > 0){
					sign = true;
				}
				
				//解析媒体文件，图片、flash
				var mediasXMLList:XMLList = bizXML.elements(TAG_MEDIAS);
				bizDO.mediasHv = this.parseMediasXML(mediasXMLList);
				if(bizDO.mediasHv != null && bizDO.mediasHv.length > 0){
					sign = true;
				}
				
				if(sign){
					bizDOHv.push(bizDO);
				}
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
					var soundXML:XML = soundXMLList[j];
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
				if(soundv.length > 0){
					soundsDO.soundDOHv = soundv;
					ssv.push(soundsDO);
				}
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
			//trace("parseTextOutsXML");
			var ssv:HashVector = new HashVector();
			for(var i:int = 0;i<textOutsXMLList.length();i++){
				var textOutsXML:XML = textOutsXMLList[i];
				var textOutXMLList:XMLList = textOutsXML.elements(TAG_TEXTOUT);
				var textOutsDO:TextOutsDO = new TextOutsDO();
				var textOutv:Vector.<TextOutDO> = new Vector.<TextOutDO>();
				for(var j:int = 0;j<textOutXMLList.length();j++){
					var textOutXML:XML = textOutXMLList[j];
					var textOutDO:TextOutDO = new TextOutDO();
					var textOutAttributeHv:HashVector = this.getXMLAttributes(textOutXML);
					textOutDO.name = textOutAttributeHv.findByName(ATT_NAME)as String;
					textOutDO.text = textOutAttributeHv.findByName(ATT_TEXT)as String;
					textOutDO.timeLength = int(textOutAttributeHv.findByName(ATT_TIMELENGTH)as String);
					textOutDO.timeOffset = int(textOutAttributeHv.findByName(ATT_TIMEOFFSET)as String);
					textOutDO.timeout = int(textOutAttributeHv.findByName(ATT_TIMEOUT)as String);
					var x:int = int(textOutAttributeHv.findByName(ATT_X)as String);
					var y:int = int(textOutAttributeHv.findByName(ATT_Y)as String);
					textOutDO.place = new Point(x,y);
					textOutDO.placeType = textOutAttributeHv.findByName(ATT_PLACE_TYPE)as String;
					textOutDO.style = textOutAttributeHv.findByName(ATT_STYLE)as String;
					textOutv.push(textOutDO);
				}
				
				if(textOutv.length > 0){
					textOutsDO.textOutDOHv = textOutv;
					ssv.push(textOutsDO);
				}
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
			//trace("parseMediasXML");
			var msv:HashVector = new HashVector();
			for(var i:int = 0;i<mediasXMLList.length();i++){
				var mediasXML:XML = mediasXMLList[i];
				var mediaXMLList:XMLList = mediasXML.elements(TAG_MEDIA);
				var mediasDO:MediasDO = new MediasDO();
				var mediav:Vector.<MediaDO> = new Vector.<MediaDO>();
				for(var j:int = 0;j<mediaXMLList.length();j++){
					var mediaXML:XML = mediaXMLList[j];
					var mediaDO:MediaDO = new MediaDO();
					//trace(mediaXML);
					var mediaAttributeHv:HashVector = this.getXMLAttributes(mediaXML);
					mediaDO.name = mediaAttributeHv.findByName(ATT_NAME)as String;
					mediaDO.text = mediaAttributeHv.findByName(ATT_TEXT)as String;
					mediaDO.timeLength = int(mediaAttributeHv.findByName(ATT_TIMELENGTH)as String);
					mediaDO.timeOffset = int(mediaAttributeHv.findByName(ATT_TIMEOFFSET)as String);
					mediaDO.timeout = int(mediaAttributeHv.findByName(ATT_TIMEOUT)as String);
					var x:int = int(mediaAttributeHv.findByName(ATT_X)as String);
					var y:int = int(mediaAttributeHv.findByName(ATT_Y)as String);
					mediaDO.place = new Point(x,y);
					mediaDO.placeType = mediaAttributeHv.findByName(ATT_PLACE_TYPE)as String;
					mediaDO.url = mediaAttributeHv.findByName(ATT_URL)as String
					mediav.push(mediaDO);
				}
				
				if(mediav.length > 0){
					mediasDO.mediaDOHv = mediav;
					msv.push(mediasDO);
				}
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
			//trace("parseDataXML");
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
				
				var disarXMLList:XMLList = dataXML.elements(TAG_DISTRIBUTE_AREA);
				if(disarXMLList != null && disarXMLList.length() > 0){
					dataXMLList = disarXMLList;
					dataDO.type = TAG_DISTRIBUTE_AREA;
				}
				var chrXMLList:XMLList = dataXML.elements(TAG_CHART);
				if(chrXMLList != null && chrXMLList.length() > 0){
					var chrXML:XML = chrXMLList[0];
					var chrAttrHv:HashVector = getXMLAttributes(chrXML);
					var unitX:String = String(chrAttrHv.findByName(ATT_UNIT_X));
					var unitY:String = String(chrAttrHv.findByName(ATT_UNIT_Y));
					dataXMLList = chrXMLList;
					dataDO.type = TAG_CHART;
					dataDO.unitX = unitX;
					dataDO.unitY = unitY;
				}
				
				var expXMLList:XMLList = dataXML.elements(TAG_EXPONENTIAL);
				if(expXMLList != null && expXMLList.length() > 0){
					var expXML:XML = expXMLList[0];
					var expAttrHv:HashVector = getXMLAttributes(expXML);
					var expUnitX:String = String(expAttrHv.findByName(ATT_UNIT_X));
					var expUnitY:String = String(expAttrHv.findByName(ATT_UNIT_Y));
					dataXMLList = expXMLList;
					dataDO.type = TAG_EXPONENTIAL;
					dataDO.unitX = expUnitX;
					dataDO.unitY = expUnitY;
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
				
				var desList:XMLList;
				var desXMLList:XMLList = dataXML.elements(TAG_DISTRIBUTE_DES);
				if(desXMLList != null && desXMLList.length() > 0){
					desList = desXMLList;
				}
				if(desList != null){
					var desListXMLList:XMLList = desList.elements(TAG_LIST);
					dataDO.des = this.parseListsXML(desListXMLList);
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
			//trace("parseListsXML");
			var lv:Vector.<ListDO> = new Vector.<ListDO>();
			for(var i:int = 0;i<listsXMLList.length();i++){
				var listXML:XML = listsXMLList[i];
				var listAttrHv:HashVector = this.getXMLAttributes(listXML);
				var listDO:ListDO = new ListDO();
				listDO.name = listAttrHv.findByName(ATT_NAME) as String;
				listDO.text = listAttrHv.findByName(ATT_TEXT) as String;
				listDO.style = listAttrHv.findByName(ATT_STYLE) as String;
				//trace(listDO.name);
				var tpv:Vector.<TextPointDO> = new Vector.<TextPointDO>();
				var textPointsXMLList:XMLList = listXML.elements(TAG_TEXTPOINT);
				var sign:Boolean = false;
				for(var j:int = 0;j<textPointsXMLList.length();j++){
					var textPointXML:XML = textPointsXMLList[j];
					var textPointDO:TextPointDO = new TextPointDO();
					var texPointHv:HashVector = this.getXMLAttributes(textPointXML);
					textPointDO.name = texPointHv.findByName(ATT_NAME) as String;
					textPointDO.text = texPointHv.findByName(ATT_TEXT) as String;
					textPointDO.value = texPointHv.findByName(ATT_VALUE) as String;
					
					if(StringUtil.isEffective(textPointDO.name) 
						|| StringUtil.isEffective(textPointDO.text)
						|| StringUtil.isEffective(textPointDO.value)){
						sign = true;	
					}
					tpv.push(textPointDO);
				}
				listDO.listHv = tpv;
				if(sign){
					lv.push(listDO);
				}
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
						var name:String = varAttributeHv.findNameByIndex(k);
						var value:String = varAttributeHv.findByIndex(k) as String;
						vdo.setAttribute(name,value);
					}
					v.push(vdo,vdoName);
				}
			}
			//trace(v.length);
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
			//trace("XMLAttributes:");
			for(var i:int = 0;i < attributeXMLList.length();i++){
				var varAttributeXML:XML = attributeXMLList[i];
				var name:String = varAttributeXML.name();
				var value:String = varAttributeXML.toString();
				//trace(StringUtil.isEffective(value));
				if(StringUtil.isEffective(value)){
					//trace(name,value);
					hv.push(value,name);
				}
			}
			//trace("hv.length",hv.length);
			return hv;
		}
		
		 
	}
}