package com.snsoft.room3d{
	import com.snsoft.util.RectangleUtil;
	import com.snsoft.util.TextFieldUtil;
	import com.snsoft.util.text.Text;
	
	import fl.controls.Button;
	import fl.controls.TextArea;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class WindowMsg extends UIComponent{
		
		/**
		 * 是否绘制过
		 */		
		private var isDraw:Boolean = false;
		
		/**
		 * 文本样式 
		 */		
		public static const TITLE_TEXT_FORMAT:String = "titleTextFormat";
		
		/**
		 * 文本样式 
		 */		
		public static const MSG_TEXT_FORMAT:String = "msgTextFormat";
		
		/**
		 * 文本样式 
		 */		
		public static const BTN_TEXT_FORMAT:String = "btnTextFormat";
		
		/**
		 * 遮罩样式 
		 */		
		public static const WINDOW_MASK_OTHER_DEFAULT_SKIN:String = "windowMaskOtherDefaultSkin";
		
		/**
		 * 边框背景样式 
		 */		
		public static const WINDOW_MSG_BACK_DEFAULT_SKIN:String = "windowMsgBackDefaultSkin";
		
		/**
		 * 背景按钮
		 */		
		private var back:MovieClip;
		
		/**
		 * 遮罩其它 
		 */		
		private var maskOther:MovieClip;
		
		/**
		 * 窗口名称 
		 */		
		private var titleText:TextField;
		
		/**
		 * 信息 
		 */		
		private var msgTextArea:TextArea;
		
		/**
		 * 关闭按钮 
		 */		
		private var closeBtn:Button;
		
		/**
		 * 标题文字 
		 */		
		private var title:String;
		
		/**
		 * 信息文字 
		 */		
		private var msg:String;
		
		
		public function WindowMsg(title:String,msg:String)
		{
			super();
			this.title = title;
			this.msg = msg;
		}
		
		/**
		 * 
		 */			
		private static var defaultStyles:Object = {
			titleTextFormat:new TextFormat("宋体",16,0x19C3F7),
			msgTextFormat:new TextFormat("宋体",14,0x19C3F7),
			btnTextFormat:new TextFormat("宋体",14,0x0563A1),
			windowMaskOtherDefaultSkin:"WindowMaskOther_defaultSkin",
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
				var baseSize:Number = 22;
				
				maskOther = getDisplayObjectInstance(getStyleValue(WINDOW_MASK_OTHER_DEFAULT_SKIN)) as MovieClip;
				trace("maskOther",maskOther);
				this.addChild(maskOther);
				stage.addEventListener(Event.RESIZE,handlerWindowMsgStageResize);
				
				back = getDisplayObjectInstance(getStyleValue(WINDOW_MSG_BACK_DEFAULT_SKIN)) as MovieClip;
				RectangleUtil.setRect(back,new Rectangle(0,0,this.width,this.height));
				this.addChild(back);
				
				closeBtn = new Button();
				closeBtn.label = "X";
				RectangleUtil.setRect(closeBtn,new Rectangle(this.width - space - baseSize,space,baseSize,baseSize));
				closeBtn.setStyle("textFormat",this.getStyleValue(BTN_TEXT_FORMAT) as TextFormat);
				this.addChild(closeBtn);
				closeBtn.drawNow();
				closeBtn.addEventListener(MouseEvent.CLICK,handlerCloseBtnClick);
				
				titleText = new TextField();
				titleText.text = this.title;
				RectangleUtil.setRect(titleText,new Rectangle(space,space,this.width - space * 3 - baseSize,baseSize));
				TextFieldUtil.fitText(titleText);
				titleText.setTextFormat(this.getStyleValue(TITLE_TEXT_FORMAT) as TextFormat);
				this.addChild(titleText);
				titleText.mouseEnabled = false;
				
				msgTextArea = new TextArea();
				msgTextArea.setStyle("textFormat",this.getStyleValue(MSG_TEXT_FORMAT) as TextFormat);
				msgTextArea.text = msg;
				msgTextArea.editable = false;
				RectangleUtil.setRect(msgTextArea,new Rectangle(space,space *2 + baseSize ,this.width - space * 2,this.height - baseSize - space *3));
				this.addChild(msgTextArea);
				msgTextArea.drawNow();
			}
		}
		
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerWindowMsgStageResize(e:Event):void{
			if(stage != null || maskOther != null){
				resetPlaceAndMask(stage);
			}
		}
		
		public function resetPlaceAndMask(stage:Stage):void{
			this.x = (stage.stageWidth - this.width) / 2;
			this.y = (stage.stageHeight - this.height) / 2;
			trace("maskOther",maskOther);
			maskOther.x = - this.x;
			maskOther.y = - this.y;
			maskOther.width = stage.stageWidth;
			maskOther.height = stage.stageHeight;
		}
		
		/**
		 * 更新文字内容 
		 * @param title
		 * @param msg
		 * 
		 */		
		public function refreshText(title:String,msg:String):void{
			if(titleText != null){
				if(title == null){
					title = "";
				}
				titleText.text = title;
				TextFieldUtil.fitText(titleText);
				titleText.setTextFormat(this.getStyleValue(TITLE_TEXT_FORMAT) as TextFormat);
			}
			if(msgTextArea != null){
				if(msg == null){
					msg = "";
				}
				msgTextArea.htmlText = msg;
			}
		}
		
		private function handlerCloseBtnClick(e:Event):void{
			this.visible = false;
		}
	}
}