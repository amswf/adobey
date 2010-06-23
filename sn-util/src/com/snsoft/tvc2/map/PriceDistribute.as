package com.snsoft.tvc2.map{
	import com.snsoft.tvc2.Business;
	import com.snsoft.tvc2.dataObject.DataDO;
	import com.snsoft.tvc2.dataObject.ListDO;
	import com.snsoft.tvc2.dataObject.MarketCoordDO;
	import com.snsoft.tvc2.dataObject.MarketCoordsDO;
	import com.snsoft.tvc2.dataObject.MarketMainDO;
	import com.snsoft.tvc2.dataObject.MarketMap;
	import com.snsoft.tvc2.dataObject.TextPointDO;
	import com.snsoft.util.ColorTransformUtil;
	import com.snsoft.util.HashVector;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextFormat;

	public class PriceDistribute extends Business{
		
		//点列表的列表
		private var _dataDO:DataDO;
		
		private var marketMainDO:MarketMainDO;
		
		private var marketMap:MarketMap;
		
		private var MAP_NAME:String = "china";
		
		public function PriceDistribute(dataDO:DataDO,marketMainDO:MarketMainDO,marketMap:MarketMap,delayTime:Number = 0,timeLength:Number = 0,timeOut:Number = 0)	{
			super();
			this.dataDO = dataDO;
			this.marketMainDO = marketMainDO;
			this.marketMap = marketMap;
			this.delayTime = delayTime;
			this.timeLength = timeLength;
			this.timeOut = timeOut;
		}
		
		public static const BIG_POINT_DEFAULT_SKIN:String = "big_point_default_skin";
		
		public static const SMALL_POINT_DEFAULT_SKIN:String = "small_point_default_skin";
		
		public static const TEXT_FORMAT:String = "myTextFormat";
		
		/**
		 * 
		 */		
		private static var defaultStyles:Object = {
			big_point_default_skin:"BigPoint_default_skin",
			small_point_default_skin:"SmallPoint_default_skin",
			myTextFormat:new TextFormat("宋体",13,0x000000)
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
			
		override protected function draw():void {
			
		}
		
		override protected function play():void {
			var marketCoordsDOHV:HashVector = marketMainDO.marketCoordsDOHV;
			var marketCoordsDO:MarketCoordsDO= marketCoordsDOHV.findByName(MAP_NAME) as MarketCoordsDO;
			 
			 
			var listDOV:Vector.<ListDO> = dataDO.data;
			for(var ii:int;ii<listDOV.length;ii++){
				var listDO:ListDO = listDOV[ii];
				var color:uint = 0x000000;
				if(ii == 0){
					color = 0x000000;
				}
				if(ii == 1){
					color = 0x009900;
				}
				if(ii == 2){
					color = 0x990000; 
				}
				
				var listMC:Sprite = new Sprite();
				ColorTransformUtil.setColor(listMC,color);
				
				var tpdov:Vector.<TextPointDO> = listDO.listHv;
				for(var jj:int = 0;jj<tpdov.length;jj++){
					var tpdo:TextPointDO = tpdov[jj];
					var name:String = tpdo.name;
					var marketCoordDO:MarketCoordDO = marketCoordsDO.getRealCoordMarketCoordDO(name);
					var spdobj:MovieClip = getDisplayObjectInstance(getStyleValue(SMALL_POINT_DEFAULT_SKIN)) as MovieClip;
					spdobj.x = (marketCoordDO.x - this.marketMap.x) * this.marketMap.s;
					spdobj.y = (marketCoordDO.y - this.marketMap.y) * this.marketMap.s;
					trace(spdobj.x,spdobj.y);
					listMC.addChild(spdobj);
				}
				this.addChild(listMC);
			}
		}

		public function get dataDO():DataDO
		{
			return _dataDO;
		}

		public function set dataDO(value:DataDO):void
		{
			_dataDO = value;
		}

	}
}