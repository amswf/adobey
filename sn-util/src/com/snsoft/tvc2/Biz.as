﻿package com.snsoft.tvc2{
	import com.snsoft.tvc2.chart.UICoorChartBase;
	import com.snsoft.tvc2.chart.UILineCharts;
	import com.snsoft.tvc2.chart.UIPillarCharts;
	import com.snsoft.tvc2.dataObject.BizDO;
	import com.snsoft.tvc2.dataObject.DataDO;
	import com.snsoft.tvc2.dataObject.MarketMainDO;
	import com.snsoft.tvc2.dataObject.MarketMap;
	import com.snsoft.tvc2.dataObject.MediaDO;
	import com.snsoft.tvc2.dataObject.MediasDO;
	import com.snsoft.tvc2.dataObject.SoundDO;
	import com.snsoft.tvc2.dataObject.SoundsDO;
	import com.snsoft.tvc2.dataObject.TextOutDO;
	import com.snsoft.tvc2.dataObject.TextOutsDO;
	import com.snsoft.tvc2.map.PriceDistribute;
	import com.snsoft.tvc2.map.PriceMapArea;
	import com.snsoft.tvc2.media.MediaPlayer;
	import com.snsoft.tvc2.media.MediasPlayer;
	import com.snsoft.tvc2.media.Mp3Player;
	import com.snsoft.tvc2.media.Mp3sPlayer;
	import com.snsoft.tvc2.media.TextPlayer;
	import com.snsoft.tvc2.util.Counter;
	import com.snsoft.tvc2.util.StringUtil;
	import com.snsoft.util.HashVector;
	import com.snsoft.util.SpriteUtil;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.text.TextFormat;
	
	public class Biz extends UIComponent{
		
		private var bizDO:BizDO;
		
		private var BIZ_TYPE_POLYLINES:String = "polylines";
		
		private var BIZ_TYPE_PILLAR:String = "pillar";
		
		private var BIZ_TYPE_DISTRIBUTE:String = "distribute";
		
		private var BIZ_TYPE_DISTRIBUTE_AREA:String = "distributeArea";
		
		private var counter:Counter;
		
		private var marketMainDO:MarketMainDO;
		
		public function Biz(bizDO:BizDO,marketMainDO:MarketMainDO){
			super();
			this.bizDO = bizDO;
			this.marketMainDO = marketMainDO;
			counter = new Counter();
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
			trace("bizPlay");
			play();
		}
		
		private function play():void{
			SpriteUtil.deleteAllChild(this);
			if(bizDO != null){
				var mediasHv:HashVector = bizDO.mediasHv;
				if(mediasHv != null){
					for(var i:int = 0;i < mediasHv.length;i ++){
						var mediasDO:MediasDO = mediasHv.findByIndex(i) as MediasDO;
						var mediasPlayer:MediasPlayer = new MediasPlayer(mediasDO);
						counter.plus();
						mediasPlayer.addEventListener(Event.COMPLETE,handlerCmp);
						this.addChild(mediasPlayer);
						
					}
				}
				
				var soundsHv:HashVector = bizDO.soundsHv;
				if(soundsHv != null){
					for(var ii:int = 0;ii < soundsHv.length;ii ++){
						
						var soundsDO:SoundsDO = soundsHv.findByIndex(ii) as SoundsDO;
						var mp3sPlayer:Mp3sPlayer = new Mp3sPlayer(soundsDO);
						counter.plus();
						mp3sPlayer.addEventListener(Event.COMPLETE,handlerCmp);
						this.addChild(mp3sPlayer); 
					}
				}
				
				var textOutsHv:HashVector = bizDO.textOutsHv;
				if(textOutsHv != null){
					for(var i3:int = 0;i3 < textOutsHv.length;i3 ++){
						var textOutsDO:TextOutsDO = textOutsHv.findByIndex(i3) as TextOutsDO;
						var textOutDOHv:Vector.<TextOutDO> = textOutsDO.textOutDOHv;
						for(var j3:int = 0;j3 < textOutDOHv.length;j3 ++){
							var textOutDO:TextOutDO = textOutDOHv[j3];
							var text:String = textOutDO.text;
							if(StringUtil.isEffective(text)){
								var tft:TextFormat = new TextFormat();//需要实现此文本格式对象
								var textPlayer:TextPlayer = new TextPlayer(text,tft,textOutDO.timeOffset,textOutDO.timeLength,textOutDO.timeout);
								textPlayer.addEventListener(Event.COMPLETE,handlerCmp);
								counter.plus();
								this.addChild(textPlayer);
							}
						}
					}
				}
				
				var dataDO:DataDO = bizDO.dataDO;
				var type:String = bizDO.type;
				if(dataDO != null){
					var uilcs:UIComponent;
					if(type == BIZ_TYPE_POLYLINES){
						uilcs = new UILineCharts(dataDO);
						
					}
					else if(type == BIZ_TYPE_PILLAR){
						uilcs = new UIPillarCharts(dataDO);
					}
					else if(type == BIZ_TYPE_DISTRIBUTE){
						var marketMap:MarketMap = new MarketMap();
						var marketMapX:Number = Number(bizDO.varDOHv.findByName("marketMapX"));
						if(isNaN(marketMapX)){
							marketMapX = 0;
						}
						var marketMapY:Number = Number(bizDO.varDOHv.findByName("marketMapY"));
						if(isNaN(marketMapY)){
							marketMapY = 0;
						}
						var marketMapS:Number = Number(bizDO.varDOHv.findByName("marketMapS"));
						if(isNaN(marketMapS) || marketMapS <= 0){
							marketMapS = 1;
						}
						marketMap.x = marketMapX;
						marketMap.y = marketMapY;
						marketMap.s = marketMapS;
						
						uilcs = new PriceDistribute(dataDO,marketMainDO,marketMap,bizDO.distributeMap);
					}
					else if(type == BIZ_TYPE_DISTRIBUTE_AREA){
						uilcs = new PriceMapArea(dataDO, bizDO.mapView);
					}
					
					if(uilcs != null){
						uilcs.addEventListener(Event.COMPLETE,handlerCmp);
						uilcs.width = 450;
						uilcs.height = 300;
						counter.plus();
						this.addChild(uilcs);
						uilcs.drawNow();
					}
				}
				
			}
		}
		
		private function handlerCmp(e:Event):void{
			counter.sub();
			dispatchAllEvent();
		}
		
		private function dispatchAllEvent():void{
			trace(counter.count);
			if(counter.count == 0){
				trace("dispatchAllEvent");
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
	}
}