package com.snsoft.map
{
	import com.snsoft.util.SkinsUtil;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ToolBtn extends MapComponent
	{
		//默人皮肤
		private var _defaultSkin:String = null;
		
		//鼠标移上皮肤
		private var _mouseOverSkin:String = null;
		
		//鼠标移出皮肤
		private var _mouseDownSkin:String = null;
		
		//事件类型
		private var _toolEventType:String = null;
		
		//当前皮肤
		private var skin:String = null;
		
		
		
		public function ToolBtn(defaultSkin:String,mouseOverSkin:String,mouseDownSkin:String,toolEventType:String)
		{
			this.mouseEnabled = true;
			this.buttonMode = true;
			
			this.defaultSkin = defaultSkin;
			this.mouseDownSkin = mouseDownSkin;
			this.mouseOverSkin = mouseOverSkin;
			this.toolEventType = toolEventType;
			
			this.skin = defaultSkin;
			
			this.addEventListener(MouseEvent.CLICK,handlerMouseClick);
			this.addEventListener(MouseEvent.MOUSE_OVER,handlerMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT,handlerMouseOut);
			
			super();
		}
		
		/**
		 * 
		 * 
		 */		
		public function putToDefaultSkin():void{
			this.skin = this.defaultSkin;
		}
		
		
		/**
		 * 事件 
		 * @param e
		 * 
		 */	
		private function handlerMouseClick(e:Event):void{
			//trace("click");
			if(this.mouseOverSkin != null && this.defaultSkin != null && this.mouseDownSkin !=null){
				if(this.skin != this.mouseDownSkin){
					this.skin = this.mouseDownSkin;
					this.refresh();
				}
			}
		}
		
		/**
		 * 事件 
		 * @param e
		 * 
		 */		
		private function handlerMouseOver(e:Event):void{
			//trace("over");
			if(this.mouseOverSkin != null && this.defaultSkin != null && this.mouseDownSkin !=null){
				if(this.skin != this.mouseDownSkin && this.skin != this.mouseOverSkin){
					this.skin = this.mouseOverSkin;
					this.refresh();
				}
			}
		}
		
		/**
		 * 事件 
		 * @param e
		 * 
		 */
		private function handlerMouseOut(e:Event):void{
			//trace("out");
			if(this.mouseOverSkin != null && this.defaultSkin != null && this.mouseDownSkin !=null){
				if(this.skin != this.mouseDownSkin && this.skin != this.defaultSkin){
					this.skin = this.defaultSkin;
					this.refresh();
				}
			}
		}
		
		
		
		/**
		 * 画图，需要重写此方法。 
		 * 
		 */		
		override protected function draw():void{
			if(this.skin != null){
				var mc:MovieClip = SkinsUtil.createSkinByName(this.skin);
				this.addChild(mc);
				this.width = mc.width;
				this.height = mc.height;
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
		
		public function get toolEventType():String
		{
			return _toolEventType;
		}
		
		public function set toolEventType(value:String):void
		{
			_toolEventType = value;
		}
	}
}