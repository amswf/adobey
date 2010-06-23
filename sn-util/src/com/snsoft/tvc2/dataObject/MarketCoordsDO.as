package com.snsoft.tvc2.dataObject{
	import ascb.util.StringUtilities;
	
	import com.snsoft.util.HashVector;
	
	import flash.display.DisplayObject;

	public class MarketCoordsDO{
		
		private var _name:String;
		
		private var _value:String;
		
		private var _text:String;
		
		private var _x:Number;
		
		private var _y:Number;
		
		private var _z:Number;
		
		private var _s:Number;
		
		private var _marketCoordDOHV:HashVector;
		
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