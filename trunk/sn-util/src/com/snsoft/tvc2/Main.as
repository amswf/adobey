package com.snsoft.tvc2{
	import com.snsoft.font.EmbedFonts;
	import com.snsoft.font.EmbedFontsEvent;
	import com.snsoft.map.WorkSpaceDO;
	import com.snsoft.mapview.util.MapViewXMLLoader;
	import com.snsoft.tvc2.bizSounds.BizSoundDO;
	import com.snsoft.tvc2.bizSounds.ChartSoundsDO;
	import com.snsoft.tvc2.bizSounds.ChartSoundsManager;
	import com.snsoft.tvc2.bizSounds.DistributeAreaSoundsDO;
	import com.snsoft.tvc2.bizSounds.DistributeAreaSoundsManager;
	import com.snsoft.tvc2.bizSounds.DistributeSoundsDO;
	import com.snsoft.tvc2.bizSounds.DistributeSoundsManager;
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
	import com.snsoft.tvc2.dataObject.TextPointDO;
	import com.snsoft.tvc2.dataObject.TimeLineDO;
	import com.snsoft.tvc2.dataObject.VarDO;
	import com.snsoft.tvc2.map.MapView;
	import com.snsoft.tvc2.media.MediaLoader;
	import com.snsoft.tvc2.media.Mp3Loader;
	import com.snsoft.tvc2.media.Mp3Player;
	import com.snsoft.tvc2.source.AreaMapLoader;
	import com.snsoft.tvc2.util.PriceUtils;
	import com.snsoft.tvc2.util.StringUtil;
	import com.snsoft.tvc2.xml.XMLParse;
	import com.snsoft.util.HashVector;
	
	import fl.controls.Button;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.messaging.management.Attribute;
	
	
	public class Main extends UIComponent{
		
		private var mainXmlUrl:String;
		
		private var marketXmlUrl:String;
		
		private var mainDO:MainDO;
		
		private var marketMainDO:MarketMainDO;
		
		private var sourceCount:int = 0;
		
		private var VAR_MAP_File_NAME:String = "mapFileName";
		
		private var VAR_DISTRIBUTE_MAP_NAME:String = "distributeMapName";
		
		private var LIST_NAME_TYPE_HISTORY:String = "history";
		
		private var LIST_NAME_TYPE_CURRENT:String = "current";
		
		private var LIST_NAME_TYPE_FORECAST:String = "forecast";
		
		private var VAR_GOODS:String = "goods";
		
		private var VAR_MARKET:String = "market";
		
		private var VAR_DATE_TYPE:String = "dateType";
		
		private var VAR_MAP_NAME:String = "mapName";
		
		private var timeLineNum:int = 0;
		
		private var timeLinePlayCmpNum:int = 0;
		
		public function Main(mainXmlUrl:String,marketXmlUrl:String){
			super();
			
			this.mainXmlUrl = mainXmlUrl;
			this.marketXmlUrl = marketXmlUrl;
		}
		
		/**
		 * 
		 * 
		 */				
		override protected function configUI():void{			
			this.invalidate(InvalidationType.ALL,true);
			this.invalidate(InvalidationType.SIZE,true);
			super.configUI();	
		}
		
		/**
		 * 
		 * 
		 */		
		override protected function draw():void{
			//首先 loadEmbedFonts() 然后是 loadMarketXML() 和 loadMainXML();
			loadEmbedFonts();
		}
		
		private function loadMainXML():void{
			if(mainXmlUrl != null){				
				var req:URLRequest = new URLRequest(mainXmlUrl);
				var loader:URLLoader = new URLLoader();
				loader.load(req);
				loader.addEventListener(Event.COMPLETE,handlerLoaderCMP);
			}
		}
		
		private function loadMarketXML():void{
			if(marketXmlUrl != null){
				var reqm:URLRequest = new URLRequest(marketXmlUrl);
				var loaderm:URLLoader = new URLLoader();
				loaderm.load(reqm);
				loaderm.addEventListener(Event.COMPLETE,handlerLoaderMarketXmlCMP);
			}
		}
		
		private function loadEmbedFonts():void{
			var ef:EmbedFonts = new EmbedFonts("SimHei","HZGBYS","MicrosoftYaHei");
			ef.loadFontSwf();
			ef.addEventListener(Event.COMPLETE,handlerEmbedFontsCmp);
			ef.addEventListener(EmbedFontsEvent.IO_ERROR,handlerIOError);
		}
		
		
		private function handlerEmbedFontsCmp(e:Event):void{
			loadMarketXML();
		}
		
		private function handlerIOError(e:EmbedFontsEvent):void{
			trace("ioerror");
		}
		
		private function handlerLoaderCMP(e:Event):void{
			var loader:URLLoader = e.currentTarget as URLLoader;
			var xml:XML = new XML(loader.data);
			var parse:XMLParse = new XMLParse();
			mainDO = parse.parseTvcMainXML(xml);
			mainDOSourceLoad(mainDO);
		}
		
		private function handlerLoaderMarketXmlCMP(e:Event):void{
			var loader:URLLoader = e.currentTarget as URLLoader;
			var xml:XML = new XML(loader.data);
			var parse:XMLParse = new XMLParse();
			marketMainDO = parse.parseMarketCoordsMain(xml);
			ChartSoundsManager;
			loadMainXML();
		}
		
		/**
		 * 
		 * 
		 */		
		private function play():void{
			trace("main.play()");
			if(mainDO != null){
				var timeLineDOHv:HashVector = mainDO.timeLineDOHv;
				if(timeLineDOHv != null){
					for(var i:int = 0;i < timeLineDOHv.length;i ++){
						var timeLineDO:TimeLineDO = timeLineDOHv.findByIndex(i) as TimeLineDO;
						if(timeLineDO != null){
							timeLineNum ++;
							var timeLine:TimeLine = new TimeLine(timeLineDO,marketMainDO);
							timeLine.addEventListener(Event.COMPLETE,handlerTimeLinePlayCmp);
							this.addChild(timeLine);
						}
					}	
				}
			}
		}
		
		
		
		private function handlerTimeLinePlayCmp(e:Event):void{
			timeLinePlayCmpNum ++;
			if(timeLineNum == timeLinePlayCmpNum){
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function mainDOSourceLoad(mainDO:MainDO):void{
			if(mainDO != null){
				var timeLineDOHv:HashVector = mainDO.timeLineDOHv;
				var signLoad:Boolean = false;
				if(timeLineDOHv != null){
					for(var i:int = 0;i < timeLineDOHv.length;i ++){
						var timeLineDO:TimeLineDO = timeLineDOHv.findByIndex(i) as TimeLineDO;
						if(timeLineDO != null){
							var bizDOHv:HashVector = timeLineDO.bizDOHv;
							
							if(bizDOHv != null){
								for(var j:int = 0;j < bizDOHv.length;j ++){
									var bizDO:BizDO = bizDOHv.findByIndex(j) as BizDO;
									var varDOHv:HashVector = bizDO.varDOHv;
									//var dateType:String = getVarAttribute(varDOHv,VAR_DATE_TYPE,XMLParse.ATT_VALUE);
									//trace(dateType);
									if(varDOHv != null && varDOHv.length > 0){
										
										var gvalue:String = getVarAttribute(varDOHv,VAR_GOODS,XMLParse.ATT_VALUE);
										
										var mapName:String = getVarAttribute(varDOHv,VAR_MAP_NAME,XMLParse.ATT_VALUE);
										bizDO.mapName = mapName;
										
										var mapFileName:String = getVarAttribute(varDOHv,VAR_MAP_File_NAME,XMLParse.ATT_VALUE);
										trace(StringUtil.isEffective(mapFileName));
										if(StringUtil.isEffective(mapFileName)){
											var aml:AreaMapLoader = new AreaMapLoader(mapFileName,bizDO);
											plusSourceCount();
											aml.load();
											signLoad = true;
											aml.addEventListener(Event.COMPLETE,handlerLoadAreaMapComplete);
											aml.addEventListener(IOErrorEvent.IO_ERROR,handlerLoadIOError);
										}
										
										
										var distributeMapNameVarDO:VarDO = varDOHv.findByName(VAR_DISTRIBUTE_MAP_NAME) as VarDO;
										if(distributeMapNameVarDO != null){
											var distributeMapName:String = distributeMapNameVarDO.getAttribute(XMLParse.ATT_VALUE) as String;
											if(StringUtil.isEffective(distributeMapName)){
												var distributeMediaLoader:MediaLoader = new MediaLoader(bizDO);
												var distributeUrlV:Vector.<String> = new Vector.<String>();
												distributeUrlV.push(distributeMapName);
												plusSourceCount();
												signLoad = true;
												distributeMediaLoader.addEventListener(Event.COMPLETE,handlerDistributeMediaLoaderComplete);
												distributeMediaLoader.loadList(distributeUrlV);
												
											}
										}
									}
									var mediasHv:HashVector = bizDO.mediasHv;
									if(mediasHv != null){
										for(var k:int = 0;k < mediasHv.length;k ++){
											var mediasDO:MediasDO = mediasHv.findByIndex(k) as MediasDO;
											var mediaDOHv:Vector.<MediaDO> = mediasDO.mediaDOHv;
											for(var l:int = 0;l < mediaDOHv.length;l ++){
												var mediaDO:MediaDO = mediaDOHv[l];
												var mediaLoader:MediaLoader = new MediaLoader(mediaDO);
												var mediaUrlV:Vector.<String> = new Vector.<String>();
												var mediaUrl:String = mediaDO.url;
												if(StringUtil.isEffective(mediaUrl)){
													mediaUrlV.push(mediaDO.url);
												}
												if(mediaUrlV.length > 0){
													plusSourceCount();
													signLoad = true;
													mediaLoader.addEventListener(Event.COMPLETE,handlerMediaLoaderComplete);
													mediaLoader.loadList(mediaUrlV);
												}
											}
										}
									}
									
									var soundsHv:HashVector = bizDO.soundsHv;
									if(soundsHv != null){
										for(var k2:int = 0;k2 < soundsHv.length;k2 ++){
											var soundsDO:SoundsDO = soundsHv.findByIndex(k2) as SoundsDO;
											var soundDOHv:Vector.<SoundDO> = soundsDO.soundDOHv;
											for(var l2:int = 0;l2 < soundDOHv.length;l2 ++){
												var soundDO:SoundDO = soundDOHv[l2];
												var soundLoader:Mp3Loader = new Mp3Loader(soundDO);
												var soundUrl:String = soundDO.url;
												var soundText:String = soundDO.text;
												var soundUrlV:Vector.<String> = new Vector.<String>();
												if(StringUtil.isEffective(soundUrl)){
													soundUrlV.push(soundUrl);
													
												}
												else if(StringUtil.isEffective(soundText)){
													var n:Number = Number(soundText);
													if(n > 0){
														soundUrlV = PriceUtils.toCNUpper(n,2);
													}
												}
												if(soundUrlV != null && soundUrlV.length > 0){
													soundLoader.loadList(soundUrlV);
													plusSourceCount();
													signLoad = true;
													soundLoader.addEventListener(Event.COMPLETE,handlerSoundLoaderComplete);
												}
											}
										}
									}
									
									var dataDO:DataDO = bizDO.dataDO;
									if(dataDO != null){
										var type:String = dataDO.type;
										
										
										
										var bizSoundDO:BizSoundDO = null;
										if(type == XMLParse.TAG_CHART){
											bizSoundDO = bizPriceSoundLoad(bizDO);
										}
										else if(type == XMLParse.TAG_EXPONENTIAL){
											bizSoundDO = bizExponentialSoundLoad(bizDO);
										}
										else if(type == XMLParse.TAG_DISTRIBUTE){
											bizSoundDO = bizDistributeSoundLoad(bizDO);
										}
										else if(type == XMLParse.TAG_DISTRIBUTE_AREA){
											bizSoundDO = bizDistributeAreaSoundLoad(bizDO);
										}
										if(bizSoundDO != null){
											var urlvv:Vector.<Vector.<String>> = bizSoundDO.urlVV;
											var textVV:Vector.<Vector.<String>> = bizSoundDO.textVV;
											var vvs:Vector.<Vector.<Sound>> = new Vector.<Vector.<Sound>>();
											dataDO.bizSoundList = vvs;
											if(urlvv != null){
												for(var k3:int = 0;k3<urlvv.length;k3++){
													var disurlv:Vector.<String> = urlvv[k3];
													var vs:Vector.<Sound> = new Vector.<Sound>();
													vvs.push(vs);
													var mp3Loader:Mp3Loader = new Mp3Loader(vs);
													plusSourceCount();
													mp3Loader.loadList(disurlv);
													mp3Loader.addEventListener(Event.COMPLETE,handlerBizSoundCmp);
												}
											}
											if(textVV != null){
												dataDO.bizSoundTextList = textVV;
											}
										}
									}
								}
							}	
						}
					}	
				}
				if(!signLoad){
					trace("signLoad");
					play();
				}
			}
		}
		
		
		private function bizDistributeAreaSoundLoad(bizDO:BizDO):BizSoundDO{
			var dataDO:DataDO = bizDO.dataDO;
			var varDOHv:HashVector = bizDO.varDOHv;
			var type:String = dataDO.type;
			
			if(varDOHv != null){
				var gName:String = getVarAttribute(varDOHv,VAR_GOODS,XMLParse.ATT_VALUE);
				var gText:String = getVarAttribute(varDOHv,VAR_GOODS,XMLParse.ATT_TEXT);
				var dateType:String = getVarAttribute(varDOHv,VAR_DATE_TYPE,XMLParse.ATT_VALUE);
				
				var dasdo:DistributeAreaSoundsDO = new DistributeAreaSoundsDO();
				dasdo.goodsCode = gName;
				dasdo.goodsText = gText;
				dasdo.dateType = dateType;
				var dasm:DistributeAreaSoundsManager = new DistributeAreaSoundsManager();
				var urlvv:BizSoundDO = dasm.creatDistributeAreaUrlList(dasdo);
				return urlvv;
			}
			return null;
		}
		/**
		 *  
		 * @param bizDO
		 * 
		 */		
		private function bizExponentialSoundLoad(bizDO:BizDO):BizSoundDO{
			var dataDO:DataDO = bizDO.dataDO;
			var varDOHv:HashVector = bizDO.varDOHv;
			var type:String = dataDO.type;
			var xgtListDOV:Vector.<ListDO> = dataDO.xGraduationText;
			if(varDOHv != null){
				//var xgtName:String = xgtListDOV[0].name;//<list name="week" text="X 坐标刻度文字" style="">
				var listDOV:Vector.<ListDO> = dataDO.data;
				
				var currentListDO:ListDO = null;
				var forecastListDO:ListDO = null;
				for(var ci:int = 0;ci < listDOV.length;ci ++){
					var listDO:ListDO = listDOV[ci];
					var name:String = listDO.name;
					
					if(name.indexOf(LIST_NAME_TYPE_CURRENT) >=0){
						currentListDO = listDO;
					}
					else if(name.indexOf(LIST_NAME_TYPE_FORECAST) >=0){
						forecastListDO = listDO;
					}
				}
				
				if(currentListDO != null){
					var currentIndex:int = -1;
					var currentValue:Number = 0;
					var latestValue:Number = 0;
					
					var tpdoHv:Vector.<TextPointDO> = currentListDO.listHv;
					for(var i2:int = tpdoHv.length -1;i2 >= 0;i2 --){
						var tpdo:TextPointDO = tpdoHv[i2];
						var tpvalue:Number = Number(tpdo.value); 
						if(tpvalue > 0){
							currentIndex = i2;
							currentValue = tpvalue;
							break;
						}
						
					}
					
					for(var i21:int = tpdoHv.length -1;i21 >= 0;i21 --){
						var tpdo21:TextPointDO = tpdoHv[i21];
						var tpvalue21:Number = Number(tpdo21.value); 
						if(tpvalue21 > 0 && i21 < currentIndex){
							latestValue = tpvalue21;
							break;
						}
					}
					
					
					var priceExponentialTrend:int = NaN;
					priceExponentialTrend = getTrend(currentValue,latestValue);
					
					var gName:String = getVarAttribute(varDOHv,VAR_GOODS,XMLParse.ATT_VALUE);
					var gText:String = getVarAttribute(varDOHv,VAR_GOODS,XMLParse.ATT_TEXT);
					var dateType:String = getVarAttribute(varDOHv,VAR_DATE_TYPE,XMLParse.ATT_VALUE);
					
					var forecastContrastPrice:Number = 0;
					
					var forecastTrend:int = NaN;
					if(forecastListDO != null){
						var ftpdoHv:Vector.<TextPointDO> = forecastListDO.listHv;
						
						if(currentIndex + 1 < ftpdoHv.length){
							var ftpdo:TextPointDO = ftpdoHv[currentIndex + 1];
							var ftpvalue:Number = Number(ftpdo.value); 
							if(ftpvalue > 0){
								forecastTrend = getTrend(ftpvalue,currentValue);
							}
						}
					}
					
					var csdo:ChartSoundsDO = new ChartSoundsDO();
					csdo.dateType = dateType;
					csdo.goodsCode = gName;
					csdo.goodsText = gText;
					if(forecastListDO != null){
						csdo.hasForecast = true;
						csdo.priceExponentialTrend = priceExponentialTrend;
						csdo.forecastPriceExponentialTrend = forecastTrend;
					}
					
					var csm:ChartSoundsManager = new ChartSoundsManager();
					var urlvv:BizSoundDO = csm.creatExponentialSoundUrlList(csdo);
					
					return urlvv;
				}
			}
			return null;
		}
		
		private function bizDistributeSoundLoad(bizDO:BizDO):BizSoundDO{
			var dataDO:DataDO = bizDO.dataDO;
			var varDOHv:HashVector = bizDO.varDOHv;
			var type:String = dataDO.type;
			var xgtListDOV:Vector.<ListDO> = dataDO.xGraduationText;
			if(varDOHv != null){
				var listDOV:Vector.<ListDO> = dataDO.broadcast;	
				if(listDOV != null && marketMainDO != null && bizDO.mapName != null){
					setMarketsName(listDOV,marketMainDO,bizDO.mapName);
				}
				var lowListDO:ListDO = null;
				var highListDO:ListDO = null;
				
				var lowDisV:Vector.<TextPointDO> = null;
				var highDisV:Vector.<TextPointDO> = null;
				if(listDOV.length > 0){
					lowListDO = listDOV[0];
					if(lowListDO != null){
						lowDisV = lowListDO.listHv;
					}
				}
				if(listDOV.length > 0){
					highListDO = listDOV[1];
					if(highListDO != null){
						highDisV = highListDO.listHv;
					}
				}
				
				var lowDesListDO:ListDO = null;
				var highDesListDO:ListDO = null;
				
				var lowDesV:Vector.<TextPointDO> = null;
				var highDesV:Vector.<TextPointDO> = null;
				
				var deslv:Vector.<ListDO> = dataDO.des;
				if(deslv.length > 0){
					lowDesListDO = deslv[0];
					if(lowDesListDO != null){
						lowDesV = lowDesListDO.listHv;
					}
				}
				if(deslv.length > 0){
					highDesListDO = deslv[1];
					if(highDesListDO != null){
						highDesV = highDesListDO.listHv;
					}
				}
	
				var gName:String = getVarAttribute(varDOHv,VAR_GOODS,XMLParse.ATT_VALUE);
				var gText:String = getVarAttribute(varDOHv,VAR_GOODS,XMLParse.ATT_TEXT);
				var dateType:String = getVarAttribute(varDOHv,VAR_DATE_TYPE,XMLParse.ATT_VALUE);
				
				var forecastContrastPrice:Number = 0;		
				var dsdo:DistributeSoundsDO = new DistributeSoundsDO();
				dsdo.dateType = dateType;
				dsdo.goodsCode = gName;
				dsdo.goodsText = gText;
				dsdo.lowDisV = lowDisV;
				dsdo.highDisV = highDisV;
				dsdo.lowDesV = lowDesV;
				dsdo.highDesV = highDesV;
				
				var dsm:DistributeSoundsManager = new DistributeSoundsManager();
				var urlvv:BizSoundDO = dsm.creatPriceSoundUrlList(dsdo);
				return urlvv;
			}
			return null;
		}
		
		public function setMarketsName(listDOV:Vector.<ListDO>,marketMainDO:MarketMainDO,coordsName:String):void{
			for(var i:int = 0;i<listDOV.length;i++){
				var listDO:ListDO = listDOV[i];
				var tpdov:Vector.<TextPointDO> = listDO.listHv;
				for(var j:int = 0;j<tpdov.length;j++){
					var tpdo:TextPointDO = tpdov[j];
					var coordName:String = tpdo.name;
					
					var mcsdo:MarketCoordsDO = marketMainDO.findMarketCoordsDO(coordsName);
					if(mcsdo != null){
						var mcdo:MarketCoordDO = mcsdo.findMarketCoordDO(coordName);
						if(mcdo != null){
							tpdo.text = mcdo.text;
							trace(mcdo.text);
						}
					}
				}
			}
		}
		
		public function getVarAttribute(varDOHV:HashVector,varName:String,attributeName:String):String{
			var att:String = null;
			if(varDOHV != null){
				var varDO:VarDO = varDOHV.findByName(varName) as VarDO;
				if(varDO != null){
					att = varDO.getAttribute(attributeName) as String;
				}
			}
			return att;
		}
		
		/**
		 *  
		 * @param bizDO
		 * 
		 */		
		private function bizPriceSoundLoad(bizDO:BizDO):BizSoundDO {
			var dataDO:DataDO = bizDO.dataDO;
			var varDOHv:HashVector = bizDO.varDOHv;
			var type:String = dataDO.type;
			var xgtListDOV:Vector.<ListDO> = dataDO.xGraduationText;
			if(varDOHv != null){
				
				var listDOV:Vector.<ListDO> = dataDO.data;
				var historyListDO:ListDO = null;
				var currentListDO:ListDO = null;
				var forecastListDO:ListDO = null;
				for(var ci:int = 0;ci < listDOV.length;ci ++){
					var listDO:ListDO = listDOV[ci];
					var name:String = listDO.name;
					if(name.indexOf(LIST_NAME_TYPE_HISTORY) >=0){
						historyListDO = listDO;
					}
					else if(name.indexOf(LIST_NAME_TYPE_CURRENT) >=0){
						currentListDO = listDO;
					}
					else if(name.indexOf(LIST_NAME_TYPE_FORECAST) >=0){
						forecastListDO = listDO;
					}
				}
				
				if(currentListDO != null){
					var currentIndex:int = -1;
					
					var currentValue:Number = 0;
					var latestValue:Number = 0;
					
					var tpdoHv:Vector.<TextPointDO> = currentListDO.listHv;
					var highPrice:Number = 0;
					var lowPrice:Number = 10000;
					
					
					for(var i2:int = tpdoHv.length -1;i2 >= 0;i2 --){
						var tpdo:TextPointDO = tpdoHv[i2];
						var tpvalue:Number = Number(tpdo.value); 
						if(tpvalue > 0){
							currentIndex = i2;
							currentValue = tpvalue;
							break;
						}
						
					}
					
					for(var i21:int = tpdoHv.length -1;i21 >= 0;i21 --){
						var tpdo21:TextPointDO = tpdoHv[i21];
						var tpvalue21:Number = Number(tpdo21.value); 
						if(tpvalue21 > 0 && i21 < currentIndex){
							latestValue = tpvalue21;
							break;
						}
					}
					
					for(var i22:int = tpdoHv.length -1;i22 >= 0;i22 --){
						var tpdo22:TextPointDO = tpdoHv[i22];
						var tpvalue22:Number = Number(tpdo22.value); 
						
						if(tpvalue22 > highPrice){
							highPrice = tpvalue22;
						}
						
						if(tpvalue22 < lowPrice){
							lowPrice = tpvalue22;
						}
					}
					
					var priceTrend:int = 0;
					
					trace("currentValue,latestValue",currentValue,latestValue);
					priceTrend = getTrend(currentValue,latestValue);
					
					var gName:String = getVarAttribute(varDOHv,VAR_GOODS,XMLParse.ATT_VALUE);
					var gText:String = getVarAttribute(varDOHv,VAR_GOODS,XMLParse.ATT_TEXT);
					var dateType:String = getVarAttribute(varDOHv,VAR_DATE_TYPE,XMLParse.ATT_VALUE);
					var mName:String = getVarAttribute(varDOHv,VAR_MARKET,XMLParse.ATT_VALUE);
					var mText:String = getVarAttribute(varDOHv,VAR_MARKET,XMLParse.ATT_TEXT);
					
					var historyContrastPrice:Number = NaN;
					var historyPrice:Number = 0;
					if(historyListDO != null){
						var htpdoHv:Vector.<TextPointDO> = historyListDO.listHv;
						if(currentIndex < htpdoHv.length){
							var htpdo:TextPointDO = htpdoHv[currentIndex];
							var htpvalue:Number = Number(htpdo.value); 
							if(htpvalue > 0){
								historyPrice = htpvalue;
								historyContrastPrice = currentValue - htpvalue;
							}
						}
					}
					var historyNextPrice:Number = 0;
					if(historyListDO != null){
						var hntpdoHv:Vector.<TextPointDO> = historyListDO.listHv;
						if(currentIndex + 1 < hntpdoHv.length){
							var hrtpdo:TextPointDO = hntpdoHv[currentIndex + 1];
							var hrtpvalue:Number = Number(hrtpdo.value); 
							if(hrtpvalue > 0){
								historyNextPrice = hrtpvalue;
							}
						}
					}
					
					var forecastContrastPrice:Number = NaN;
					
					var forecastPrice:Number = NaN;
					var forecastTrend:int = NaN;
					
					if(forecastListDO != null){
						var ftpdoHv:Vector.<TextPointDO> = forecastListDO.listHv;
						if(currentIndex + 1 < ftpdoHv.length){
							var ftpdo:TextPointDO = ftpdoHv[currentIndex + 1];
							var ftpvalue:Number = Number(ftpdo.value); 
							if(ftpvalue > 0){
								if(historyListDO != null){
									forecastContrastPrice = ftpvalue - historyNextPrice;
								}
								forecastPrice = ftpvalue;
								forecastTrend = getTrend(ftpvalue,currentValue);
							}
						}
					}
					
					var csdo:ChartSoundsDO = new ChartSoundsDO();
					csdo.dateType = dateType;
					csdo.goodsCode = gName;
					csdo.goodsText = gText;
					csdo.areaCode = mName;
					csdo.areaText = mText;
					csdo.priceTrend = priceTrend;
					csdo.highPrice = highPrice;
					csdo.lowPrice = lowPrice;
					
					trace("forecastPrice",forecastPrice);
					trace("csdo",csdo.forecastPrice);
					if(forecastListDO != null && historyListDO == null){
						csdo.hasForecast = true;
						csdo.hasHistory = false;
						csdo.forecastTrend = forecastTrend;
						csdo.forecastPrice = forecastPrice;
					}
					
					if(historyListDO != null){
						csdo.hasHistory = true;
						csdo.historyContrastPrice = historyContrastPrice;
					}
					
					if(forecastListDO != null && historyListDO != null){
						csdo.hasForecast = true;
						csdo.hasHistory = true;
						csdo.forecastContrastPrice = forecastContrastPrice;
					}
					
					var csm:ChartSoundsManager = new ChartSoundsManager();
					var urlvv:BizSoundDO = csm.creatPriceSoundUrlList(csdo);
					
					return urlvv;
				}
			}
			return null;
		}
		
		private function handlerBizSoundCmp(e:Event):void{
			var mp3Loader:Mp3Loader = e.currentTarget as Mp3Loader;
			var vs:Vector.<Sound> = mp3Loader.dataObj as Vector.<Sound>;
			var sl:Vector.<Sound> = mp3Loader.soundList;
			if(sl != null){
				for(var i:int =0;i <sl.length;i++ ){
					vs.push(sl[i]);
				}
			}
			subSourceCount();
		}
		
		private function getTrend(value:Number,baseValue:Number):int{
			var trend:int = 0;
			if((value - baseValue) / baseValue > 0.1){
				trend = 1;
			}
			else if((value - baseValue) / baseValue < - 0.1){
				trend = -1;
			}
			else{
				trend = 0;
			}
			return trend;
		}
		
		private function plusSourceCount():void{
			sourceCount ++;
		}
		
		private function subSourceCount():void{
			sourceCount --;
			if(sourceCount == 0){
				play();
			}
		}
		
		private function handlerLoadAreaMapComplete(e:Event):void{
			subSourceCount();
		}
		
		
		private function handlerLoadIOError(e:Event):void{
			trace("地图数据地址错误");
		}
		
		private function handlerMediaLoaderComplete(e:Event):void{
			var mediaLoader:MediaLoader = e.currentTarget as MediaLoader;
			var mediaDO:MediaDO = mediaLoader.data as MediaDO;
			mediaDO.mediaList = mediaLoader.mediaList;
			subSourceCount();
		}
		
		private function handlerDistributeMediaLoaderComplete(e:Event):void{
			var mediaLoader:MediaLoader = e.currentTarget as MediaLoader;
			var bizDO:BizDO = mediaLoader.data as BizDO;
			bizDO.distributeMap = mediaLoader.mediaList[0];
			subSourceCount();
		}
		
		
		private function handlerSoundLoaderComplete(e:Event):void{
			var mediaLoader:Mp3Loader = e.currentTarget as Mp3Loader;
			var soundDO:SoundDO = mediaLoader.dataObj as SoundDO;
			soundDO.soundList = mediaLoader.soundList;
			subSourceCount();
		}
		
	}
}