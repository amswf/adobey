package com.snsoft.physics{
	
	/**
	 * 二维力 
	 * @author Administrator
	 * 
	 */	
	public class Resistance{
		
		private var _angle:Number;
		
		private var _value:Number;
		
		public function Resistance(value:Number,angle:Number){
			this.angle = angle;
			this.value = value;
		}
		
		public function plus(rstc:Resistance):Resistance{
			var f1:Number = this.value;
			var f2:Number = rstc.value;
			var pi180:Number = Math.PI / 180;
			var ag:Number = rstc.angle - this.angle;
			while(ag > 360){
				ag -= 360;
			}
			while(ag < 0){
				ag += 360;
			}
			var sAngle:Number = ag * pi180;
			if(sAngle > 360){
				sAngle -= 360;
			}
			if(sAngle < 0){
				sAngle += 360;
			}
			var value:Number = Math.sqrt(f1 * f1 + f2 * f2 + 2 * f1 * f2 * (Math.cos(sAngle)));
			var angle:Number = Math.atan2(f2 * Math.sin(sAngle),f1 + f2 * Math.cos(sAngle)) / pi180 + this.angle;
			return new Resistance(value,angle);
		}
		
		public function get angle():Number
		{
			return _angle;
		}
		
		public function set angle(value:Number):void
		{
			_angle = value;
		}
		
		public function get value():Number
		{
			return _value;
		}
		
		public function set value(value:Number):void
		{
			_value = value;
		}
		
		
	}
}