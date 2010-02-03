package com.snsoft.map
{
	import com.snsoft.util.SkinsUtil;
	
	import flash.display.MovieClip;
	
	
	/**
	 * 画笔 
	 * @author Administrator
	 * 
	 */	
	public class Pen extends MapMovieClip
	{
		
		//画笔遇到已存在点时，皮夫MC的类名。
		private static var PEN_SKIN_LINE_POINT:String = "PenLinePointSkin";
		
		//画笔默认，皮夫MC的类名。
		private static var PEN_SKIN_DEFAULT:String = "PenLineSkin";
		
		//画笔状态：起始
		private static var PEN_STATE_START:int = 0;
		
		//画笔状态：正在画
		private static var PEN_STATE_DOING:int = 1;
		
		//画笔皮肤
		private var _penSkin:String = PEN_SKIN_DEFAULT;
		
		//画笔状态
		private var _penState:int = PEN_STATE_START;
		
		
		public function Pen(penState:int = 0 ,penSkin:String = "PenLineSkin")
		{
			super();
		}
		
		override protected function draw():void
		{
			var skin:MovieClip = SkinsUtil.createSkinByName(this.penSkin);
			this.addChild(skin);
		}

		public function get penSkin():String
		{
			return _penSkin;
		}

		public function set penSkin(value:String):void
		{
			_penSkin = value;
		}

		public function get penState():int
		{
			return _penState;
		}

		public function set penState(value:int):void
		{
			_penState = value;
		}


	}
}