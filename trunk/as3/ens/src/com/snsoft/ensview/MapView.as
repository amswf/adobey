package com.snsoft.ensview {
	import com.snsoft.mapview.AreaNameView;
	import com.snsoft.mapview.AreaView;
	import com.snsoft.mapview.Config;
	import com.snsoft.mapview.dataObj.MapAreaDO;
	import com.snsoft.mapview.dataObj.WorkSpaceDO;
	import com.snsoft.mapview.util.MapViewDraw;
	import com.snsoft.util.HashVector;
	import com.snsoft.util.PointUtil;
	import com.snsoft.util.xmldom.XMLFastConfig;

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
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	[Style(name = "backSkin", type = "Class")]

	/**
	 * 显示地图
	 * @author Administrator
	 *
	 */
	public class MapView extends UIComponent {

		public static const AREA_DOUBLE_CLICK_EVENT:String = "AREA_DOUBLE_CLICK_EVENT";

		public static const AREA_CLICK_EVENT:String = "AREA_CLICK_EVENT";

		public static const AREA_MOUSE_OVER_EVENT:String = "AREA_MOUSE_OVER_EVENT";

		public static const AREA_MOUSE_OUT_EVENT:String = "AREA_MOUSE_OUT_EVENT";

		private var _currentAreaView:AreaNameView;

		private var _workSpaceDO:WorkSpaceDO = null;

		private var areaBtnsLayer:Sprite = new Sprite();

		private var areaNamesLayer:Sprite = new Sprite();

		private var mapLinesLayer:Sprite = new Sprite();

		private var backLayer:Sprite = new Sprite();

		private var _backMaskRec:Rectangle = null;

		private var _areaNameViewHV:HashVector = new HashVector();

		private var _currentPositionAreaView:AreaNameView;

		public function MapView() {
			super();
		}

		/**
		 *
		 */
		private static var defaultStyles:Object = {backSkin: "Map_backskin"};

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

			mapLinesLayer.mouseChildren = false;
			mapLinesLayer.mouseEnabled = false;
			mapLinesLayer.buttonMode = false;

			this.invalidate(InvalidationType.ALL, true);
			this.invalidate(InvalidationType.SIZE, true);
			super.configUI();
		}

		/**
		 *
		 *
		 */
		override protected function draw():void {

			PointUtil.deleteAllChild(this);
			PointUtil.deleteAllChild(backLayer);
			PointUtil.deleteAllChild(areaBtnsLayer);
			PointUtil.deleteAllChild(areaNamesLayer);
			PointUtil.deleteAllChild(mapLinesLayer);

			this.addChild(backLayer);
			this.addChild(areaBtnsLayer);
			this.addChild(mapLinesLayer);
			this.addChild(areaNamesLayer);

			var wsdo:WorkSpaceDO = this.workSpaceDO;
			if (wsdo != null) {
				var madohv:Vector.<MapAreaDO> = wsdo.mapAreaDOs;

				for (var i:int = 0; i < madohv.length; i++) {
					var mado:MapAreaDO = madohv[i];
					if (mado != null) {

						var av:AreaView = new AreaView();
						av.mapAreaDO = mado;
						av.drawNow();
						areaBtnsLayer.addChild(av);

						var anv:AreaNameView = new AreaNameView();
						anv.mapAreaDO = mado;
						anv.drawNow();
						av.areaNameView = anv;
						anv.areaView = av;
						areaNamesLayer.addChild(anv);
						areaNameViewHV.push(anv, mado.areaCode);
						anv.doubleClickEnabled = true;
						anv.addEventListener(MouseEvent.MOUSE_OVER, handlerAreaNameViewMouseOver);
						anv.addEventListener(MouseEvent.MOUSE_OUT, handlerAreaNameViewMouseOut);
						anv.addEventListener(MouseEvent.CLICK, handlerAreaViewClick);
						anv.addEventListener(MouseEvent.DOUBLE_CLICK, handlerAreaViewDoubleClick);

						if (mado.isCurrent) {
							_currentPositionAreaView = anv;
						}
					}
				}

				var maplinesSprite:Sprite = this.drawMapLines(wsdo);
				var dsFilter:DropShadowFilter = new DropShadowFilter(0, 0, 0x000000, 1, 4, 4);
				var filterAry:Array = new Array();
				filterAry.push(dsFilter);
				maplinesSprite.filters = filterAry;
				this.mapLinesLayer.addChild(maplinesSprite);

				var backMask:Sprite = this.drawBackMask(wsdo);
				this.backLayer.addChild(backMask);

				_backMaskRec = backMask.getRect(this.backLayer);
				var sizep:Point = new Point(_backMaskRec.width, _backMaskRec.height);
				var placep:Point = new Point(_backMaskRec.x, _backMaskRec.y);

				var back:DisplayObject = getDisplayObjectInstance(getStyleValue("backSkin"));
				back.mask = backMask;
				PointUtil.setSpriteSize(back, sizep);
				PointUtil.setSpritePlace(back, placep);
				this.backLayer.addChild(back);
			}
			else {
				trace("WorkSpaceDO:" + WorkSpaceDO);
			}
		}

		/**
		 *
		 * @param workSpaceDO
		 * @return
		 *
		 */
		private function drawBackMask(workSpaceDO:WorkSpaceDO):Sprite {
			if (workSpaceDO != null) {
				var sprite:Sprite = new Sprite();
				var madohv:Vector.<MapAreaDO> = workSpaceDO.mapAreaDOs;
				for (var i:int = 0; i < madohv.length; i++) {
					var mado:MapAreaDO = madohv[i];
					var ary:Array = mado.pointArray.toArray();
					var shape:Shape = MapViewDraw.drawFill(0xffffff, 1, ary);
					sprite.addChild(shape);
				}
				return sprite;
			}
			return null;
		}

		private function drawMapLines(workSpaceDO:WorkSpaceDO):Sprite {
			if (workSpaceDO != null) {
				var sprite:Sprite = new Sprite();
				var madohv:Vector.<MapAreaDO> = workSpaceDO.mapAreaDOs;
				for (var i:int = 0; i < madohv.length; i++) {
					var mado:MapAreaDO = madohv[i];
					var ary:Array = mado.pointArray.toArray();
					var shape:Shape = MapViewDraw.drawCloseLines(0xffffff, ary);
					sprite.addChild(shape);
				}
				return sprite;
			}
			return null;
		}

		private function handlerAreaViewClick(e:Event):void {
			var av:AreaNameView = e.currentTarget as AreaNameView;
			this._currentAreaView = av;
			this.dispatchEvent(new Event(AREA_CLICK_EVENT));
		}

		/**
		 *
		 * @param e
		 *
		 */
		private function handlerAreaViewDoubleClick(e:Event):void {
			var av:AreaNameView = e.currentTarget as AreaNameView;
			this._currentAreaView = av;
			this.dispatchEvent(new Event(AREA_DOUBLE_CLICK_EVENT));
		}

		/**
		 * 事件
		 * @param e
		 *
		 */
		private function handlerAreaNameViewMouseOver(e:Event):void {
			var av:AreaNameView = e.currentTarget as AreaNameView;
			this._currentAreaView = av;
			this.dispatchEvent(new Event(AREA_MOUSE_OVER_EVENT));
		}

		/**
		 * 事件
		 * @param e
		 *
		 */
		private function handlerAreaNameViewMouseOut(e:Event):void {
			var av:AreaNameView = e.currentTarget as AreaNameView;
			this._currentAreaView = av;
			this.dispatchEvent(new Event(AREA_MOUSE_OUT_EVENT));
		}

		public function get workSpaceDO():WorkSpaceDO {
			return _workSpaceDO;
		}

		public function set workSpaceDO(value:WorkSpaceDO):void {
			_workSpaceDO = value;
		}

		public function get currentAreaView():AreaNameView {
			return _currentAreaView;
		}

		public function get areaNameViewHV():HashVector {
			return _areaNameViewHV;
		}

		public function get currentPositionAreaView():AreaNameView
		{
			return _currentPositionAreaView;
		}


	}
}
