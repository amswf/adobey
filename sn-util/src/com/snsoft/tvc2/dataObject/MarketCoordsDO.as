package com.snsoft.tvc2.dataObject{
	import ascb.util.StringUtilities;
	
	import com.snsoft.util.HashVector;
	
	import flash.display.DisplayObject;

	/**
	 * 市场信息组 
	 * @author Administrator
	 * 
	 */	
	public class MarketCoordsDO{
		
		//名称
		private var _name:String;
		
		//值
		private var _value:String;
		
		//文本
		private var _text:String;
		
		//显示坐标 X
		private var _x:Number;
		
		//显示坐标 Y
		private var _y:Number;
		
		//显示坐标 Z
		private var _z:Number;
		
		//缩放比率
		private var _s:Number;
		
		//市场信息单元列表
		private var _marketCoordDOHV:HashVector;
		
		//市场背景地图图片列表
		private var _imageList:Vector.<DisplayObject>;
		
		public function MarketCoordsDO()
		{
		}
		
		public function putMarketCoordDO(marketCoordDO:MarketCoordDO):void{
			if(marketCoordDO != null){
				var name:String = marketCoordDO.name;
				if(name != null && StringUtilities.trim(name).length > 0){
					marketCoordDOHV.put(name,marketCoordDO);
				}
			}
		}
		
		public function findMarketCoordDO(marketCoordName:String):MarketCoordDO{
			return marketCoordDOHV.findByName(marketCoordName) as MarketCoordDO;
		}
		
		public function getRealCoordMarketCoordDO(marketCoordName:String):MarketCoordDO{
			var mcdo:MarketCoordDO = findMarketCoordDO(marketCoordName);
			if(mcdo != null){
				mcdo.x = (mcdo.x - this.x) * this.s;
				mcdo.y = (mcdo.y - this.y) * this.s;
			}
			return mcdo;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get value():String
		{
			return _value;
		}

		public function set value(value:String):void
		{
			_value = value;
		}

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text = value;
		}

		public function get x():Number
		{
			return _x;
		}

		public function set x(value:Number):void
		{
			_x = value;
		}

		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			_y = value;
		}

		public function get z():Number
		{
			return _z;
		}

		public function set z(value:Number):void
		{
			_z = value;
		}

		public function get s():Number
		{
			return _s;
		}

		public function set s(value:Number):void
		{
			_s = value;
		}

		public function get marketCoordDOHV():HashVector
		{
			return _marketCoordDOHV;
		}

		public function set marketCoordDOHV(value:HashVector):void
		{
			_marketCoordDOHV = value;
		}

		public function get imageList():Vector.<DisplayObject>
		{
			return _imageList;
		}

		public function set imageList(value:Vector.<DisplayObject>):void
		{
			_imageList = value;
		}


	}
}