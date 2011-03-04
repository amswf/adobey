package com.snsoft.particle{
	public class FireWorksLinkObject{
		
		private var _particle:SparkParticle;
		
		private var _maxHeight:Number;
		
		public function FireWorksLinkObject(particle:SparkParticle,maxHeight:Number){
			this.particle = particle;
			this.maxHeight = maxHeight;
		}

		public function get particle():SparkParticle
		{
			return _particle;
		}

		public function set particle(value:SparkParticle):void
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