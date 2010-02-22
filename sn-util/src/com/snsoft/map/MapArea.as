package com.snsoft.map
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	
	
	/**
	 * 画区域 
	 * @author Administrator
	 * 
	 */	
	public class MapArea extends MapComponent
	{
		
		//线色
		private var _lineColor:uint = 0x000000;
		
		//填充色
		private var _fillColor:uint = 0x000000;
		
		//画区域的点列表的数组，一个图形可有多个点围成，但可以是多个点组成的链组成。
		private var _mapAreaDO:MapAreaDO = null;
		
		//显示名称
		private var cuntryName:CuntryName = new CuntryName();
		
		public function MapArea(mapAreaDO:MapAreaDO,lineColor:uint,fillColor:uint)
		{
			this.mapAreaDO = mapAreaDO;
			this.lineColor = lineColor;
			this.fillColor = fillColor;
			this.buttonMode = true;
			super();
		}
		
		/**
		 * 画图并添加到当MC中 
		 * 
		 */		
		override protected function draw():void{
			var mado:MapAreaDO = this.mapAreaDO;
			var paa:Array = new Array();
			paa.push(mado.pointArray.getArray());
			var fill:Shape = MapDraw.drawFill(paa,this.lineColor,this.fillColor);
			this.addChild(fill);
			
			var dobj:Rectangle = fill.getRect(this);			
			var cn:CuntryName = this.cuntryName;
			cn.x = (dobj.width - cn.width)/2 + dobj.x + this.mapAreaDO.areaNamePlace.x;
			cn.y = (dobj.height - cn.height)/2 + dobj.y + this.mapAreaDO.areaNamePlace.y;
			cn.mouseEnabled = false;
			cn.buttonMode = false;
			cn.mouseChildren = false;
			cn.lableText = mado.areaName;
			this.addChild(cn);
			
			if(paa != null){
				for(var i:int = 0;i<paa.length;i++){
					var pa:Array = paa[i] as Array;
					if(pa != null){
						var foldLine:Sprite = MapDraw.drawCloseFoldLine(pa,this.lineColor,this.fillColor);
						foldLine.mouseEnabled = false;
						foldLine.buttonMode = false;
						foldLine.mouseChildren = false;
						this.addChild(foldLine);
					}
				}
			}
		}

		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get fillColor():uint
		{
			return _fillColor;
		}

		/**
		 * 
		 * @param value
		 * 
		 */		
		public function set fillColor(value:uint):void
		{
			_fillColor = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get lineColor():uint
		{
			return _lineColor;
		}

		/**
		 * 
		 * @param value
		 * 
		 */		
		public function set lineColor(value:uint):void
		{
			_lineColor = value;
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