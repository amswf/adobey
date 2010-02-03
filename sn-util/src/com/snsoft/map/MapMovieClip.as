package com.snsoft.map
{
	import flash.display.MovieClip;
	
	public class MapMovieClip extends MovieClip
	{
		public function MapMovieClip()
		{
			super();
		}
		
		public function refresh():void{
			this.deleteAllChildMC();
			this.draw();
		}
		
		/**
		 * 删除所有字MC 
		 * 
		 */		
		protected function deleteAllChildMC():void{
			while(this.numChildren >0){
				this.removeChildAt(0);
			}
		}
		
		/**
		 * 画图，需要重写此方法。 
		 * 
		 */		
		protected function draw():void{
			trace("MapMovieClip.draw");
		}
	}
}