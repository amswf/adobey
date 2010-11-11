package com.snsoft.sndoor{
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.TextFieldUtil;
	import com.snsoft.util.complexEvent.CplxEventOpenUrl;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class MenuIIListBtn extends UIComponent{
		
		/**
		 * 响应鼠标事件的透明框 
		 */		
		private var btnTop:MovieClip;
		
		private var titleText:TextField;
		
		private var eTitleText:TextField;
		
		private var _menuDO:MenuDO;
		
		private var imagCplx:CplxEventOpenUrl;
		
		private var effect:MovieClip;
				
		public function MenuIIListBtn(menuDO:MenuDO,width:Number,height:Number){
			super();
			this._menuDO = menuDO;
			this.width = width;
			this.height = height;
			
			
			var boarder:Number = 10;
			
			effect = SkinsUtil.createSkinByName("ImageEffect");
			var imageLayer:MovieClip = effect.effectLayer;
			if(menuDO.url != null){
				imagCplx = new CplxEventOpenUrl(effect,MouseEvent.CLICK,menuDO.url,menuDO.window);
			}
			
			//英文标题
			eTitleText = new TextField();
			eTitleText.mouseEnabled = false;
			eTitleText.htmlText = menuDO.eText;
			eTitleText.width = this.width - boarder - boarder;
			eTitleText.height = 16;
			eTitleText.x = boarder;
			eTitleText.y = this.height - boarder - eTitleText.height;
			imageLayer.addChild(eTitleText);
			
			//标题
			titleText = new TextField();
			titleText.mouseEnabled = false;
			titleText.htmlText = "<b>"+menuDO.text+"</b>";
			titleText.width = this.width - boarder - boarder;
			titleText.height = 18;
			titleText.x = boarder;
			titleText.y = this.height - boarder - eTitleText.height - titleText.height;
			imageLayer.addChild(titleText);
			
			
			btnTop = getDisplayObjectInstance(getStyleValue(btnTopSkin)) as MovieClip;
			btnTop.width = this.width - boarder - boarder;
			btnTop.height = titleText.height + eTitleText.height;
			btnTop.x = boarder;
			btnTop.y = titleText.y;
			btnTop.buttonMode = true;
			imageLayer.addChild(btnTop);
		}
		
		/**
		 * 
		 */			
		private static var defaultStyles:Object = {
			btnTopSkin:"BtnTop_skin",
			titleDefaultTextFormat:new TextFormat("",12,0x728A56),
			eTitleDefaultTextFormat:new TextFormat("Arial",10,0x949494)
		};
		
		/**
		 * 样式 
		 */	
		
		private static const btnTopSkin:String = "btnTopSkin";
		
		private static const titleDefaultTextFormat:String = "titleDefaultTextFormat";
		
		private static const eTitleDefaultTextFormat:String = "eTitleDefaultTextFormat";
		
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
			this.addChild(effect);
			titleText.setTextFormat(getStyleValue(titleDefaultTextFormat) as TextFormat);
			eTitleText.setTextFormat(getStyleValue(eTitleDefaultTextFormat) as TextFormat);
		}

	}
}