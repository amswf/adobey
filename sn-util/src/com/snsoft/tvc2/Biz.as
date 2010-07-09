package com.snsoft.tvc2{
	import com.snsoft.tvc2.chart.UILineCharts;
	import com.snsoft.tvc2.chart.UIPillarCharts;
	import com.snsoft.tvc2.dataObject.BizDO;
	import com.snsoft.tvc2.dataObject.DataDO;
	import com.snsoft.tvc2.dataObject.MarketMainDO;
	import com.snsoft.tvc2.dataObject.MarketMap;
	import com.snsoft.tvc2.dataObject.MediasDO;
	import com.snsoft.tvc2.dataObject.SoundsDO;
	import com.snsoft.tvc2.dataObject.TextOutsDO;
	import com.snsoft.tvc2.dataObject.VarDO;
	import com.snsoft.tvc2.map.PriceDistribute;
	import com.snsoft.tvc2.map.PriceMapArea;
	import com.snsoft.tvc2.media.MediasPlayer;
	import com.snsoft.tvc2.media.Mp3sPlayer;
	import com.snsoft.tvc2.media.TextsPlayer;
	import com.snsoft.tvc2.text.EffectText;
	import com.snsoft.tvc2.text.TextStyles;
	import com.snsoft.tvc2.util.Counter;
	import com.snsoft.tvc2.util.StringUtil;
	import com.snsoft.util.HashVector;
	import com.snsoft.util.SpriteUtil;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class Biz extends UIComponent{
		
		private var bizDO:BizDO;
		
		public static const BIZ_TYPE_POLYLINES:String = "polylines";
		
		public static const BIZ_TYPE_PILLAR:String = "pillar";
		
		public static const BIZ_TYPE_DISTRIBUTE:String = "distribute";
		
		public static const BIZ_TYPE_DISTRIBUTE_AREA:String = "distributeArea";
		
		private var counter:Counter;
		
		private var marketMainDO:MarketMainDO;
		
		//是否已经播放
		protected var isPlay:Boolean;
		
		public function Biz(bizDO:BizDO,marketMainDO:MarketMainDO){
			super();
			this.bizDO = bizDO;
			this.marketMainDO = marketMainDO;
			counter = new Counter();
			isPlay = false;
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
			play();
		}
		
		private function play():void{
			if(!isPlay){
				trace("bizPlay");
				isPlay = true;
				SpriteUtil.deleteAllChild(this);
				if(bizDO != null){
					
					var mediasHv:HashVector = bizDO.mediasHv;
					if(mediasHv != null){ 
						//trace("mediasHv.length",mediasHv.length);
						counter.plus(mediasHv.length);
					}
					
					var soundsHv:HashVector = bizDO.soundsHv;
					if(soundsHv != null){ 
						//trace("soundsHv.length",soundsHv.length);
						counter.plus(soundsHv.length);
					}
					
					var textOutsHv:HashVector = bizDO.textOutsHv;
					if(textOutsHv != null){
						//trace("textOutsHv.length",textOutsHv.length);
						counter.plus(textOutsHv.length);
					}
					
					var dataDO:DataDO = bizDO.dataDO;
					var type:String = bizDO.type;
					var uilcs:Business = null;
					var delayTime:int = 2000;
					
					var soundText:String = creatSoundText(dataDO);
					
					var soundTfd:TextField = EffectText.creatTextByStyleName(soundText,TextStyles.STYLE_SOUND_TEXT);
					soundTfd.x = 10;
					soundTfd.y = SystemConfig.stageSize.y + 10;
					soundTfd.wordWrap = true;
					this.addChild(soundTfd);
					soundTfd.width = SystemConfig.stageSize.x - 20;
					
					soundTfd.height = 90;
					
					if(dataDO != null){
						if(type == BIZ_TYPE_POLYLINES){
							uilcs = new UILineCharts(dataDO,delayTime,6000);
							uilcs.width = 400;
							uilcs.height = 260;
							uilcs.x = 120;
							uilcs.y = 180;
						}
						else if(type == BIZ_TYPE_PILLAR){
							uilcs = new UIPillarCharts(dataDO,delayTime,6000);
							uilcs.width = 400;
							uilcs.height = 260;
							uilcs.x = 120;
							uilcs.y = 180;
						}
						else if(type == BIZ_TYPE_DISTRIBUTE){
							var marketMap:MarketMap = new MarketMap();
							
							var marketMapXVDO:VarDO = bizDO.varDOHv.findByName("marketMapX") as VarDO;
							var marketMapX:Number = 0;
							if(marketMapXVDO != null){
								var xv:Number = Number(marketMapXVDO.getAttribute("value"));
								if(isNaN(xv)){
									marketMapX = xv;
								}
							}
							
							var marketMapYVDO:VarDO = bizDO.varDOHv.findByName("marketMapY") as VarDO;
							var marketMapY:Number = 0;
							if(marketMapYVDO != null){
								var yv:Number = Number(marketMapYVDO.getAttribute("value"));
								if(isNaN(xv)){
									marketMapY = yv;
								}
							}
							
							var marketMapSVDO:VarDO = bizDO.varDOHv.findByName("marketMapS") as VarDO;
							var marketMapS:Number = 1;
							if(marketMapSVDO != null){
								var sv:Number = Number(marketMapSVDO.getAttribute("value"));
								if(isNaN(xv)){
									marketMapS = sv;
								}
							}
							
							marketMap.x = marketMapX;
							marketMap.y = marketMapY;
							marketMap.s = marketMapS;
							
							uilcs = new PriceDistribute(dataDO,bizDO.mapName,marketMainDO,marketMap,bizDO.mapView,delayTime);
							uilcs.width = 400;
							uilcs.height = 260;
							uilcs.x = 60;
							uilcs.y = 130;
							
						}
						else if(type == BIZ_TYPE_DISTRIBUTE_AREA){
							uilcs = new PriceMapArea(dataDO, bizDO.mapView,delayTime);
							uilcs.width = 400;
							uilcs.height = 260;
							uilcs.x = 60;
							uilcs.y = 130;
						}
						
						if(uilcs != null){
							counter.plus();
							uilcs.addEventListener(Event.COMPLETE,handlerCmp);
						}
					}
					
					if(mediasHv != null){
						for(var i:int = 0;i < mediasHv.length;i ++){
							var mediasDO:MediasDO = mediasHv.findByIndex(i) as MediasDO;
							var mediasPlayer:MediasPlayer = new MediasPlayer(mediasDO);
							mediasPlayer.addEventListener(Event.COMPLETE,handlerCmp);
							this.addChild(mediasPlayer);
							
						}
					}
					
					if(soundsHv != null){
						for(var ii:int = 0;ii < soundsHv.length;ii ++){
							var soundsDO:SoundsDO = soundsHv.findByIndex(ii) as SoundsDO;
							var mp3sPlayer:Mp3sPlayer = new Mp3sPlayer(soundsDO);
							mp3sPlayer.addEventListener(Event.COMPLETE,handlerCmp);
							this.addChild(mp3sPlayer); 
						}
					}
					
					if(textOutsHv != null){
						for(var i3:int = 0;i3 < textOutsHv.length;i3 ++){
							var textOutsDO:TextOutsDO = textOutsHv.findByIndex(i3) as TextOutsDO;
							var textsPlayer:TextsPlayer = new TextsPlayer(textOutsDO);
							textsPlayer.addEventListener(Event.COMPLETE,handlerCmp);
							this.addChild(textsPlayer);
						}
					}
					
					if(uilcs != null){
						this.addChild(uilcs);
					}
					
					var titleVDO:VarDO = bizDO.varDOHv.findByName("title") as VarDO;
					var baseY:Number = 35;
					if(titleVDO != null){
						var titleVar:String = String(titleVDO.getAttribute("text"));
						if(StringUtil.isEffective(titleVar)){
							var titleTfd:TextField = EffectText.creatTextByStyleName(titleVar,TextStyles.STYLE_TITLE);
							titleTfd.x = ( SystemConfig.stageSize.x - titleTfd.width ) / 2;
							titleTfd.y = baseY;
							this.addChild(titleTfd);
							
							baseY = titleTfd.getRect(this).bottom;
						}
					}
					
					
					var dateTextVDO:VarDO = bizDO.varDOHv.findByName("dateText") as VarDO;
					if(dateTextVDO != null){
						var dateTextVar:String = String(dateTextVDO.getAttribute("text"));
						if(StringUtil.isEffective(dateTextVar)){
							var dateTextTfd:TextField = EffectText.creatTextByStyleName(dateTextVar,TextStyles.STYLE_DATE_TEXT);
							dateTextTfd.x = ( SystemConfig.stageSize.x - dateTextTfd.width ) / 2;
							dateTextTfd.y = baseY;
							this.addChild(dateTextTfd);
							baseY = dateTextTfd.getRect(this).bottom;
						}
					}
					
					
					
					var marketVDO:VarDO = bizDO.varDOHv.findByName("market") as VarDO;
					if(marketVDO != null){
						var marketVar:String = String(marketVDO.getAttribute("text"));
						if(StringUtil.isEffective(marketVar)){
							var marketTfd:TextField = EffectText.creatTextByStyleName(marketVar,TextStyles.STYLE_GOODS);
							marketTfd.x = ( SystemConfig.stageSize.x - marketTfd.width ) / 2;
							marketTfd.y = baseY;
							this.addChild(marketTfd);
							
							baseY = marketTfd.getRect(this).bottom;
						}
					}
					
					var goodsVDO:VarDO = bizDO.varDOHv.findByName("goods") as VarDO;
					if(goodsVDO != null){
						var goodsVar:String = String(goodsVDO.getAttribute("text"));
						if(StringUtil.isEffective(goodsVar)){
							var goodsTfd:TextField = EffectText.creatTextByStyleName(goodsVar,TextStyles.STYLE_GOODS);
							goodsTfd.x = ( SystemConfig.stageSize.x - goodsTfd.width ) / 2;
							goodsTfd.y = baseY;
							this.addChild(goodsTfd);
							
							baseY = goodsTfd.getRect(this).bottom;
						}
					}
				}
			}
		}
		
		private function creatSoundText(dataDO:DataDO):String{
			var str:String = "";
			if(dataDO != null){
				var stvv:Vector.<Vector.<String>> = dataDO.bizSoundTextList;
				if(stvv != null){
					for(var i:int = 0;i < stvv.length;i ++){
						var stv:Vector.<String> = stvv[i];
						if(stv != null){
							for(var j:int = 0;j < stv.length;j ++){
								str += stv[j];
							}
						}
					}
				}
				
			}
			return str;
		}
		
		private function handlerCmp(e:Event):void{
			counter.sub();
			dispatchAllEvent();
		}
		
		private function dispatchAllEvent():void{
			trace("dispatchEventState:Event.COMPLETE",counter.count);
			if(counter.count == 0){
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
	}
}