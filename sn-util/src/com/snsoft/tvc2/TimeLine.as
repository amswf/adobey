package com.snsoft.tvc2{
	import com.snsoft.tvc2.dataObject.BizDO;
	import com.snsoft.tvc2.dataObject.MarketMainDO;
	import com.snsoft.tvc2.dataObject.TimeLineDO;
	import com.snsoft.util.HashVector;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.events.Event;
	
	public class TimeLine extends UIComponent{
		
		private var timeLineDO:TimeLineDO = new TimeLineDO();
		
		private var bizIndex:int = 0;
		
		private var marketMainDO:MarketMainDO;
		
		public function TimeLine(timeLineDO:TimeLineDO,marketMainDO:MarketMainDO){
			super();
			
			this.timeLineDO = timeLineDO;
			this.marketMainDO = marketMainDO;
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
			trace("tlPlay");
		}
		
		private function play():void{
			var bizHv:HashVector = this.timeLineDO.bizDOHv;
			if(bizHv != null && bizIndex < bizHv.length){
				var bizDO:BizDO = bizHv.findByIndex(bizIndex) as BizDO;
				if(bizDO != null){
					var biz:Biz = new Biz(bizDO,marketMainDO);
					biz.x = 80;
					biz.y = 80;
					biz.addEventListener(Event.COMPLETE,handlerBizComplete);
					this.addChild(biz);
					biz.drawNow();
				}
			}
		}
		
		private function handlerBizComplete(e:Event):void{
			var biz:Biz = e.currentTarget as Biz;
			if(biz != null){
				this.removeChild(biz);
				bizIndex ++;
				play();
			}
		}
	}
}