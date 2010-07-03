package com.snsoft.tvc2{
	import com.snsoft.font.EmbedFonts;
	import com.snsoft.font.EmbedFontsEvent;
	import com.snsoft.map.WorkSpaceDO;
	import com.snsoft.mapview.util.MapViewXMLLoader;
	import com.snsoft.tvc2.dataObject.BizDO;
	import com.snsoft.tvc2.dataObject.MainDO;
	import com.snsoft.tvc2.dataObject.MarketCoordsDO;
	import com.snsoft.tvc2.dataObject.MarketMainDO;
	import com.snsoft.tvc2.dataObject.MediaDO;
	import com.snsoft.tvc2.dataObject.MediasDO;
	import com.snsoft.tvc2.dataObject.SoundDO;
	import com.snsoft.tvc2.dataObject.SoundsDO;
	import com.snsoft.tvc2.dataObject.TimeLineDO;
	import com.snsoft.tvc2.dataObject.VarDO;
	import com.snsoft.tvc2.map.MapView;
	import com.snsoft.tvc2.media.MediaLoader;
	import com.snsoft.tvc2.media.Mp3Loader;
	import com.snsoft.tvc2.source.AreaMapLoader;
	import com.snsoft.tvc2.util.PriceUtils;
	import com.snsoft.tvc2.util.StringUtil;
	import com.snsoft.tvc2.xml.XMLParse;
	import com.snsoft.util.HashVector;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class Main extends UIComponent{
		
		private var mainXmlUrl:String;
		
		private var marketXmlUrl:String;
		
		private var mainDO:MainDO;
		
		private var marketMainDO:MarketMainDO;
		
		private var sourceCount:int = 0;
		
		private var VAR_AREA_MAP_NAME:String = "areaMapName";
		
		private var VAR_DISTRIBUTE_MAP_NAME:String = "distributeMapName";
		
		
		
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
							var timeLine:TimeLine = new TimeLine(timeLineDO,marketMainDO);
							this.addChild(timeLine);
						}
					}	
				}
			}
		}
		
		
		
		private function mainDOSourceLoad(mainDO:MainDO):void{
			if(mainDO != null){
				var timeLineDOHv:HashVector = mainDO.timeLineDOHv;
				if(timeLineDOHv != null){
					for(var i:int = 0;i < timeLineDOHv.length;i ++){
						var timeLineDO:TimeLineDO = timeLineDOHv.findByIndex(i) as TimeLineDO;
						if(timeLineDO != null){
							var bizDOHv:HashVector = timeLineDO.bizDOHv;
							if(bizDOHv != null){
								var signLoad:Boolean = false;
								for(var j:int = 0;j < bizDOHv.length;j ++){
									var bizDO:BizDO = bizDOHv.findByIndex(j) as BizDO;
									var varDOHv:HashVector = bizDO.varDOHv;
									
									if(varDOHv != null && varDOHv.length > 0){
										var areaMapNameVarDO:VarDO = varDOHv.findByName(VAR_AREA_MAP_NAME) as VarDO;
										if(areaMapNameVarDO != null){
											var areaMapName:String = areaMapNameVarDO.getAttribute(XMLParse.ATT_VALUE) as String;
											if(StringUtil.isEffective(areaMapName)){
												var aml:AreaMapLoader = new AreaMapLoader(areaMapName,bizDO);
												plusSourceCount();
												aml.load();
												signLoad = true;
												aml.addEventListener(Event.COMPLETE,handlerLoadAreaMapComplete);
												aml.addEventListener(IOErrorEvent.IO_ERROR,handlerLoadIOError);
											}
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
								}
							}
							if(!signLoad){
								play();
							}
						}
					}	
				}
			}
		}
		
		private function plusSourceCount():void{
			sourceCount ++;
			trace(sourceCount);
		}
		
		private function subSourceCount():void{
			sourceCount --;
			trace(sourceCount);
			if(sourceCount == 0){
				play();
			}
		}
		
		private function handlerLoadAreaMapComplete(e:Event):void{
			trace("handlerLoadAreaMapComplete");
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
			mediaLoader.soundDO.soundList = mediaLoader.soundList;
			subSourceCount();
		}
		
	}
}