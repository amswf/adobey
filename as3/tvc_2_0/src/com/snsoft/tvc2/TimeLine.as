package com.snsoft.tvc2 {
	import com.snsoft.tvc2.dataObject.BizDO;
	import com.snsoft.tvc2.dataObject.MarketMainDO;
	import com.snsoft.tvc2.dataObject.TimeLineDO;
	import com.snsoft.util.HashVector;
	import com.snsoft.util.SpriteUtil;

	import fl.core.InvalidationType;
	import fl.core.UIComponent;

	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * 时间线
	 * @author Administrator
	 *
	 */
	public class TimeLine extends UIComponent {

		//时间线数据对象
		private var timeLineDO:TimeLineDO = new TimeLineDO();

		//当前播放业务下标
		private var bizIndex:int = 0;

		//市场数据主对象
		private var marketMainDO:MarketMainDO;

		//切换业务效果时，上一个业务
		private var forwardBiz:Biz;

		//切换业务效果时，当前一个业务
		private var currentBiz:Biz;

		//切换业务，添加计时器
		private var switchAddTimer:Timer;

		//切换业务，移除计时器
		private var switchRemoveTimer:Timer;

		//切换业务，计时器延时时长
		private var switchTimerDelay:int = 20;

		//切换业务，计时器计数个数
		private var switchTimerRepeatCount:int = 10;

		//切换业务，切换完成标记
		private var switchTimerCmp:Boolean = false;

		//业务完成标记
		private var bizCmp:Boolean = false;

		//切换业务，移动距离
		private var switchMoveLenth:Number = 100;

		//时间线是否停止状态
		private var isStop:Boolean = false;

		//时间线暂停计时器，暂停后计时器启动，等待时间线播放状态时播放下一个业务
		private var playTimer:Timer;

		private var isRemoved:Boolean = false;

		public function TimeLine(timeLineDO:TimeLineDO, marketMainDO:MarketMainDO) {
			super();

			this.timeLineDO = timeLineDO;
			this.marketMainDO = marketMainDO;
		}

		/**
		 *
		 *
		 */
		override protected function configUI():void {
			this.invalidate(InvalidationType.ALL, true);
			this.invalidate(InvalidationType.SIZE, true);
			super.configUI();
		}

		/**
		 *
		 *
		 */
		override protected function draw():void {
			trace("TimeLine.play()");
			this.addEventListener(Event.REMOVED_FROM_STAGE, handlerRemove);
			bizCmp = true
			switchTimerCmp = true;
			play();
		}

		private function handlerRemove(e:Event):void {
			isRemoved = true;
			if (this.switchAddTimer != null) {
				this.switchAddTimer.stop();
			}
			if (this.switchRemoveTimer != null) {
				this.switchRemoveTimer.stop();
			}
			if (this.playTimer != null) {
				this.playTimer.stop();
			}
			SpriteUtil.deleteAllChild(this);
		}

		public function pausePlay():void {
			var sign:Boolean = true;
			if (sign) {
				sign = false;
				if (isStop) {
					isStop = false;
					if (playTimer != null) {
						playTimer.stop();
						playTimer.removeEventListener(TimerEvent.TIMER, handlerPauseTimer);
					}
					play();
				}
				else {
					isStop = true;
					if (playTimer != null) {
						playTimer.stop();
						playTimer.removeEventListener(TimerEvent.TIMER, handlerPauseTimer);
					}
					playTimer = new Timer(20, 0);
					playTimer.addEventListener(TimerEvent.TIMER, handlerPauseTimer);
					playTimer.start();
				}
				sign = true;
			}
		}

		private function handlerPauseTimer(e:Event):void {
			if (!isStop) {
				var timer:Timer = e.currentTarget as Timer;
				timer.removeEventListener(TimerEvent.TIMER, handlerPauseTimer);
				play();
			}
		}

		private function play():void {
			if (bizCmp && switchTimerCmp && !isStop && !isRemoved) {
				bizCmp = false;
				switchTimerCmp = false;

				var bizHv:HashVector = this.timeLineDO.bizDOHv;
				if (bizHv != null && bizIndex < bizHv.length) {
					var bizDO:BizDO = bizHv.findByIndex(bizIndex) as BizDO;
					if (bizDO != null) {

						if (currentBiz != null) {
							forwardBiz = currentBiz;
							switchRemoveTimer = new Timer(switchTimerDelay, switchTimerRepeatCount);
							switchRemoveTimer.addEventListener(TimerEvent.TIMER, handlerSwitchRemoveTimer);
							switchRemoveTimer.addEventListener(TimerEvent.TIMER_COMPLETE, handlerSwitchRemoveTimerCmp);
							switchRemoveTimer.start();
						}

						currentBiz = new Biz(bizDO, marketMainDO);
						currentBiz.alpha = 0;
						currentBiz.x = currentBiz.x + switchMoveLenth;
						currentBiz.addEventListener(Event.COMPLETE, handlerBizComplete);
						this.addChild(currentBiz);
						currentBiz.drawNow();

						switchAddTimer = new Timer(switchTimerDelay, switchTimerRepeatCount);
						switchTimerCmp = false;
						switchAddTimer.addEventListener(TimerEvent.TIMER, handlerSwitchAddTimer);
						switchAddTimer.addEventListener(TimerEvent.TIMER_COMPLETE, handlerSwitchAddTimerCmp);
						switchAddTimer.start();
					}
					bizIndex++;
				}
				else {
					trace("TimeLine.play.dispatchEventState:Event.COMPLETE", bizIndex, "<", bizHv.length);
					this.dispatchEvent(new Event(Event.COMPLETE));
				}
			}
		}

		private function handlerSwitchAddTimer(e:Event):void {
			var palpha:Number = 1 / switchTimerRepeatCount;

			var px:Number = switchMoveLenth / switchTimerRepeatCount;

			currentBiz.alpha += palpha;
			currentBiz.x -= px;
		}

		private function handlerSwitchAddTimerCmp(e:Event):void {
			switchTimerCmp = true;
			play();
		}

		private function handlerBizComplete(e:Event):void {
			bizCmp = true;
			play();
		}

		private function handlerSwitchRemoveTimer(e:Event):void {
			var palpha:Number = 1 / switchTimerRepeatCount;
			var px:Number = switchMoveLenth / switchTimerRepeatCount;
			if (forwardBiz != null) {
				forwardBiz.alpha -= palpha;
				forwardBiz.x -= px;
			}
		}

		private function handlerSwitchRemoveTimerCmp(e:Event):void {
			switchRemoveTimer.removeEventListener(TimerEvent.TIMER, handlerSwitchRemoveTimerCmp);
			switchRemoveTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, handlerSwitchRemoveTimer);
			this.removeChild(forwardBiz);
		}

	}
}
