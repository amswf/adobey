package com.snsoft.mapview{
	import com.snsoft.mapview.CuntryName;
	import com.snsoft.mapview.dataObj.MapAreaDO;
	import com.snsoft.util.PointUtil;
	import com.snsoft.mapview.util.MapViewDraw;
	import com.snsoft.util.ColorTransformUtil;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class AreaView extends UIComponent{
		
		private var _mapAreaDO:MapAreaDO = null;
		
		private var _areaBtnLayer:Sprite = new Sprite();
		
		private var _areaNameLayer:Sprite = new Sprite();
		
		private var cuntryName:CuntryName = new CuntryName("");
		
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
			
			this.setMouseOutColor();
			this.buttonMode = true;
			this.mouseChildren = false;
			this.mouseEnabled = true;
			
			this.invalidate(InvalidationType.ALL,true);
			this.invalidate(InvalidationType.SIZE,true);
			super.configUI();
		}
		
		/**
		 * 
		 * 
		 */		
		override protected function draw():void{
			PointUtil.deleteAllChild(this);
			PointUtil.deleteAllChild(areaBtnLayer);
			PointUtil.deleteAllChild(areaNameLayer);
			this.addChild(areaBtnLayer);
			this.addChild(areaNameLayer);
			
			var mado:MapAreaDO = this.mapAreaDO;
			if(mado != null){
				var pointAry:Array = mado.pointArray.toArray();
				var cl:Shape = MapViewDraw.drawFill(0xffffff,0x000000,1,1,pointAry);
				areaBtnLayer.addChild(cl);
				
				var dobj:Rectangle = cl.getRect(this);
				var cn:CuntryName = this.cuntryName;
				cn.lableText = mado.areaName;
				cn.x =dobj.x + (dobj.width - cn.width) * 0.5 + mado.areaNamePlace.x;
				cn.y =dobj.y + (dobj.height - cn.height) * 0.5 + mado.areaNamePlace.y;
				areaNameLayer.addChild(cn);
				this.addEventListener(MouseEvent.MOUSE_OVER,handlerAreaViewMouseOver);
				this.addEventListener(MouseEvent.MOUSE_OUT,handlerAreaViewMouseOut);
			}
			else{
				trace("mapAreaDO:"+mapAreaDO);
			}
		}
		
		private function setMouseOverColor():void{
			ColorTransformUtil.setColor(this.areaBtnLayer,0xbb0000);
			ColorTransformUtil.setColor(this.areaNameLayer,0xbb0000);
		}
		
		private function setMouseOutColor():void{
			ColorTransformUtil.setColor(this.areaBtnLayer,0xbb0000,0);
			ColorTransformUtil.setColor(this.areaNameLayer,0x000000);
		}
		
		/**
		 * 事件 
		 * @param e
		 * 
		 */		
		private function handlerAreaViewMouseOver(e:Event):void{
			 this.setMouseOverColor();
		}
		
		/**
		 * 事件 
		 * @param e
		 * 
		 */		
		private function handlerAreaViewMouseOut(e:Event):void{
			 this.setMouseOutColor();
		}
		
		public function get mapAreaDO():MapAreaDO
		{
			return _mapAreaDO;
		}

		public function set mapAreaDO(value:MapAreaDO):void
		{
			_mapAreaDO = value;
		}

		public function get areaBtnLayer():Sprite
		{
			return _areaBtnLayer;
		}

		public function get areaNameLayer():Sprite
		{
			return _areaNameLayer;
		}


	}
}