package com.snsoft.particle{
	public class FireWorksLinkObject{
		
		private var _particle:Particle;
		
		private var _maxHeight:Number;
		
		public function FireWorksLinkObject(particle:Particle,maxHeight:Number){
			this.particle = particle;
			this.maxHeight = maxHeight;
		}

		public function get particle():Particle
		{
			return _particle;
		}

		public function set particle(value:Particle):void
		{
			_particle = value;
		}

		public function get maxHeight():Number
		{
			return _maxHeight;
		}

		public function set maxHeight(value:Number):void
		{
			_maxHeight = value;
		}


	}
}