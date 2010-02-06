package com.snsoft.map
{
	import com.snsoft.util.SkinsUtil;
	
	import flash.display.MovieClip;
	
	
	/**
	 * 画笔 
	 * @author Administrator
	 * 
	 */	
	public class Pen extends MapComponent
	{
		
		
		//闭合时皮肤
		public static const PEN_LINE_CLOSE_SKIN:String = "PenLineCloseSkin";
		
		//不能画点时皮肤
		public static const PEN_LINE_UNABLE_SKIN:String = "PenLineUnableSkin";
		
		//画笔遇到已存在点时，皮夫MC的类名。
		public static const PEN_LINE_POINT_SKIN:String = "PenLinePointSkin";
		
		//画笔默认，皮夫MC的类名。
		public static const PEN_LINE_DEFAULT_SKIN:String = "PenLineDefaultSkin";
		
		//选择工具默认皮肤。
		public static const PEN_SELECT_DEFAULT_SKIN:String = "PenSelectDefaultSkin";
		
		//画笔状态：起始
		public static const PEN_STATE_START:int = 0;
		
		//画笔状态：正在画
		public static const PEN_STATE_DOING:int = 1;
		
		//画笔皮肤
		private var _penSkin:String = PEN_LINE_DEFAULT_SKIN;
		
		//画笔状态
		private var _penState:int = PEN_STATE_START;
		
		public function Pen(penState:int = 0 ,penSkin:String = "PenLineSkin")
		{
			super();
			this.mouseEnabled = false;
			this.buttonMode = false;
			this.mouseChildren = false;
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