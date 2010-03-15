package com.snsoft.map
{
	import com.snsoft.util.SpriteMouseAction;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
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
		
		//缩放系数
		private var _scalePoint:Point = new Point(1,1);
		
		//画区域的点列表的数组，一个图形可有多个点围成，但可以是多个点组成的链组成。
		private var _mapAreaDO:MapAreaDO = null;
		
		//显示名称
		private var cuntryName:CuntryName = new CuntryName();
		
		//显示名称移动时初始鼠标位置
		private var cuntryNameMousePoint:Point = new Point();
		
		//显示名称是否可拖动标记
		private var cuntryNameMoveSign:Boolean = false;
		
		//地图块图形
		private var areaFillShape:Shape;
		
		//地图块的子地图块所在的工作区
		private var _childWorkSpace:WorkSpace = null;
		
		public static const CUNTRY_NAME_MOVE_EVENT:String = "CUNTRY_NAME_MOVE_EVENT";
		
		public function MapArea(mapAreaDO:MapAreaDO,lineColor:uint,fillColor:uint,scalePoint:Point = null)
		{
			this.mapAreaDO = mapAreaDO;
			this.lineColor = lineColor;
			this.fillColor = fillColor;
			this.buttonMode = true;
			if(scalePoint != null){
				this.scalePoint = scalePoint;
			}
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
			areaFillShape = MapDraw.drawFill(paa,this.lineColor,this.fillColor,0,this.scalePoint);
			this.addChild(areaFillShape);
			
			if(paa != null){
				for(var i:int = 0;i<paa.length;i++){
					var pa:Array = paa[i] as Array;
					if(pa != null){
						var foldLine:Sprite = MapDraw.drawCloseFoldLine(pa,this.lineColor,this.fillColor,0,2,this.scalePoint);
						foldLine.mouseEnabled = false;
						foldLine.buttonMode = false;
						foldLine.mouseChildren = false;
						this.addChild(foldLine);
					}
				}
			}
			
			var dobj:Rectangle = areaFillShape.getRect(this);			
			var cn:CuntryName = this.cuntryName;
			cn.lableText = mado.areaName;
			cn.x = (dobj.width - cn.width)/2 + dobj.x + this.mapAreaDO.areaNamePlace.x;
			cn.y = (dobj.height - cn.height)/2 + dobj.y + this.mapAreaDO.areaNamePlace.y;
			cn.mouseEnabled = true;
			cn.buttonMode = true;
			cn.mouseChildren = false;
			this.addChild(cn);
			
			var sma:SpriteMouseAction = new SpriteMouseAction();
			sma.addMouseDragEvents(cn);
			sma.addEventListener(SpriteMouseAction.DRAG_COMPLETE_EVENT,dragCmp);
			 
		}
		
		/**
		 * 拖动完成 事件  DRAG_COMPLETE_EVENT
		 * @param e
		 * 
		 */		
		private function dragCmp(e:Event):void{
			this.cuntryNameMoveSign = false;
			var mado:MapAreaDO = this.mapAreaDO;
			var cn:CuntryName = this.cuntryName;
			var dobj:Rectangle = areaFillShape.getRect(this);			
			var px:Number = cn.x - (dobj.width - cn.width)/2 - dobj.x;
			var py:Number = cn.y - (dobj.height - cn.height)/2 - dobj.y;
			mado.areaNamePlace = new Point(px,py);
			this.dispatchEvent(new Event(CUNTRY_NAME_MOVE_EVENT));
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

		public function get scalePoint():Point
		{
			return _scalePoint;
		}

		public function set scalePoint(value:Point):void
		{
			_scalePoint = value;
		}

		public function get childWorkSpace():WorkSpace
		{
			return _childWorkSpace;
		}

		public function set childWorkSpace(value:WorkSpace):void
		{
			_childWorkSpace = value;
		}

		
	}
}