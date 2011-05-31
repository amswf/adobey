package com.snsoft.tvc2.map {
	import com.snsoft.tvc2.Business;
	import com.snsoft.tvc2.dataObject.DataDO;
	import com.snsoft.tvc2.dataObject.ListDO;
	import com.snsoft.tvc2.dataObject.MarketCoordDO;
	import com.snsoft.tvc2.dataObject.MarketCoordsDO;
	import com.snsoft.tvc2.dataObject.MarketMainDO;
	import com.snsoft.tvc2.dataObject.MarketMap;
	import com.snsoft.tvc2.dataObject.TextPointDO;
	import com.snsoft.tvc2.media.Mp3Player;
	import com.snsoft.util.ColorTransformUtil;
	import com.snsoft.util.HashVector;
	import com.snsoft.util.SpriteMove;
	import com.snsoft.util.SpriteUtil;
	import com.snsoft.util.TextFieldUtil;
	import com.snsoft.util.text.EffectText;
	import com.snsoft.util.text.TextStyles;
	import com.snsoft.util.xmldom.XMLFastConfig;

	import fl.core.InvalidationType;
	import fl.core.UIComponent;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;

	/**
	 * 价格分布业务实现
	 *
	 * 先显示市场价格分布，再对某几个特殊市场价格播报
	 *
	 * @author Administrator
	 *
	 */
	public class PriceDistribute extends Business {

		//点列表的列表
		private var _dataDO:DataDO;

		//市场信息主数据对象
		private var marketMainDO:MarketMainDO;

		//市场分布背景地图
		private var marketMap:MarketMap;

		//市场价格分布点个数
		private var listSmallCount:int = 0;

		//市场价格播报个数
		private var broadcastListCount:int = 0;

		//市场价格播报计数
		private var broadcastCount:int = 0;

		//市场价格播报列表当前播报市场下标
		private var broadcastNum:int = 0;

		//市场价格分布数据列表
		private var listDOV:Vector.<ListDO>;

		//市场价格播报数据列表
		private var broadcastListDOV:Vector.<ListDO>;

		//市场信息组对象
		private var marketCoordsDO:MarketCoordsDO;

		//市场价格分布点闪动效果计时器
		private var listSmallTimer:Timer;

		//当前市场价格分布点列表显示父MC
		private var currentListMC:Sprite;

		//当前市场价格播报列表显示父MC
		private var currentBroadcastListMC:Sprite;

		//市场价格分布背景地图
		private var mapView:MapView;

		//图例所在的MC
		private var cutLine:Sprite;

		//上一个市场价格播报、市场价格分布每组信息的标题
		private var forwardText:TextField;

		//当前市场价格播报、市场价格分布每组信息的标题
		private var currentText:TextField;

		//添加信息的标题计时器
		private var switchAddTimer:Timer;

		//移除切换信息的标题计时器
		private var switchRemoveTimer:Timer;

		//切换信息的标题计时器延时时长
		private var switchTimerDelay:int = 20;

		//切换信息的标题计时器计数次数
		private var switchTimerRepeatCount:int = 10;

		//信息的标题切换时移动距离
		private var switchMoveLenth:Number = 100;

		//标记是否需要信息的标题
		private var switchBigPointSign:Boolean = false;

		//市场价格分布点父MC
		private var smallPointsMC:Sprite = new Sprite();

		//价格播报市场指示元件的父MC
		private var pricePointersMC:Sprite = new Sprite();

		//价格播报市场点元件的父MC
		private var priceBigPointsMC:Sprite = new Sprite();

		//价格标签动画效果遮罩
		private var priceMask:MovieClip;

		//价格标签动画效果遮罩计时器延时时长
		private var priceMaskTimerDelay:int = 20;

		//价格标签动画效果遮罩计时器计数次数
		private var priceMaskTimerRepeatCount:int = 20;

		//价格标签动画效果遮罩效果完成
		private var priceMaskMoveCmp:Boolean = false;

		//价格标签排序列表
		private var priceCardOrder:Vector.<int>;

		//价格分布播放完成
		private var smallPlayCmp:Boolean = false;

		//价格分布语音播放完成
		private var smallSoundsCmp:Boolean = false;

		//价格播报播放完成
		private var bigPlayCmp:Boolean = false;

		//价格播报语音播放完成
		private var bigSoundsCmp:Boolean = false;

		//语音列表下标
		private var bizSoundIndex:int = 0;

		//价格分布背景地图名称
		private var mapName:String;

		public function PriceDistribute(dataDO:DataDO, mapName:String, marketMainDO:MarketMainDO, marketMap:MarketMap, mapView:MapView, delayTime:Number = 0, timeLength:Number = 0, timeOut:Number = 0) {
			super();
			this.dataDO = dataDO;
			this.marketMainDO = marketMainDO;
			this.marketMap = marketMap;
			this.mapView = mapView;
			this.delayTime = delayTime;
			this.timeLength = timeLength;
			this.timeOut = timeOut;
			this.mapName = mapName;
		}

		public static const BIG_POINT_DEFAULT_SKIN:String = "big_point_default_skin";

		public static const SMALL_POINT_DEFAULT_SKIN:String = "small_point_default_skin";

		public static const PRICEBACK_DEFAULT_SKIN:String = "priceback_default_skin";

		public static const PRICEMASK_DEFAULT_SKIN:String = "pricemask_default_skin";

		public static const PRICEPOINTER_DEFAULT_SKIN:String = "pricepointer_default_skin";

		public static const TEXT_FORMAT:String = "myTextFormat";

		/**
		 *
		 */
		private static var defaultStyles:Object = {
				big_point_default_skin: "BigPoint_default_skin",
				small_point_default_skin: "SmallPoint_default_skin",
				priceback_default_skin: "PriceBack_default_skin",
				pricemask_default_skin: "PriceMask_default_skin",
				pricepointer_default_skin: "PricePointer_default_skin",
				myTextFormat: new TextFormat("宋体", 18, 0x000000)
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
		override protected function configUI():void {
			this.invalidate(InvalidationType.ALL, true);
			this.invalidate(InvalidationType.SIZE, true);
			this.width = 400;
			this.height = 300;
			super.configUI();

		}

		/**
		 *
		 *
		 */
		override protected function dispatchEventState():void {
			var sign:Boolean = false;
			if (this.isPlayCmp && this.isTimeLen) {
				sign = true;
			}
			else if (this.isTimeOut) {
				sign = true;
			}

			if (sign) {
				SpriteUtil.deleteAllChild(smallPointsMC); //点显示太多了会很慢，先清除点，再抛完成事件。
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}

		override protected function draw():void {

		}

		override protected function initPlay():void {
			this.addChild(mapView);
			mapView.width = 490;
			mapView.height = 410;
		}

		override protected function play():void {
			var marketCoordsDOHV:HashVector = marketMainDO.marketCoordsDOHV;
			this.marketCoordsDO = marketCoordsDOHV.findByName(this.mapName) as MarketCoordsDO;
			this.listDOV = dataDO.data;
			this.broadcastListDOV = dataDO.broadcast;
			this.listSmallCount = 0;
			this.broadcastListCount = 0;

			//价格标签 y 坐标方向排序序号，防止指示线交插
			priceCardOrder = new Vector.<int>();
			var yv:Vector.<Number> = new Vector.<Number>;
			if (broadcastListDOV != null) {
				for (var i:int = 0; i < broadcastListDOV.length; i++) {
					var brListDO:ListDO = broadcastListDOV[i];
					var tpdov:Vector.<TextPointDO> = brListDO.listHv;
					if (tpdov != null) {
						for (var j:int = 0; j < tpdov.length; j++) {
							var tpdo:TextPointDO = tpdov[j];
							var name:String = tpdo.name;
							var marketCoordDO:MarketCoordDO = marketCoordsDO.getRealCoordMarketCoordDO(name);
							var my:Number = marketCoordDO.y;
							yv.push(my);
						}
					}
				}
			}

			//trace(yv);
			priceCardOrder = getOrderVector(yv);
			//trace(priceCardOrder);

			//生成图例
			cutLine = new Sprite();
			var rect:Rectangle = this.mapView.getRect(this);
			cutLine.x = rect.x + rect.width;
			cutLine.y = rect.y + rect.height + XMLFastConfig.getCfgInt("distCutLineY");
			this.addChild(cutLine);
			for (var i2:int = 0; i2 < listDOV.length; i2++) {
				var color:uint = getColor(i2);
				var listDO:ListDO = listDOV[i2];

				var cutLineMC:MovieClip = getDisplayObjectInstance(getStyleValue(SMALL_POINT_DEFAULT_SKIN)) as MovieClip;
				cutLineMC.y = -cutLineMC.height - cutLine.height;
				cutLineMC.x = cutLineMC.width / 2;
				ColorTransformUtil.setColor(cutLineMC, color, 1, 1);

				var text:String = listDO.text;
				var tfd:TextField = EffectText.creatTextByStyleName(text, TextStyles.STYLE_CUTLINE_TEXT, color);
				tfd.x = cutLineMC.x + cutLineMC.width;
				tfd.y = cutLineMC.y - tfd.height / 2;

				cutLine.addChild(cutLineMC);
				cutLine.addChild(tfd);
			}
			this.addChild(smallPointsMC);
			this.addChild(pricePointersMC);
			this.addChild(priceBigPointsMC);

			//bizSoundIndex = 4;
			//playBigs();

			playBizSound(dataDO.bizSoundList, 1, handlerbeforeSmallBizPlay);
		}

		private function handlerbeforeSmallBizPlay(e:Event):void {
			smallPlayCmp = true;
			smallSoundsCmp = true;
			playSmallPoint();
		}

		//播放语音
		private function playBizSound(bizSoundV:Vector.<Vector.<Sound>>, length:int, fun:Function):void {
			var cbs:Vector.<Sound> = new Vector.<Sound>();
			var startIndex:int = bizSoundIndex;
			for (var i:int = startIndex; i < startIndex + length; i++) {
				if (i >= 0 && i < bizSoundV.length) {
					var cBizSoundList:Vector.<Sound> = bizSoundV[i];
					for (var j:int; j < cBizSoundList.length; j++) {
						cbs.push(cBizSoundList[j]);
					}
					bizSoundIndex++;
				}
			}
			var mp:Mp3Player = new Mp3Player(cbs);
			mp.addEventListener(Event.COMPLETE, fun);
			this.addChild(mp);
		}

		/**
		 * 计算价格标签排序
		 * @param vv
		 * @return
		 *
		 */
		private function getOrderVector(vv:Vector.<Number>):Vector.<int> {
			var ov:Vector.<int> = new Vector.<int>();
			var cpvv:Vector.<Number> = new Vector.<Number>();
			for (var ic:int = 0; ic < vv.length; ic++) {
				cpvv.push(vv[ic]);
				ov.push(ic);
			}

			for (var i:int = vv.length - 1; i >= 0; i--) {
				for (var j:int = i; j < vv.length - 1; j++) {
					if (cpvv[j] > cpvv[j + 1]) {
						var v:Number = cpvv[j];
						cpvv[j] = cpvv[j + 1];
						cpvv[j + 1] = v;

						var o:Number = ov[j];
						ov[j] = ov[j + 1];
						ov[j + 1] = o;
					}
				}
			}

			var rv:Vector.<int> = new Vector.<int>(vv.length);
			for (var ir:int = 0; ir < ov.length; ir++) {
				var o2:int = ov[ir];
				rv[o2] = ir;
			}
			return rv;
		}

		/**
		 * 显示市场分布点
		 *
		 */
		private function playSmallPoint():void {
			if (smallPlayCmp && smallSoundsCmp) {
				smallPlayCmp = false;
				smallSoundsCmp = false;
				var index:int = this.listSmallCount;
				if (index < listDOV.length) {
					this.listSmallCount++;
					playBizSound(dataDO.bizSoundList, 1, handlerSmallSoundCmp);
					var listDO:ListDO = listDOV[index];
					var color:uint = getColor(index);

					var rect:Rectangle = this.mapView.getRect(this);

					var lname:String = listDO.name;
					currentText = EffectText.creatTextByStyleName(lname, TextStyles.STYLE_LIST_TYPE_TEXT, color);
					currentText.x = rect.width / 2 + switchMoveLenth + XMLFastConfig.getCfgInt("distTitleX");
					currentText.y = XMLFastConfig.getCfgInt("distTitleY");
					this.addChild(currentText);

					switchAddTimer = new Timer(switchTimerDelay, switchTimerRepeatCount);
					switchAddTimer.addEventListener(TimerEvent.TIMER, handlerSwitchAdd);
					switchAddTimer.start();

					var listMC:Sprite = new Sprite();
					ColorTransformUtil.setColor(listMC, color, 1, 1);

					var tpdov:Vector.<TextPointDO> = listDO.listHv;
					for (var jj:int = 0; jj < tpdov.length; jj++) {
						var tpdo:TextPointDO = tpdov[jj];
						var name:String = tpdo.name;
						var marketCoordDO:MarketCoordDO = marketCoordsDO.getRealCoordMarketCoordDO(name);
						var spdobj:MovieClip = getDisplayObjectInstance(getStyleValue(SMALL_POINT_DEFAULT_SKIN)) as MovieClip;
						spdobj.x = (marketCoordDO.x) * this.marketCoordsDO.s + this.marketCoordsDO.x;
						spdobj.y = (marketCoordDO.y) * this.marketCoordsDO.s + this.marketCoordsDO.y;
						listMC.addChild(spdobj);
					}

					//测试显示大量元件时性能
					/*
					for (var i:int =0; i < 20; i++) {
						for (var j:int =0; j < 20; j++) {
							var spdobj2:MovieClip = getDisplayObjectInstance(getStyleValue(SMALL_POINT_DEFAULT_SKIN)) as MovieClip;
							spdobj2.x = (100 + 5 * i);
							spdobj2.y = (100 + 5 * j);
							listMC.addChild(spdobj2);
						}
					}
					*/

					currentListMC = listMC;
					smallPointsMC.addChild(listMC);
					var timer:Timer = new Timer(500, 1);
					timer.addEventListener(TimerEvent.TIMER_COMPLETE, handlerListSmallStartTimerCMP);
					timer.start();
				}
				else {
					playBizSound(dataDO.bizSoundList, 1, handlerSmallSoundAllCmp);
				}
			}
		}

		private function handlerSmallSoundAllCmp(e:Event):void {
			playBigs();
		}

		private function playBigs():void {
			bigPlayCmp = true;
			bigSoundsCmp = true;
			priceMaskMoveCmp = true;
			playStartBigGroupPoint();
		}

		private function handlerSmallSoundCmp(e:Event):void {
			smallSoundsCmp = true;
			playSmallPoint();
		}

		private function handlerSwitchAdd(e:Event):void {
			var palpha:Number = 1 / switchTimerRepeatCount;
			var px:Number = switchMoveLenth / switchTimerRepeatCount;
			if (currentText != null) {
				currentText.alpha += palpha;
				currentText.x -= px;
			}
		}

		private function handlerSwitchRemove(e:Event):void {
			var palpha:Number = 1 / switchTimerRepeatCount;
			var px:Number = switchMoveLenth / switchTimerRepeatCount;
			if (forwardText != null) {
				forwardText.alpha -= palpha;
				forwardText.x -= px;
			}
		}

		private function handlerSwitchRemoveCmp(e:Event):void {
			forwardText.removeEventListener(TimerEvent.TIMER, handlerSwitchAdd);
			forwardText.removeEventListener(TimerEvent.TIMER, handlerSwitchRemove);
			forwardText.removeEventListener(TimerEvent.TIMER_COMPLETE, handlerSwitchRemoveCmp);
			this.removeChild(forwardText);
		}

		private function handlerListSmallStartTimerCMP(e:Event):void {
			listSmallTimer = new Timer(200, 7);
			listSmallTimer.start();
			listSmallTimer.addEventListener(TimerEvent.TIMER, handlerListSmallTimer);
			listSmallTimer.addEventListener(TimerEvent.TIMER_COMPLETE, handlerListSmallTimerCMP);
		}

		private function handlerListSmallTimer(e:Event):void {
			var timer:Timer = e.currentTarget as Timer;
			var state:int = timer.currentCount % 2;
			if (state == 0) {
				currentListMC.visible = false;
			}
			else {
				currentListMC.visible = true;
			}
		}

		private function handlerListSmallTimerCMP(e:Event):void {
			var timer:Timer = new Timer(2000, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, handlerListSmallEndTimerCMP);
			timer.start();
		}

		private function handlerListSmallEndTimerCMP(e:Event):void {
			forwardText = currentText;
			if (forwardText != null) {
				switchRemoveTimer = new Timer(switchTimerDelay, switchTimerRepeatCount);
				switchRemoveTimer.addEventListener(TimerEvent.TIMER, handlerSwitchRemove);
				switchRemoveTimer.addEventListener(TimerEvent.TIMER_COMPLETE, handlerSwitchRemoveCmp);
				switchRemoveTimer.start();
			}
			smallPlayCmp = true;
			playSmallPoint();
		}

		/**
		 *开始播报某几个市场的价格信息
		 *
		 */
		private function playStartBigGroupPoint():void {
			if (priceMaskMoveCmp && bigPlayCmp && bigSoundsCmp) {
				bigPlayCmp = false;
				bigSoundsCmp = false;
				priceMaskMoveCmp = false;
				var index:int = this.broadcastListCount;
				if (index < broadcastListDOV.length) {
					if (broadcastCount == 0) {
						var listDO:ListDO = broadcastListDOV[index];
						var color:uint = 0x000000;
						if (index == 0) {
							color = 0x000000;
						}
						if (index == 1) {
							color = 0x990000;
						}

						var rect:Rectangle = this.mapView.getRect(this);

						var lname:String = listDO.name;
						currentText = EffectText.creatTextByStyleName(lname, TextStyles.STYLE_LIST_TYPE_TEXT, color);
						currentText.x = rect.width / 2 + switchMoveLenth + XMLFastConfig.getCfgInt("distTitleX");
						currentText.y = XMLFastConfig.getCfgInt("distTitleY");
						this.addChild(currentText);
						switchAddTimer = new Timer(switchTimerDelay, switchTimerRepeatCount);
						switchAddTimer.addEventListener(TimerEvent.TIMER, handlerSwitchAdd);
						switchAddTimer.start();
						playBizSound(dataDO.bizSoundList, 1, handlerBeforeBigBizPlay);
					}
					else {
						playBigPoint();
					}
				}
				else {
					this.isPlayCmp = true;
					dispatchEventState();
				}
			}
		}

		private function handlerBeforeBigBizPlay(e:Event):void {
			playBigPoint();
		}

		/**
		 * 播报某几个市场的价格信息
		 *
		 */
		private function playBigPoint():void {
			var index:int = this.broadcastListCount;

			if (index < broadcastListDOV.length) {
				var listDO:ListDO = broadcastListDOV[index];
				var color:uint = 0x000000;
				if (index == 0) {
					color = 0x000000;
				}
				if (index == 1) {
					color = 0x990000;
				}

				var rect:Rectangle = this.mapView.getRect(this);
				var lname:String = listDO.name;

				var listMC:Sprite = new Sprite();
				ColorTransformUtil.setColor(listMC, color, 1, 1);
				var tpdov:Vector.<TextPointDO> = listDO.listHv;
				var jj:int = broadcastCount;
				broadcastCount++;

				if (broadcastCount >= tpdov.length) {
					switchBigPointSign = true;
					broadcastCount = 0;
					this.broadcastListCount++;
				}
				else {
					switchBigPointSign = false;
				}
				var tpdo:TextPointDO = tpdov[jj];
				var name:String = tpdo.name;
				var marketCoordDO:MarketCoordDO = marketCoordsDO.getRealCoordMarketCoordDO(name);
				var ppdobj:MovieClip = getDisplayObjectInstance(getStyleValue(PRICEPOINTER_DEFAULT_SKIN)) as MovieClip;
				var bpdobj:MovieClip = getDisplayObjectInstance(getStyleValue(BIG_POINT_DEFAULT_SKIN)) as MovieClip;
				var pbdobj:MovieClip = getDisplayObjectInstance(getStyleValue(PRICEBACK_DEFAULT_SKIN)) as MovieClip;
				var pmdobj:MovieClip = getDisplayObjectInstance(getStyleValue(PRICEMASK_DEFAULT_SKIN)) as MovieClip;

				pbdobj.width = 100;
				pbdobj.height = 50;

				var n:int = priceCardOrder[broadcastNum];
				broadcastNum++;
				var priceMC:Sprite = new Sprite();
				this.addChild(priceMC);
				priceMC.x = rect.x + rect.width;
				priceMC.y = n * (pbdobj.height + 5);
				priceMC.addChild(pbdobj);

				pmdobj.x = rect.x + rect.width - pmdobj.width;
				pmdobj.y = n * (pbdobj.height + 5);
				priceMC.mask = pmdobj;
				priceMask = pmdobj;

				priceMaskMoveCmp = false;
				var pmtimer:Timer = new Timer(priceMaskTimerDelay, priceMaskTimerRepeatCount);
				pmtimer.addEventListener(TimerEvent.TIMER, handlerPriceMaskTimer);
				pmtimer.addEventListener(TimerEvent.TIMER_COMPLETE, handlerPriceMaskTimerCmp);
				pmtimer.start();

				bpdobj.x = (marketCoordDO.x) * this.marketCoordsDO.s + this.marketCoordsDO.x;
				bpdobj.y = (marketCoordDO.y) * this.marketCoordsDO.s + this.marketCoordsDO.y;

				ppdobj.x = bpdobj.x;
				ppdobj.y = bpdobj.y;
				ppdobj.height = pbdobj.height;
				ppdobj.width = this.lineLength(new Point(bpdobj.x, bpdobj.y), new Point(priceMC.x, priceMC.y + pbdobj.height / 2));
				ppdobj.rotation = this.lineRate(new Point(bpdobj.x, bpdobj.y), new Point(priceMC.x, priceMC.y + pbdobj.height / 2));
				ColorTransformUtil.setColor(ppdobj, color, 1, 1);
				pricePointersMC.addChild(ppdobj);

				var marketName:TextField = EffectText.creatTextByStyleName(marketCoordDO.text, TextStyles.STYLE_DATA_TEXT, color);
				marketName.x = 4;
				marketName.y = 4;
				var value:String = String(Number(tpdo.value).toFixed(2)) + "元";
				var marketPrice:TextField = EffectText.creatTextByStyleName(value, TextStyles.STYLE_DATA_TEXT, color);
				marketPrice.x = marketName.x;
				marketPrice.y = marketName.y + marketName.height;
				priceMC.addChild(marketName);
				priceMC.addChild(marketPrice);

				this.addChild(pmdobj);
				listMC.addChild(bpdobj);
				priceBigPointsMC.addChild(listMC);
				currentBroadcastListMC = listMC;

				var timer:Timer = new Timer(500, 1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, handlerListBigStartTimerCMP);
				timer.start();
			}
		}

		private function handlerBigBizPlay(e:Event):void {
			bigSoundsCmp = true;
			playStartBigGroupPoint();
		}

		private function handlerPriceMaskTimer(e:Event):void {
			priceMask.x += priceMask.width / priceMaskTimerRepeatCount;
		}

		private function handlerPriceMaskTimerCmp(e:Event):void {
			var pmtimer:Timer = e.currentTarget as Timer;
			pmtimer.removeEventListener(TimerEvent.TIMER, handlerPriceMaskTimer);
			pmtimer.removeEventListener(TimerEvent.TIMER_COMPLETE, handlerPriceMaskTimerCmp);
			priceMaskMoveCmp = true;
			playStartBigGroupPoint();
		}

		private function handlerListBigStartTimerCMP(e:Event):void {
			playBizSound(dataDO.bizSoundList, 1, handlerBigBizPlay);
			listSmallTimer = new Timer(200, 7);
			listSmallTimer.start();
			listSmallTimer.addEventListener(TimerEvent.TIMER, handlerListBigTimer);
			listSmallTimer.addEventListener(TimerEvent.TIMER_COMPLETE, handlerListBigTimerCMP);
		}

		private function handlerListBigTimer(e:Event):void {
			var timer:Timer = e.currentTarget as Timer;
			var state:int = timer.currentCount % 2;
			if (state == 0) {
				currentBroadcastListMC.visible = false;
			}
			else {
				currentBroadcastListMC.visible = true;
			}
		}

		private function handlerListBigTimerCMP(e:Event):void {
			var timer:Timer = new Timer(2000, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, handlerListBigEndTimerCMP);
			timer.start();
		}

		private function handlerListBigEndTimerCMP(e:Event):void {
			forwardText = currentText;
			if (switchBigPointSign && forwardText != null) {
				switchRemoveTimer = new Timer(switchTimerDelay, switchTimerRepeatCount);
				switchRemoveTimer.addEventListener(TimerEvent.TIMER, handlerSwitchRemove);
				switchRemoveTimer.addEventListener(TimerEvent.TIMER_COMPLETE, handlerSwitchRemoveCmp);
				switchRemoveTimer.start();
			}
			bigPlayCmp = true;
			playStartBigGroupPoint();
		}

		/**
		 * 计算线长
		 * @param p1
		 * @param p2
		 * @return
		 *
		 */
		private function lineLength(p1:Point, p2:Point):Number {
			return Math.sqrt(Math.pow((p1.x - p2.x), 2) + Math.pow((p1.y - p2.y), 2));
		}

		/**
		 * 计算旋转角度
		 * @param p1
		 * @param p2
		 * @return
		 *
		 */
		private function lineRate(p1:Point, p2:Point):Number {
			var rate:Number = 0;

			if (p2.x - p1.x == 0) {
				rate = p2.y - p1.y > 0 ? 90 : -90;
			}
			else {
				rate = Math.atan((p2.y - p1.y) / (p2.x - p1.x)) * 180 / Math.PI;
			}
			return rate;
		}

		/**
		 * 样式颜色，以后需外部配置
		 * @param i
		 * @return
		 *
		 */
		private function getColor(i:int):uint {
			var color:uint = 0x000000;
			if (i == 0) {
				color = 0x000099;
			}
			else if (i == 1) {
				color = 0x999900;
			}
			else if (i == 2) {
				color = 0x009900;
			}
			else if (i == 3) {
				color = 0x990000;
			}
			return color;
		}

		public function get dataDO():DataDO {
			return _dataDO;
		}

		public function set dataDO(value:DataDO):void {
			_dataDO = value;
		}

	}
}
