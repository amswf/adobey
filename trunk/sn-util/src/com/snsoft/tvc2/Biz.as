package com.snsoft.tvc2{
	import com.snsoft.tvc2.chart.UICoorChartBase;
	import com.snsoft.tvc2.chart.UILineCharts;
	import com.snsoft.tvc2.chart.UIPillarCharts;
	import com.snsoft.tvc2.dataObject.BizDO;
	import com.snsoft.tvc2.dataObject.DataDO;
	import com.snsoft.tvc2.dataObject.MediaDO;
	import com.snsoft.tvc2.dataObject.MediasDO;
	import com.snsoft.tvc2.dataObject.SoundDO;
	import com.snsoft.tvc2.dataObject.SoundsDO;
	import com.snsoft.tvc2.dataObject.TextOutDO;
	import com.snsoft.tvc2.dataObject.TextOutsDO;
	import com.snsoft.tvc2.media.MediaPlayer;
	import com.snsoft.tvc2.media.Mp3Player;
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
		
		private var counter:Counter;
		
		public function Biz(bizDO:BizDO){
			super();
			this.bizDO = bizDO;
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
				var dataDO:DataDO = bizDO.dataDO;
				var type:String = bizDO.type;
				if(dataDO != null){
					var uilcs:UICoorChartBase;
					if(type == BIZ_TYPE_POLYLINES){
						uilcs = new UILineCharts(dataDO);
						
					}
					else if(type == BIZ_TYPE_PILLAR){
						uilcs = new UIPillarCharts(dataDO);
					}
					uilcs.addEventListener(Event.COMPLETE,handlerCmp);
					uilcs.width = 450;
					uilcs.height = 300;
					uilcs.x = 80;
					uilcs.y = 80;
					counter.plus();
					this.addChild(uilcs);
					uilcs.drawNow();
				}
				
				var mediasHv:HashVector = bizDO.mediasHv;
				if(mediasHv != null){
					for(var i:int = 0;i < mediasHv.length;i ++){
						var mediasDO:MediasDO = mediasHv.findByIndex(i) as MediasDO;
						var mediaDOHv:Vector.<MediaDO> = mediasDO.mediaDOHv;
						for(var j:int = 0;j < mediaDOHv.length;j ++){
							var mediaDO:MediaDO = mediaDOHv[j];
							var mediaList:Vector.<DisplayObject> = mediaDO.mediaList;
							if(mediaList != null && mediaList.length > 0){
								var mediaPlayer:MediaPlayer = new MediaPlayer(mediaList,mediaDO.timeOffset,mediaDO.timeLength,mediaDO.timeout);
								mediaPlayer.addEventListener(Event.COMPLETE,handlerCmp);
								counter.plus();
								this.addChild(mediaPlayer);
							}
						}
					}
				}
				
				var soundsHv:HashVector = bizDO.soundsHv;
				if(soundsHv != null){
					for(var ii:int = 0;ii < soundsHv.length;ii ++){
						var soundsDO:SoundsDO = soundsHv.findByIndex(ii) as SoundsDO;
						var soundDOHv:Vector.<SoundDO> = soundsDO.soundDOHv;
						for(var jj:int = 0;jj < soundDOHv.length;jj ++){
							var soundDO:SoundDO = soundDOHv[jj];
							var soundList:Vector.<Sound> = soundDO.soundList;
							if(soundList != null && soundList.length > 0){
								var mp3Player:Mp3Player = new Mp3Player(soundList,soundDO.timeOffset,soundDO.timeLength,soundDO.timeout);
								mp3Player.addEventListener(Event.COMPLETE,handlerCmp);
								counter.plus();
								this.addChild(mediaPlayer);
							}
						}
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