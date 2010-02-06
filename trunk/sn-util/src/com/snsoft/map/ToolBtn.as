package com.snsoft.map
{
	import com.snsoft.util.SkinsUtil;
	
	import flash.display.MovieClip;

	public class ToolBtn extends MapComponent
	{
		//默人皮肤
		private var _defaultSkin:String = null;
		
		//鼠标移上皮肤
		private var _mouseOverSkin:String = null;
		
		//鼠标移出皮肤
		private var _mouseDownSkin:String = null;
		
		//当前皮肤
		private var skin:String = null;
		
		public function ToolBtn(defaultSkin:String,mouseOverSkin:String,mouseDownSkin:String)
		{
			this.defaultSkin = defaultSkin;
			this.mouseDownSkin = mouseDownSkin;
			this.mouseOverSkin = mouseOverSkin;
			
			this.skin = defaultSkin;
			super();
		}
		
		/**
		 * 画图，需要重写此方法。 
		 * 
		 */		
		override protected function draw():void{
			if(this.skin != null){
				var mc:MovieClip = SkinsUtil.createSkinByName(this.skin);
				this.addChild(mc);
			}
		}
		
		public function get defaultSkin():String
		{
			return _defaultSkin;
		}

		public function set defaultSkin(value:String):void
		{
			_defaultSkin = value;
		}

		public function get mouseOverSkin():String
		{
			return _mouseOverSkin;
		}

		public function set mouseOverSkin(value:String):void
		{
			_mouseOverSkin = value;
		}

		public function get mouseDownSkin():String
		{
			return _mouseDownSkin;
		}

		public function set mouseDownSkin(value:String):void
		{
			_mouseDownSkin = value;
		}


	}
}