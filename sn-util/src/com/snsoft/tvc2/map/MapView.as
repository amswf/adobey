package com.snsoft.tvc2.map{
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
	import flash.text.TextFormat;
	
	[Style(name="myTextFormat", type="Class")]
	
	/**
	 * 显示地图 
	 * @author Administrator
	 * 
	 */	
	public class MapView extends UIComponent{
		
		public static const AREA_DOUBLE_CLICK_EVENT:String = "AREA_DOUBLE_CLICK_EVENT";
		
		private var _doubleClickAreaView:AreaView;
		
		private var _workSpaceDO:WorkSpaceDO = null;
		
		private var areaBtnsLayer:Sprite = new Sprite();
		
		private var mapLinesLayer:Sprite = new Sprite();
		
		private var backLayer:Sprite = new Sprite();
		
		private var lightShapesLayer:Sprite = new Sprite();
		
		private var LIGHT_SPACE:Number = 40;
		
		private var _backMaskRec:Rectangle = null;
		
		private var mapAreaViewHv:HashVector;
		
		private var areaDrawCount:int = 0;
		
		private var isDrawCmp:Boolean = false;
		
		public function MapView(){
			super();
		}
		
		public static const TEXT_FORMAT:String = "myTextFormat";
		
		/**
		 * 
		 */		
		private static var defaultStyles:Object = {
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
			if(!isDrawCmp){
				isDrawCmp = true;
				
				MapUtil.deleteAllChild(this);
				MapUtil.deleteAllChild(backLayer);
				MapUtil.deleteAllChild(areaBtnsLayer);
				MapUtil.deleteAllChild(mapLinesLayer);
				MapUtil.deleteAllChild(lightShapesLayer);
				
				this.addChild(backLayer);
				this.addChild(mapLinesLayer);
				this.addChild(areaBtnsLayer);
				this.addChild(lightShapesLayer);
				
				mapAreaViewHv = new HashVector();
				var wsdo:WorkSpaceDO = this.workSpaceDO;
				if(wsdo != null){
					var madohv:HashVector = wsdo.mapAreaDOHashArray;
					areaDrawCount = madohv.length;
					for(var i:int = 0;i<madohv.length;i ++){
						var mado:MapAreaDO = madohv.findByIndex(i) as MapAreaDO;
						if(mado != null){
							var av:AreaView = new AreaView();
							av.setStyle(TEXT_FORMAT,this.getStyleValue(TEXT_FORMAT));
							av.addEventListener(Event.COMPLETE,handlerAreaViewDrawCmp);
							av.mapAreaDO = mado;
							av.drawNow();
							areaBtnsLayer.addChild(av);
							mapAreaViewHv.put(mado.areaName,av);
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
				}
				else{
					trace("WorkSpaceDO:"+WorkSpaceDO);
				}
			}
		}
		
		private function handlerAreaViewDrawCmp(e:Event):void{
			
			areaDrawCount --;
			trace("handlerAreaViewDrawCmp",areaDrawCount);
			if(areaDrawCount == 0){
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		public function setMapAreaColor(areaName:String,color:uint,alpha:Number = 1):void{
			trace("setMapAreaColor",areaName);
			if(mapAreaViewHv != null){
				var av:AreaView = mapAreaViewHv.findByName(areaName) as AreaView;
				if(av != null){
					trace("setMapAreaColor",color);
					av.setAreaColor(color,alpha);	
				}
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
			this._doubleClickAreaView = av;
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
			
			var mapRect:Rectangle = areaBtnsLayer.getRect(this);
			var areaRect:Rectangle = av.getRect(av.parent);
			
			var mapCenterP:Point = new Point();
			mapCenterP.x = mapRect.x + mapRect.width / 2;
			mapCenterP.y = mapRect.y + mapRect.height / 2;
			
			var areaCenterP:Point = new Point();
			areaCenterP.x = areaRect.x + areaRect.width / 2 + mado.areaNamePlace.x;
			areaCenterP.y = areaRect.y + areaRect.height / 2 + mado.areaNamePlace.y;
			
			
		}
		
		public function get workSpaceDO():WorkSpaceDO
		{
			return _workSpaceDO;
		}
		
		public function set workSpaceDO(value:WorkSpaceDO):void
		{
			_workSpaceDO = value;
		}
		
		public function get backMaskRec():Rectangle
		{
			return _backMaskRec;
		}
		
		public function get doubleClickAreaView():AreaView
		{
			return _doubleClickAreaView;
		}
		
		public function set doubleClickAreaView(value:AreaView):void
		{
			_doubleClickAreaView = value;
		}
		
		
	}
}