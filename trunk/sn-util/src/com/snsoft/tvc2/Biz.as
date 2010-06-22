package com.snsoft.tvc2{
	import com.snsoft.tvc2.dataObject.BizDO;
	import com.snsoft.tvc2.dataObject.DataDO;
	import com.snsoft.util.HashVector;
	
	import fl.core.UIComponent;
	
	public class Biz extends UIComponent{
		
		private var bizDO:BizDO;
		
		private var BIZ_TYPE_POLYLINES:String = "polylines";
		
		public function Biz(bizDO:BizDO){
			super();
			this.bizDO = bizDO;
		}
		
		/**
		 * 
		 * 
		 */		
		override protected function draw():void{
			play();
		}
		
		private function play():void{
			if(bizDO != null){
				var dataDO:DataDO = bizDO.dataDO;
				var type:String = bizDO.type;
				if(dataDO != null){
					if(type == BIZ_TYPE_POLYLINES){
						
					}
				}
				
				var mediasHv:HashVector = bizDO.mediasHv;
				if(mediasHv != null){
					
				}
			}
		}
	}
}