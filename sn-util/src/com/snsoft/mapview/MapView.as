package com.snsoft.mapview{
	import com.snsoft.map.MapAreaDO;
	import com.snsoft.map.WorkSpaceDO;
	import com.snsoft.util.HashVector;
	
	import fl.core.UIComponent;
	
	import flash.geom.ColorTransform;
	import flash.geom.Transform;
	
	/**
	 * 显示地图 
	 * @author Administrator
	 * 
	 */	
	public class MapView extends UIComponent{
		
		private var _workSpaceDO:WorkSpaceDO = null;
		
		private var areaBtns:UIComponent = new UIComponent();
		
		private var mapLines:UIComponent = new UIComponent();
		
		private var back:UIComponent = new UIComponent();
		
		public function MapView(){
			super();
		}
		
		/**
		 *  
		 * 
		 */				
		override protected function configUI():void{
			this.addChild(back);
			this.addChild(areaBtns);
			this.addChild(mapLines);
			
			var ctf:ColorTransform = areaBtns.transform.colorTransform;
			ctf.alphaOffset = 0;
			ctf.alphaMultiplier = 1;
			ctf.redOffset = 128;
			ctf.redMultiplier = 1;
			areaBtns.transform.colorTransform = ctf;
			
		}
		
		/**
		 * 
		 * 
		 */		
		override protected function draw():void{
			var wsdo:WorkSpaceDO = this.workSpaceDO;
			if(wsdo != null){
				var madohv:HashVector = wsdo.mapAreaDOHashArray;
				for(var i:int = 0;i<madohv.length;i ++){
					var mado:MapAreaDO = madohv.findByIndex(i) as MapAreaDO;
					if(mado != null){
						var av:AreaView = new AreaView();
						av.mapAreaDO = mado;
						av.drawNow();
						areaBtns.addChild(av);
					}
				}
			}
			else{
				trace("WorkSpaceDO:"+WorkSpaceDO);
			}
			
		}
		
		

		public function get workSpaceDO():WorkSpaceDO
		{
			return _workSpaceDO;
		}

		public function set workSpaceDO(value:WorkSpaceDO):void
		{
			_workSpaceDO = value;
		}

		
	}
}