package com.snsoft.mapview {
	import com.snsoft.mapview.CuntryName;
	import com.snsoft.mapview.dataObj.MapAreaDO;
	import com.snsoft.mapview.util.MapViewDraw;
	import com.snsoft.util.ColorTransformUtil;
	import com.snsoft.util.PointUtil;

	import fl.core.InvalidationType;
	import fl.core.UIComponent;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class AreaView extends UIComponent {

		private var _mapAreaDO:MapAreaDO=null;

		private var _areaBtnLayer:Sprite=new Sprite();

		private var _areaNameLayer:Sprite=new Sprite();

		private var _areaNameView:AreaNameView;

		/**
		 *
		 *
		 */
		public function AreaView() {
			super();
		}

		/**
		 *
		 *
		 */
		override protected function configUI():void {

			this.setMouseOutColor();
			this.buttonMode=true;
			this.mouseChildren=false;
			this.mouseEnabled=true;

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
			PointUtil.deleteAllChild(areaBtnLayer);
			PointUtil.deleteAllChild(areaNameLayer);
			this.addChild(areaBtnLayer);
			this.addChild(areaNameLayer);

			var mado:MapAreaDO=this.mapAreaDO;
			if (mado != null) {
				var pointAry:Array=mado.pointArray.toArray();
				var cl:Shape=MapViewDraw.drawFill(0x000000, 1, pointAry);
				areaBtnLayer.addChild(cl);

				this.addEventListener(MouseEvent.MOUSE_OVER, handlerAreaViewMouseOver);
				this.addEventListener(MouseEvent.MOUSE_OUT, handlerAreaViewMouseOut);
			} else {
				trace("mapAreaDO:" + mapAreaDO);
			}
		}

		public function setMouseOverColor():void {
			ColorTransformUtil.setColor(this.areaBtnLayer, 0xbb0000, 1);
		}

		public function setMouseOutColor():void {
			ColorTransformUtil.setColor(this.areaBtnLayer, 0xbb0000, 0);
		}

		/**
		 * 事件
		 * @param e
		 *
		 */
		private function handlerAreaViewMouseOver(e:Event):void {
			this.setMouseOverColor();
		}

		/**
		 * 事件
		 * @param e
		 *
		 */
		private function handlerAreaViewMouseOut(e:Event):void {
			this.setMouseOutColor();
		}

		public function get mapAreaDO():MapAreaDO {
			return _mapAreaDO;
		}

		public function set mapAreaDO(value:MapAreaDO):void {
			_mapAreaDO=value;
		}

		public function get areaBtnLayer():Sprite {
			return _areaBtnLayer;
		}

		public function get areaNameLayer():Sprite {
			return _areaNameLayer;
		}

		public function get areaNameView():AreaNameView {
			return _areaNameView;
		}

		public function set areaNameView(value:AreaNameView):void {
			_areaNameView=value;
		}


	}
}