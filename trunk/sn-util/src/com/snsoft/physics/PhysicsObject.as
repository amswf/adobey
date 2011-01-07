package com.snsoft.physics{
	import com.snsoft.util.HashVector;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class PhysicsObject extends Sprite{
		
		private var _m:Number; 
		
		private var _vx:Number = 0;
		
		private var _vy:Number = 0;
		
		private var _ahv:HashVector = new HashVector();
		
		public function PhysicsObject(dobj:DisplayObject){
			this.addChild(dobj);
			super();
		}

		/**
		 * 质量 
		 */
		public function get m():Number
		{
			return _m;
		}

		/**
		 * @private
		 */
		public function set m(value:Number):void
		{
			_m = value;
		}

		public function get vx():Number
		{
			return _vx;
		}

		public function set vx(value:Number):void
		{
			_vx = value;
		}

		public function get vy():Number
		{
			return _vy;
		}

		public function set vy(value:Number):void
		{
			_vy = value;
		}
		
		public function pushAcce(acce:Acceleration,name:String = null):void{
			this._ahv.push(acce,name);
		}
		
		public function delAcce(name:String = null):void{
			this._ahv.removeByName(name);
		}
		
		public function getAcceByIndex(i:int):Acceleration{
			return this._ahv.findByIndex(i) as Acceleration;
		}
		
		public function acceLen():int{
			return this._ahv.length;
		}
	}
}