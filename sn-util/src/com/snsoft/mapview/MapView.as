package com.snsoft.mapview{
	import com.snsoft.map.MapAreaDO;
	import com.snsoft.map.WorkSpaceDO;
	import com.snsoft.map.util.MapUtil;
	import com.snsoft.mapview.util.MapViewDraw;
	import com.snsoft.util.HashVector;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	[Style(name="backSkin", type="Class")]
	
	/**
	 * 显示地图 
	 * @author Administrator
	 * 
	 */	
	public class MapView extends UIComponent{
		
		public static const AREA_DOUBLE_CLICK_EVENT:String = "AREA_DOUBLE_CLICK_EVENT";
		
		private var _doubleClickAreaId:String;
		
		private var _workSpaceDO:WorkSpaceDO = null;
		
		private var areaBtnsLayer:Sprite = new Sprite();
		
		private var mapLinesLayer:Sprite = new Sprite();
		
		private var backLayer:Sprite = new Sprite();
		
		private var cuntyLableLayer:Sprite = new Sprite();
		
		private var cuntyLable:CuntyLable = new CuntyLable("","");
		
		private var lightShapesLayer:Sprite = new Sprite();
		
		private var LIGHT_SPACE:Number = 40;
		
		private var _backMaskRec:Rectangle = null;
		
		public function MapView(){
			super();
		}
		
		/**
		 * 
		 */		
		private static var defaultStyles:Object = {backSkin:"Map_backskin"};
		
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
			
			cuntyLableLayer.visible = false;
			cuntyLableLayer.mouseChildren = false;
			cuntyLableLayer.mouseEnabled = false;
			cuntyLableLayer.buttonMode = false;
			
			
			lightShapesLayer.mouseChildren = false;
			lightShapesLayer.mouseEnabled = false;
			lightShapesLayer.buttonMode = false;
			
			this.invalidate(InvalidationType.ALL,true);
			this.invalidate(InvalidationType.SIZE,true);
			super.configUI();
		}
		
		/**
		 * 
		 * 
		 */		
		override protected function draw():void{
			
			MapUtil.deleteAllChild(this);
			MapUtil.deleteAllChild(backLayer);
			MapUtil.deleteAllChild(areaBtnsLayer);
			MapUtil.deleteAllChild(mapLinesLayer);
			MapUtil.deleteAllChild(lightShapesLayer);
			MapUtil.deleteAllChild(cuntyLableLayer);
			
			this.addChild(backLayer);
			this.addChild(mapLinesLayer);
			this.addChild(areaBtnsLayer);
			this.addChild(lightShapesLayer);
			this.addChild(cuntyLableLayer);
			
			cuntyLableLayer.addChild(cuntyLable);
			
			var wsdo:WorkSpaceDO = this.workSpaceDO;
			if(wsdo != null){
				var madohv:HashVector = wsdo.mapAreaDOHashArray;
				for(var i:int = 0;i<madohv.length;i ++){
					var mado:MapAreaDO = madohv.findByIndex(i) as MapAreaDO;
					if(mado != null){
						var av:AreaView = new AreaView();
						av.mapAreaDO = mado;
						av.drawNow();
						areaBtnsLayer.addChild(av);	
						av.doubleClickEnabled = true;
						av.addEventListener(MouseEvent.MOUSE_OVER,handlerAreaViewMouseOver);
						av.addEventListener(MouseEvent.MOUSE_OUT,handlerAreaViewMouseOut);
						av.addEventListener(MouseEvent.DOUBLE_CLICK,handlerAreaViewDoubleClick);
					}
				}
				
				var maplinesSprite:Sprite = this.drawMapLines(wsdo);
				var dsFilter:DropShadowFilter = new DropShadowFilter(0,0,0x000000,1,4,4);
				var filterAry:Array = new Array();
				filterAry.push(dsFilter);
				maplinesSprite.filters = filterAry;
				this.mapLinesLayer.addChild(maplinesSprite);
				
				var backMask:Sprite = this.drawBackMask(wsdo);
				this.backLayer.addChild(backMask);
				
				_backMaskRec = backMask.getRect(this.backLayer);
				var sizep:Point = new Point(_backMaskRec.width,_backMaskRec.height);
				var placep:Point = new Point(_backMaskRec.x,_backMaskRec.y);
				
				var back:DisplayObject = getDisplayObjectInstance(getStyleValue("backSkin"));
				back.mask = backMask;
				MapUtil.setSpriteSize(back,sizep);
				MapUtil.setSpritePlace(back,placep);
				this.backLayer.addChild(back);
			}
			else{
				trace("WorkSpaceDO:"+WorkSpaceDO);
			}
		}
		
		/**
		 * 
		 * @param workSpaceDO
		 * @return 
		 * 
		 */		
		private function drawBackMask(workSpaceDO:WorkSpaceDO):Sprite{
			if(workSpaceDO != null){
				var sprite:Sprite = new Sprite();
				var madohv:HashVector = workSpaceDO.mapAreaDOHashArray;
				for(var i:int = 0;i<madohv.length;i ++){
					var mado:MapAreaDO = madohv.findByIndex(i) as MapAreaDO;
					var ary:Array = mado.pointArray.toArray();
					var shape:Shape = MapViewDraw.drawFill(0xffffff,0xffffff,0,1,ary);
					sprite.addChild(shape);
				}
				return sprite;
			}
			return null;
		}
		
		private function drawMapLines(workSpaceDO:WorkSpaceDO):Sprite{
			if(workSpaceDO != null){
				var sprite:Sprite = new Sprite();
				var madohv:HashVector = workSpaceDO.mapAreaDOHashArray;
				for(var i:int = 0;i<madohv.length;i ++){
					var mado:MapAreaDO = madohv.findByIndex(i) as MapAreaDO;
					var ary:Array = mado.pointArray.toArray();
					var shape:Shape = MapViewDraw.drawCloseLines(0xffffff,ary);
					sprite.addChild(shape);
				}
				return sprite;
			}
			return null;
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerAreaViewDoubleClick(e:Event):void{
			var av:AreaView = e.currentTarget as AreaView;
			this._doubleClickAreaId = av.mapAreaDO.areaId;
			this.dispatchEvent(new Event(AREA_DOUBLE_CLICK_EVENT));
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
			var mapRect:Rectangle = areaBtnsLayer.getRect(this);
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
			
			MapUtil.deleteAllChild(this.lightShapesLayer);
			
			this.lightShapesLayer.addChild(shapeX);
			this.lightShapesLayer.addChild(shapeY);
			this.lightShapesLayer.visible = true;
			cuntyLableLayer.visible = true;
		}
		
		/**
		 * 事件 
		 * @param e
		 * 
		 */		
		private function handlerAreaViewMouseOut(e:Event):void{
			this.lightShapesLayer.visible = false;
			cuntyLableLayer.visible = false;
		}
		
		public function get workSpaceDO():WorkSpaceDO
		{
			return _workSpaceDO;
		}
		
		public function set workSpaceDO(value:WorkSpaceDO):void
		{
			_workSpaceDO = value;
		}

		public function get doubleClickAreaId():String
		{
			return _doubleClickAreaId;
		}

		public function get backMaskRec():Rectangle
		{
			return _backMaskRec;
		}


	}
}