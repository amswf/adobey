package com.snsoft.mapview{
	import com.snsoft.map.MapAreaDO;
	import com.snsoft.map.WorkSpaceDO;
	import com.snsoft.map.util.MapUtil;
	import com.snsoft.mapview.util.MapViewDraw;
	import com.snsoft.util.HashVector;
	
	import fl.core.UIComponent;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
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
		
		private var cuntyLable:CuntyLable = new CuntyLable("","");
		
		private var lightShapes:UIComponent = new UIComponent();
		
		private var LIGHT_SPACE:Number = 40;
		
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
			this.addChild(lightShapes);
			this.addChild(cuntyLable);
			
			cuntyLable.visible = false;
			cuntyLable.mouseChildren = false;
			cuntyLable.mouseEnabled = false;
			cuntyLable.buttonMode = false;
			
			lightShapes.mouseChildren = false;
			lightShapes.mouseEnabled = false;
			lightShapes.buttonMode = false;
			
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
						av.addEventListener(MouseEvent.MOUSE_OVER,handlerAreaViewMouseOver);
						av.addEventListener(MouseEvent.MOUSE_OUT,handlerAreaViewMouseOut);
					}
				}
			}
			else{
				trace("WorkSpaceDO:"+WorkSpaceDO);
			}
		}
		
		/**
		 * 事件 
		 * @param e
		 * 
		 */		
		private function handlerAreaViewMouseOver(e:Event):void{
			var av:AreaView = e.currentTarget as AreaView;
			var mado:MapAreaDO = av.mapAreaDO;
			cuntyLable.nameStr = mado.areaName;
			var mapRect:Rectangle = areaBtns.getRect(this);
			var areaRect:Rectangle = av.getRect(av.parent);
			
			var mapCenterP:Point = new Point();
			mapCenterP.x = mapRect.x + mapRect.width / 2;
			mapCenterP.y = mapRect.y + mapRect.height / 2;
			
			var areaCenterP:Point = new Point();
			areaCenterP.x = areaRect.x + areaRect.width / 2 + mado.areaNamePlace.x;
			areaCenterP.y = areaRect.y + areaRect.height / 2 + mado.areaNamePlace.y;
			
			//cuntyLable的四边形四个顶点中与areaCenterP最近点的相对于 cuntyLable坐标的坐标
			var np:Point = new Point();
			
			if(areaCenterP.x > mapCenterP.x){
				np.x = cuntyLable.width;
				cuntyLable.x =areaCenterP.x - ( LIGHT_SPACE + np.x);
			}
			else{
				np.x = 0;
				cuntyLable.x =areaCenterP.x + (LIGHT_SPACE + np.x);
			}
			
			if(areaCenterP.y > mapCenterP.y){
				np.y = cuntyLable.height;
				cuntyLable.y =areaCenterP.y - (LIGHT_SPACE + np.y);
			}
			else{
				np.y = 0;
				cuntyLable.y =areaCenterP.y + (LIGHT_SPACE + np.y);
			}
			
			//x 轴方向两点
			var px1:Point = new Point(cuntyLable.x,cuntyLable.y + np.y);
			var px2:Point = new Point(cuntyLable.x+cuntyLable.width,cuntyLable.y + np.y);
			
			//y 轴方向两点
			var py1:Point = new Point(cuntyLable.x + np.x,cuntyLable.y);
			var py2:Point = new Point(cuntyLable.x + np.x,cuntyLable.y + cuntyLable.height);
			
			var aryx:Array = new Array();
			aryx.push(px1,px2,areaCenterP);
			
			var aryy:Array = new Array();
			aryy.push(py1,py2,areaCenterP);
			
			var shapeX:Shape = MapViewDraw.drawFill(0x000000,0xffffff,0.1,0.5,aryx);
			var shapeY:Shape = MapViewDraw.drawFill(0x000000,0xffffff,0.1,0.5,aryy);
			
			MapUtil.deleteAllChild(this.lightShapes);
			
			this.lightShapes.addChild(shapeX);
			this.lightShapes.addChild(shapeY);
			this.lightShapes.visible = true;
			cuntyLable.visible = true;
		}
		
		/**
		 * 事件 
		 * @param e
		 * 
		 */		
		private function handlerAreaViewMouseOut(e:Event):void{
			this.lightShapes.visible = false;
			cuntyLable.visible = false;
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