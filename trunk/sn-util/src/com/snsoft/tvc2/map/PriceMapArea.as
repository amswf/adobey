package com.snsoft.tvc2.map{
	import com.snsoft.map.WorkSpaceDO;
	import com.snsoft.mapview.util.MapViewXMLLoader;
	import com.snsoft.tvc2.Business;
	import com.snsoft.tvc2.dataObject.DataDO;
	import com.snsoft.tvc2.dataObject.ListDO;
	import com.snsoft.tvc2.dataObject.MarketCoordDO;
	import com.snsoft.tvc2.dataObject.MarketCoordsDO;
	import com.snsoft.tvc2.dataObject.MarketMainDO;
	import com.snsoft.tvc2.dataObject.TextPointDO;
	import com.snsoft.tvc2.media.Mp3Player;
	import com.snsoft.util.text.EffectText;
	import com.snsoft.util.text.TextStyles;
	import com.snsoft.tvc2.util.StringUtil;
	import com.snsoft.util.ColorTransformUtil;
	import com.snsoft.util.HashVector;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	[Style(name="cutline_default_skin", type="Class")]
	
	[Style(name="myTextFormat", type="Class")]
	
	public class PriceMapArea extends Business{
		
		//背影地图
		private var mapView:MapView;
		
		//主数据对象
		private var dataDO:DataDO;
		
		//主数据对象数据列表
		private var listDOV:Vector.<ListDO>;
		
		//主数据对象数据列表
		private var listCount:int = 0;
		
		//上一个切换标题
		private var forwardText:TextField;
		
		//下一个切换标题
		private var currentText:TextField;
		
		//切换标题添加计时器
		private var switchAddTimer:Timer;
		
		//切换标题移除计时器
		private var switchRemoveTimer:Timer;
		
		//切换标题计时器延时时长
		private var switchTimerDelay:int = 20;
		
		//切换标题计数次数
		private var switchTimerRepeatCount:int = 10;
		
		//切换标题移动距离
		private var switchMoveLenth:Number = 100;
		
		//声音播放完成
		private var soundsCmp:Boolean = false;
		
		//地图块播放完成
		private var areasCmp:Boolean = false;
		
		//语音当前播放下标
		private var bizSoundIndex:int = 0;
		
		//地图名称
		private var mapName:String;
		
		//市场信息组
		private var marketCoordsDO:MarketCoordsDO;
		
		//市场信息主对象
		private var marketMainDO:MarketMainDO;
		
		public function PriceMapArea(dataDO:DataDO ,mapName:String ,marketMainDO:MarketMainDO,mapView:MapView,delayTime:Number = 0,timeLength:Number = 0,timeOut:Number = 0){
			super();
			this.dataDO = dataDO;
			this.mapView = mapView;
			this.delayTime = delayTime;
			this.timeLength = timeLength;
			this.timeOut = timeOut;
			this.mapName = mapName;
			this.marketMainDO = marketMainDO;
		}
		
		public static const CUTLINE_DEFAULT_SKIN:String = "cutline_default_skin";
		
		public static const TEXT_FORMAT:String = "myTextFormat";
		
		/**
		 * 
		 */		
		private static var defaultStyles:Object = {
			cutline_default_skin:"Cutline_default_skin",
			myTextFormat:new TextFormat("宋体",18,0x000000)
		};
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public static function getStyleDefinition():Object { 
			return UIComponent.mergeStyles(UIComponent.getStyleDefinition(), defaultStyles);
		}
		
		/**
		 * 
		 * 
		 */				
		override protected function configUI():void{			
			this.invalidate(InvalidationType.ALL,true);
			this.invalidate(InvalidationType.SIZE,true);
			this.width = 400;
			this.height = 300;
			super.configUI();	
		}
		
		override protected function draw():void {
		}
		
		override protected function initPlay():void {
			this.addChild(mapView);
		}
		
		/**
		 * 
		 * 
		 */		
		override protected function play():void {
			var marketCoordsDOHV:HashVector = marketMainDO.marketCoordsDOHV;
			this.marketCoordsDO = marketCoordsDOHV.findByName(this.mapName) as MarketCoordsDO;
			this.listDOV = dataDO.data;
			this.listCount = 0;
			var cutLine:Sprite = new Sprite();
			var rect:Rectangle = mapView.getRect(this);
			cutLine.x = rect.x + rect.width;
			cutLine.y = rect.y + rect.height;
			this.addChild(cutLine);
			
			
			
			for(var i:int = 0;i< listDOV.length;i++){
				var color:uint = getColor(i);
				
				var listDO:ListDO = listDOV[i];
				
				var cutLineMC:MovieClip = getDisplayObjectInstance(getStyleValue(CUTLINE_DEFAULT_SKIN)) as MovieClip;
				cutLineMC.y = - cutLineMC.height - cutLine.height;
				ColorTransformUtil.setColor(cutLineMC,color);
				cutLine.addChild(cutLineMC);
				var name:String = listDO.name;
				var tfd:TextField = EffectText.creatTextByStyleName(name,TextStyles.STYLE_CUTLINE_TEXT,color);
				tfd.x = cutLineMC.x + cutLineMC.width ;
				tfd.y = cutLineMC.y - tfd.height / 2;
				cutLine.addChild(tfd);
			}
			
			playBizSound(dataDO.bizSoundList,1,handlerBeforePlayArea);
		} 
		
		private function handlerBeforePlayArea(e:Event):void{
			soundsCmp = true;
			areasCmp = true;
			playAreaView();
		}
		
		private function handlerSwitchAdd(e:Event):void{
			var palpha:Number = 1 / switchTimerRepeatCount;
			var px:Number = switchMoveLenth / switchTimerRepeatCount;
			if(currentText != null){
				currentText.alpha += palpha;
				currentText.x -= px;
			} 
		}
		
		private function handlerSwitchRemove(e:Event):void{
			var palpha:Number = 1 / switchTimerRepeatCount;
			var px:Number = switchMoveLenth / switchTimerRepeatCount;
			if(forwardText != null){
				forwardText.alpha -= palpha;
				forwardText.x -= px;
			} 
		}
		
		private function handlerSwitchRemoveCmp(e:Event):void{
			forwardText.removeEventListener(TimerEvent.TIMER,handlerSwitchAdd);
			forwardText.removeEventListener(TimerEvent.TIMER,handlerSwitchRemove);
			forwardText.removeEventListener(TimerEvent.TIMER_COMPLETE,handlerSwitchRemoveCmp);
			this.removeChild(forwardText);
		}
		
		/**
		 * 播放地图块 
		 * 
		 */		
		private function playAreaView():void{
			var sign:Boolean = false;
			if(soundsCmp && areasCmp){
				soundsCmp = false;
				areasCmp = false;
				
				if(listDOV != null && listCount >= 0 && listCount < listDOV.length){
					var index:int = listCount;
					var color:uint = getColor(index);
					
					var listDO:ListDO = listDOV[index];
					
					var rect:Rectangle = mapView.getRect(this);
					
					var lname:String = listDO.name;
					currentText = EffectText.creatTextByStyleName(lname,TextStyles.STYLE_LIST_TYPE_TEXT,color);
					currentText.x = rect.width / 2 + switchMoveLenth;
					this.addChild(currentText);
					
					switchAddTimer = new Timer(switchTimerDelay,switchTimerRepeatCount);
					switchAddTimer.addEventListener(TimerEvent.TIMER,handlerSwitchAdd);
					switchAddTimer.start();
					
					var tpdoHv:Vector.<TextPointDO> = listDO.listHv;
					
					setAreaColor(index,1);
					
					playBizSound(dataDO.bizSoundList,1,handlerPlayAreaCmp);
					
					var timer:Timer = new Timer(2000,1);
					timer.addEventListener(TimerEvent.TIMER_COMPLETE,handlerTimer);
					timer.start();
					sign = true;
				}
				else {
					this.isPlayCmp = true;
					dispatchEventState();
				}
			}
			
			
		}
		
		private function handlerPlayAreaCmp(e:Event):void{
			soundsCmp = true;
			playAreaView();
		}
		
		/**
		 * 播放音频 
		 * @param bizSoundV
		 * @param length
		 * @param fun
		 * 
		 */		
		private function playBizSound(bizSoundV:Vector.<Vector.<Sound>>,length:int,fun:Function):void{
			var cbs:Vector.<Sound> = new Vector.<Sound>();
			var startIndex:int = bizSoundIndex;
			for(var i:int = startIndex;i< startIndex + length;i++){
				if(i >= 0 && i < bizSoundV.length){
					var cBizSoundList:Vector.<Sound> = bizSoundV[i];
					for(var j:int;j<cBizSoundList.length;j++){
						cbs.push(cBizSoundList[j]);
					}
					bizSoundIndex ++;
				}
			}
			var mp:Mp3Player = new Mp3Player(cbs);
			mp.addEventListener(Event.COMPLETE,fun);
			this.addChild(mp);
		}
		
		/**
		 * 设置地图块颜色 
		 * @param index
		 * @param alpha
		 * 
		 */		
		private function setAreaColor(index:int,alpha:Number):void{
			var listDO:ListDO = listDOV[index];
			var tpdoHv:Vector.<TextPointDO> = listDO.listHv;
			var color:uint = getColor(index);
			
			for(var i:int =0;i<tpdoHv.length;i++){
				var tpdo:TextPointDO = tpdoHv[i];
				if(tpdo != null){
					var text:String = tpdo.text;
					if(StringUtil.isEffective(text)){
						mapView.setMapAreaColor(text,color,alpha);
					}
					
					//如果从市场描述表中读取    北京   则用下面代码
					//<marketCoord name="m01" value="" text="北京" x="365" y="158" z="" s="1" />
//					var name:String = tpdo.name;
//					if(StringUtil.isEffective(name)){
//						mapView.setMapAreaColor(name,color,alpha);
//						var marketCoordDO:MarketCoordDO = marketCoordsDO.getRealCoordMarketCoordDO(name);
//						if(marketCoordDO != null){
//							var areaName:String = marketCoordDO.text;
//							mapView.setMapAreaColor(areaName,color,alpha);
//						}
//					}
				}
			}
		}
		
		private function handlerTimer(e:Event):void{
			var timer:Timer = new Timer(200,7);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER,handlerListSmallTimer);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,handlerListSmallTimerCMP);
		}
		
		private function handlerListSmallTimer(e:Event):void{
			var timer:Timer = e.currentTarget as Timer;
			var state:int = timer.currentCount % 2;
			if(state == 0){
				setAreaColor(listCount,0);
			}
			else{
				setAreaColor(listCount,1);
			}
		}
		
		private function handlerListSmallTimerCMP(e:Event):void{
			var timer:Timer = new Timer(2000,1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,handlerListBigEndTimerCMP);
			timer.start();
		}
		
		private function handlerListBigEndTimerCMP(e:Event):void{
			forwardText = currentText;
			if(forwardText != null){
				switchRemoveTimer = new Timer(switchTimerDelay,switchTimerRepeatCount);
				switchRemoveTimer.addEventListener(TimerEvent.TIMER,handlerSwitchRemove);
				switchRemoveTimer.addEventListener(TimerEvent.TIMER_COMPLETE,handlerSwitchRemoveCmp);
				switchRemoveTimer.start();
			}
			
			listCount ++;
			areasCmp = true;
			playAreaView();
		}
		
		/**
		 * 
		 * 
		 */		
		override protected function dispatchEventState():void{
			var sign:Boolean = false;
			if(this.isPlayCmp && this.isTimeLen){
				sign = true;
			}
			else if(this.isTimeOut){
				sign = true;
			}
			
			if(sign){
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		/**
		 * 样式颜色，以后需要外部配置 
		 * @param i
		 * @return 
		 * 
		 */		
		private function getColor(i:int):uint{
			var color:uint = 0x000000;
			if(i == 0){
				color = 0x000000;
			}
			else if(i == 1){
				color = 0x000099;
			}
			else if(i == 2){
				color = 0x009900; 
			}
			else if(i == 3){
				color = 0x990000; 
			}
			return color;
		}
	}
}