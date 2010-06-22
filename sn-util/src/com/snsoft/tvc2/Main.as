package com.snsoft.tvc2{
	import com.snsoft.tvc2.dataObject.BizDO;
	import com.snsoft.tvc2.dataObject.MainDO;
	import com.snsoft.tvc2.dataObject.MediaDO;
	import com.snsoft.tvc2.dataObject.MediasDO;
	import com.snsoft.tvc2.dataObject.SoundDO;
	import com.snsoft.tvc2.dataObject.SoundsDO;
	import com.snsoft.tvc2.dataObject.TimeLineDO;
	import com.snsoft.tvc2.media.MediaLoader;
	import com.snsoft.tvc2.media.Mp3Loader;
	import com.snsoft.tvc2.util.PriceUtils;
	import com.snsoft.tvc2.util.StringUtil;
	import com.snsoft.tvc2.xml.XMLParse;
	import com.snsoft.util.HashVector;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class Main extends UIComponent{
		
		private var mainXmlUrl:String;
		
		private var mainDO:MainDO;
		
		private var sourceCount:int = 0;
		
		public function Main(mainXmlUrl:String){
			super();
			
			this.mainXmlUrl = mainXmlUrl;
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
			if(mainXmlUrl != null){
				import com.snsoft.tvc2.xml.XMLParse;
				import flash.utils.getTimer;
				import flash.system.System;
				var url:String = mainXmlUrl;
				var req:URLRequest = new URLRequest(url);
				var n:Number = new Date().getTime();
				var loader:URLLoader = new URLLoader();
				loader.load(req);
				loader.addEventListener(Event.COMPLETE,handlerLoaderCMP);
			}
		}
		
		/**
		 * 
		 * 
		 */		
		private function play():void{
			if(mainDO != null){
				var timeLineDOHv:HashVector = mainDO.timeLineDOHv;
				if(timeLineDOHv != null){
					for(var i:int = 0;i < timeLineDOHv.length;i ++){
						var timeLineDO:TimeLineDO = timeLineDOHv.findByIndex(i) as TimeLineDO;
						if(timeLineDO != null){
							 var timeLine:TimeLine = new TimeLine(timeLineDO);
							 this.addChild(timeLine);
						}
					}	
				}
			}
		}
		
		private function handlerLoaderCMP(e:Event):void{
			var loader:URLLoader = e.currentTarget as URLLoader;
			var xml:XML = new XML(loader.data);
			var parse:XMLParse = new XMLParse();
			mainDO = parse.parseTvcMainXML(xml);
			mainDOSourceLoad(mainDO);
			
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
								for(var j:int = 0;j < bizDOHv.length;j ++){
									var bizDO:BizDO = bizDOHv.findByIndex(j) as BizDO;
									
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
													mediaLoader.loadList(mediaUrlV);
													plusSourceCount();
													mediaLoader.addEventListener(Event.COMPLETE,handlerMediaLoaderComplete);
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
													soundLoader.addEventListener(Event.COMPLETE,handlerSoundLoaderComplete);
												}
											}
										}
									}
								}
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
		
		private function handlerMediaLoaderComplete(e:Event):void{
			var mediaLoader:MediaLoader = e.currentTarget as MediaLoader;
			mediaLoader.mediaDO.mediaList = mediaLoader.mediaList;
			subSourceCount();
		}
		
		private function handlerSoundLoaderComplete(e:Event):void{
			var mediaLoader:Mp3Loader = e.currentTarget as Mp3Loader;
			mediaLoader.soundDO.soundList = mediaLoader.soundList;
			subSourceCount();
		}
	}
}