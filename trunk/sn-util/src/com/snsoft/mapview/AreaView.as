package com.snsoft.mapview{
	import com.snsoft.map.MapAreaDO;
	import com.snsoft.mapview.util.MapViewDraw;
	
	import fl.core.UIComponent;
	
	import flash.display.Shape;
	
	public class AreaView extends UIComponent{
		
		private var _mapAreaDO:MapAreaDO = null;
		
		/**
		 * 
		 * 
		 */		
		public function AreaView()
		{
			super();
		}
		
		/**
		 *  
		 * 
		 */				
		override protected function configUI():void{
			
		}
		
		/**
		 * 
		 * 
		 */		
		override protected function draw():void{
			var mado:MapAreaDO = this.mapAreaDO;
			if(mado != null){
				var pointAry:Array = mado.pointArray.toArray();
				var cl:Shape = MapViewDraw.drawFill(0xffffff,0x000000,1,1,pointAry);
				this.addChild(cl);
			}
			else{
				trace("mapAreaDO:"+mapAreaDO);
			}
		}
		
		public function get mapAreaDO():MapAreaDO
		{
			return _mapAreaDO;
		}

		public function set mapAreaDO(value:MapAreaDO):void
		{
			_mapAreaDO = value;
		}

	}
}