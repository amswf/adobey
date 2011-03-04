package com.snsoft.room3d{
	import com.snsoft.util.RectangleUtil;
	import com.snsoft.util.TextFieldUtil;
	import com.snsoft.util.text.Text;
	
	import fl.controls.Button;
	import fl.controls.TextArea;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class IntroMsg extends UIComponent{
		
		public static const BUTTON_CLICK:String = "BUTTON_CLICK";
		
		/**
		 * 是否绘制过
		 */		
		private var isDraw:Boolean = false;
		
		/**
		 * 文本样式 
		 */		
		public static const TEXT_FORMAT:String = "myTextFormat";
		
		/**
		 * 文本样式 
		 */		
		public static const BTN_TEXT_FORMAT:String = "btnTextFormat";
		
		
		/**
		 * 边框背景样式 
		 */		
		public static const WINDOW_MSG_BACK_DEFAULT_SKIN:String = "windowMsgBackDefaultSkin";
		
		/**
		 * 背景按钮
		 */		
		private var back:MovieClip;
		
		/**
		 * 窗口名称 
		 */		
		private var titleText:TextField;
		
		/**
		 * 关闭按钮 
		 */		
		private var clickBtn:Button;
		
		/**
		 * 标题文字 
		 */		
		private var title:String;
		
		
		
		
		public function IntroMsg(title:String)
		{
			super();
			this.title = title;
		}
		
		/**
		 * 
		 */			
		private static var defaultStyles:Object = {
			myTextFormat:new TextFormat("宋体",16,0x19C3F7),
			btnTextFormat:new TextFormat("宋体",14,0x0563A1),
			windowMsgBackDefaultSkin:"WindowMsgBack_defaultSkin"
		};
		
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
		 * 
		 */		
		override protected function draw():void{
			if(!isDraw){
				isDraw = true;
				
				var space:Number = 10;
				var btnRect:Rectangle =new Rectangle(0,0,40,22);
				
				this.height = btnRect.height + space * 2;
				
				back = getDisplayObjectInstance(getStyleValue(WINDOW_MSG_BACK_DEFAULT_SKIN)) as MovieClip;
				RectangleUtil.setRect(back,new Rectangle(0,0,this.width,this.height));
				this.addChild(back);
				
				clickBtn = new Button();
				clickBtn.label = "详细";
				RectangleUtil.setRect(clickBtn,new Rectangle(this.width - space - btnRect.width,space,btnRect.width,btnRect.height));
				clickBtn.setStyle("textFormat",this.getStyleValue(BTN_TEXT_FORMAT) as TextFormat);
				this.addChild(clickBtn);
				clickBtn.drawNow();
				clickBtn.addEventListener(MouseEvent.CLICK,handlerCloseBtnClick);
				
				 
				titleText = new TextField();
				titleText.setTextFormat(this.getStyleValue(TEXT_FORMAT) as TextFormat);
				RectangleUtil.setRect(titleText,new Rectangle(space,space,this.width - space * 3 - btnRect.width,btnRect.height));
				TextFieldUtil.fitText(titleText);
				this.addChild(titleText);
				titleText.mouseEnabled = false;
			}
		}
		
		public function refreshText(title:String):void{
			if(titleText != null){
				if(title == null){
					title = "";
				}
				titleText.text = title;
				TextFieldUtil.fitText(titleText);
				titleText.setTextFormat(this.getStyleValue(TEXT_FORMAT) as TextFormat);
			}
		}
		
		private function handlerCloseBtnClick(e:Event):void{
			this.dispatchEvent(new Event(BUTTON_CLICK));
		}
	}
}