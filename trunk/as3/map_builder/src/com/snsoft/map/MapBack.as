package com.snsoft.map
{
	import com.snsoft.util.SkinsUtil;
	
	import flash.display.MovieClip;

	/**
	 * 背影MC 
	 * @author Administrator
	 * 
	 */	
	public class MapBack extends MapComponent
	{
		//边框
		private var MAIN_FRAME_SKIN:String = "BaseBack";
		
		public function MapBack()
		{
			super();
		}
		
		/**
		 * 画图并添加到当MC中 
		 * 
		 */		
		override protected function draw():void {
			var skin:MovieClip = SkinsUtil.createSkinByName(MAIN_FRAME_SKIN);
			skin.width = this.width;
			skin.height = this.height;
			this.addChild(skin);
		}
	}
}