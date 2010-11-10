package com.snsoft.sndoor{
	import com.snsoft.util.TextFieldUtil;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class MenuIBtn extends UIComponent{
		
		
		
		
		/**
		 * 响应鼠标事件的透明框 
		 */		
		private var btnTop:MovieClip;
		
		/**
		 * 鼠标移上后显示的背景 
		 */		
		private var menuIMouseOver:MovieClip;
		
		/**
		 * 鼠标移上，下拉指示箭头
		 */		
		private var menuIPollTriangleMouseOut:MovieClip;
		
		/**
		 * 鼠标移出，下拉指示箭头 
		 */		
		private var menuIPollTriangleMouseOver:MovieClip;
		
		private var text:String;
		
		private var _hasChildPoll:Boolean
		
		private var textFiled:TextField;
		
		
		public function MenuIBtn(text:String,hasChildPoll:Boolean = false){
			super();
			this.text = text;
			this._hasChildPoll = hasChildPoll;
			
			btnTop = getDisplayObjectInstance(getStyleValue(btnTopSkin)) as MovieClip;
			menuIMouseOver = getDisplayObjectInstance(getStyleValue(menuIMouseOverDefaultSkin)) as MovieClip;
			menuIPollTriangleMouseOut = getDisplayObjectInstance(getStyleValue(menuIPollTriangleMouseOutDefaultSkin)) as MovieClip;
			menuIPollTriangleMouseOver = getDisplayObjectInstance(getStyleValue(menuIPollTriangleMouseOverDefaultSkin)) as MovieClip;
			
			textFiled = new TextField();
			textFiled.htmlText = "<b>"+this.text+"</b>";
			textFiled.x = 30;
			textFiled.y = 10;
			textFiled.setTextFormat(getStyleValue(textDefaultTextFormat) as TextFormat);
			textFiled.width = TextFieldUtil.calculateBoldWidth(textFiled);
			textFiled.height = int((getStyleValue(textDefaultTextFormat)as TextFormat).size) + 6;
			
			menuIMouseOver.width = textFiled.width + 30 + 30;
			menuIMouseOver.visible = false;
			
			this.width = menuIMouseOver.width;
			this.height = menuIMouseOver.height;
			
			btnTop.width = menuIMouseOver.width;
			btnTop.height = menuIMouseOver.height;
			btnTop.mouseEnabled = true;
			btnTop.buttonMode = true;
			btnTop.addEventListener(MouseEvent.MOUSE_OVER,handlerMouseOver);
			btnTop.addEventListener(MouseEvent.MOUSE_OUT,handlerMouseOut);
			
			menuIPollTriangleMouseOut.x = textFiled.getRect(this).right + 5;
			menuIPollTriangleMouseOut.y = 18;
			if(!hasChildPoll ){
				menuIPollTriangleMouseOut.visible = false;
			}
			
			menuIPollTriangleMouseOver.x = textFiled.getRect(this).right + 5;
			menuIPollTriangleMouseOver.y = 18;
			menuIPollTriangleMouseOver.visible = false;

		}
		
		/**
		 * 
		 */			
		private static var defaultStyles:Object = {
			btnTopSkin:"BtnTop_skin",
			menuIMouseOverDefaultSkin:"MenuIMouseOver_defaultSkin",
			menuIPollTriangleMouseOutDefaultSkin:"MenuIPollTriangleMouseOut_defaultSkin",
			menuIPollTriangleMouseOverDefaultSkin:"MenuIPollTriangleMouseOver_defaultSkin",
			textDefaultTextFormat:new TextFormat("",14,0xffffff),
			textMouseOverTextFormat:new TextFormat("",14,0x6F787F)
		};
		
		/**
		 * 样式 
		 */		
		private static const btnTopSkin:String = "btnTopSkin";
		
		private static const menuIMouseOverDefaultSkin:String = "menuIMouseOverDefaultSkin";
		
		private static const menuIPollTriangleMouseOutDefaultSkin:String = "menuIPollTriangleMouseOutDefaultSkin";
		
		private static const menuIPollTriangleMouseOverDefaultSkin:String = "menuIPollTriangleMouseOverDefaultSkin";
		
		private static const textDefaultTextFormat:String = "textDefaultTextFormat";
		
		private static const textMouseOverTextFormat:String = "textMouseOverTextFormat";
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public static function getStyleDefinition():Object { 
			return UIComponent.mergeStyles(UIComponent.getStyleDefinition(), defaultStyles);
		}	
		
		/**
		 *  
		 * 
		 */				
		override protected function configUI():void{			
			this.invalidate(InvalidationType.ALL,true);
			this.invalidate(InvalidationType.SIZE,true);
			super.configUI();
		}
		
		/**
		 * 
		 * 绘制组件显示
		 */		
		override protected function draw():void{
			
			
			this.addChild(menuIMouseOver);
			this.addChild(menuIPollTriangleMouseOver);
			this.addChild(menuIPollTriangleMouseOut);
			this.addChild(textFiled);
			textFiled.setTextFormat(getStyleValue(textDefaultTextFormat) as TextFormat);
			this.addChild(btnTop);
			
		}
		
		private function handlerMouseOver(e:Event):void{
			menuIMouseOver.visible = true;
			if(hasChildPoll ){
				menuIPollTriangleMouseOut.visible = false;
				menuIPollTriangleMouseOver.visible = true;
			}
			textFiled.setTextFormat(getStyleValue(textMouseOverTextFormat) as TextFormat);
		}
		
		private function handlerMouseOut(e:Event):void{
			menuIMouseOver.visible = false;
			if(hasChildPoll ){
				menuIPollTriangleMouseOut.visible = true;
				menuIPollTriangleMouseOver.visible = false;
			}
			textFiled.setTextFormat(getStyleValue(textDefaultTextFormat) as TextFormat);
		}

		public function get hasChildPoll():Boolean
		{
			return _hasChildPoll;
		}

		
	}
}