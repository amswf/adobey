package com.snsoft.util.log{
	import fl.controls.Button;
	import fl.controls.TextArea;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	

	public class LogPanel extends UIComponent{
		
		/**
		 * 文本样式 
		 */		
		public static const TEXT_FORMAT:String = "myTextFormat";
		
		/**
		 * 日志输出文本区 
		 */		
		private var logOutTextArea:TextArea;
		
		/**
		 * 背景按钮
		 */		
		private var back:Button;
		
		/**
		 * 窗口名称 
		 */		
		private var titleText:TextField;
		
		/**
		 * 清除按钮 
		 */		
		private var clearBtn:Button;
		
		/**
		 * 隐藏按钮 
		 */		
		private var hiddenBtn:Button;
		
		private var isBackMouseDown:Boolean;
		
		public function LogPanel()
		{
		}
		
		/**
		 * 
		 */			
		private static var defaultStyles:Object = {
			myTextFormat:new TextFormat("宋体",13,0x000000)
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
		 * 绘制组件显示
		 */		
		override protected function draw():void{
			
			var space:Number = 10;
			
			var btnHeight:Number = 22;
			
			var btnWidth:Number = 38;
			
			back = new Button();
			back.label = "";
			this.addChild(back);
			back.addEventListener(MouseEvent.MOUSE_DOWN,handlerBackMouseDown);
			back.addEventListener(MouseEvent.MOUSE_UP,handlerBackMouseUp);
			
			titleText = new TextField();
			titleText.text = "LogMg";
			titleText.selectable = false;
			titleText.mouseEnabled = false;
			this.addChild(titleText);
			
			clearBtn = new Button();
			clearBtn.label = "clear";
			this.addChild(clearBtn);
			clearBtn.addEventListener(MouseEvent.CLICK,handlerClearBtnClick);
			
			
			hiddenBtn = new Button();
			hiddenBtn.label = "X";
			this.addChild(hiddenBtn);
			hiddenBtn.addEventListener(MouseEvent.CLICK,handlerHiddenBtnClick);
			
			logOutTextArea = new TextArea();
			logOutTextArea.editable = false;
			logOutTextArea.text="";
			logOutTextArea.setStyle("textFormat",this.getStyleValue(TEXT_FORMAT) as TextFormat);
			this.addChild(logOutTextArea);
			
			resizeChild();
			
			refreshLogMsg();
		}
		
		private function handlerHiddenBtnClick(e:Event):void{
			this.visible = false;
		}
		
		private function handlerClearBtnClick(e:Event):void{
			LogMg.logMsg = "";
			this.refreshLogMsg();
		}
		
		
		private function handlerBackMouseDown(e:Event):void{
			isBackMouseDown = true;
			this.startDrag(false,new Rectangle(0,0,stage.stageWidth,stage.stageHeight));
		}
		
		private function handlerBackMouseUp(e:Event):void{
			isBackMouseDown = false;
			this.stopDrag();
		}
		
		private function resizeChild():void{
			var space:Number = 10;
			 
			var btnRect:Rectangle = new Rectangle(space,space,38,22);
			var titleTextRect:Rectangle = new Rectangle(space,space,50,22);
			
			back.width = this.width;
			back.height = this.height;
			
			titleText.x = titleTextRect.x;
			titleText.y = titleTextRect.x;
			titleText.width = titleTextRect.width;
			titleText.height = titleTextRect.width;
			
			clearBtn.x = btnRect.x + titleText.x + titleText.width;
			clearBtn.y = btnRect.x;
			clearBtn.width = btnRect.width;
			clearBtn.height = btnRect.height;
			
			hiddenBtn.x = this.width - space - 22;
			hiddenBtn.y = space;
			hiddenBtn.width = 22;
			hiddenBtn.height = btnRect.height;
			
			logOutTextArea.x = space;
			logOutTextArea.y = space * 2 + btnRect.height;
			logOutTextArea.width = this.width-space * 2;
			logOutTextArea.height = this.height - space * 3 - btnRect.height;
			
			back.drawNow();
			clearBtn.drawNow();
			hiddenBtn.drawNow();
			logOutTextArea.drawNow();
		}
		
		
		/**
		 * 刷新日志显示 
		 * 
		 */		
		public function refreshLogMsg():void{
			if(logOutTextArea != null && this.visible == true){
				logOutTextArea.text = LogMg.logMsg;
			}
		}
	}
}