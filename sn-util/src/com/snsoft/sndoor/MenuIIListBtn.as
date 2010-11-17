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
		
		private var lm:MovieClip;
				
		public function MenuIIListBtn(menuDO:MenuDO,width:Number,height:Number){
			super();
			this._menuDO = menuDO;
			this.width = width;
			this.height = height;
			
			
			var boarder:Number = 10;
			
			effect = SkinsUtil.createSkinByName("ImageEffect");
			var imageLayer:MovieClip = effect.effectLayer;
			
			
			//英文标题
			eTitleText = new TextField();
			eTitleText.mouseEnabled = false;
			eTitleText.htmlText = menuDO.eText;
			eTitleText.width = this.width - boarder - boarder;
			eTitleText.height = 16;
			eTitleText.x = boarder;
			eTitleText.y = this.height - boarder - eTitleText.height;
			this.addChild(eTitleText);
			eTitleText.setTextFormat(getStyleValue(eTitleMouseOverTextFormat) as TextFormat);
			
			//标题
			titleText = new TextField();
			titleText.mouseEnabled = false;
			titleText.htmlText = "<b>"+menuDO.text+"</b>";
			titleText.width = this.width - boarder - boarder;
			titleText.height = 18;
			titleText.x = boarder;
			titleText.y = this.height - boarder - eTitleText.height - titleText.height;
			this.addChild(titleText);
			titleText.setTextFormat(getStyleValue(titleMouseOverTextFormat) as TextFormat);
			
			
			btnTop = getDisplayObjectInstance(getStyleValue(btnTopSkin)) as MovieClip;
			btnTop.width = this.width - boarder - boarder;
			btnTop.height = titleText.height + eTitleText.height + 5;
			btnTop.x = boarder;
			btnTop.y = titleText.y;
			btnTop.buttonMode = true;
			
			btnTop.addEventListener(MouseEvent.MOUSE_OVER,handlerMouseOver);
			btnTop.addEventListener(MouseEvent.MOUSE_OUT,handlerMouseOut);
			if(menuDO.url != null){
				imagCplx = new CplxEventOpenUrl(btnTop,MouseEvent.CLICK,menuDO.url,menuDO.window);
			}
			
			var ew:Number = TextFieldUtil.calculateWidth(eTitleText);
			var tw:Number = TextFieldUtil.calculateWidth(titleText);
			
			var lmw:Number = ew > tw ? ew : tw;
			lm = SkinsUtil.createSkinByName("MenuIILineMovieEffect");
			lm.width = lmw;
			lm.x = boarder+ lm.width / 2;
			lm.y = btnTop.getRect(this).bottom - lm.height;
			
			this.addChild(lm);
			this.addChild(btnTop);
			
		}
		
		private function handlerMouseOver(e:Event):void{
			trace("handlerMouseOver");
			titleText.setTextFormat(getStyleValue(titleMouseOverTextFormat) as TextFormat);
			eTitleText.setTextFormat(getStyleValue(eTitleMouseOverTextFormat) as TextFormat);
			lm.play();
		}
		
		private function handlerMouseOut(e:Event):void{
			trace("handlerMouseOut");
			titleText.setTextFormat(getStyleValue(titleDefaultTextFormat) as TextFormat);
			eTitleText.setTextFormat(getStyleValue(eTitleDefaultTextFormat) as TextFormat);
			lm.gotoAndStop(1);
		}
		
		/**
		 * 
		 */			
		private static var defaultStyles:Object = {
			btnTopSkin:"BtnTop_skin",
			titleDefaultTextFormat:new TextFormat("",12,0x728A56),
			eTitleDefaultTextFormat:new TextFormat("Arial",10,0x949494),
			titleMouseOverTextFormat:new TextFormat("",12,0x78bb54),
			eTitleMouseOverTextFormat:new TextFormat("Arial",10,0xd1d4d2)
		};
		
		/**
		 * 样式 
		 */	
		
		private static const btnTopSkin:String = "btnTopSkin";
		
		private static const titleDefaultTextFormat:String = "titleDefaultTextFormat";
		
		private static const eTitleDefaultTextFormat:String = "eTitleDefaultTextFormat";
		
		private static const titleMouseOverTextFormat:String = "titleMouseOverTextFormat";
		
		private static const eTitleMouseOverTextFormat:String = "eTitleMouseOverTextFormat";
		
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
			//this.addChild(effect);
			titleText.setTextFormat(getStyleValue(titleDefaultTextFormat) as TextFormat);
			eTitleText.setTextFormat(getStyleValue(eTitleDefaultTextFormat) as TextFormat);
		}

	}
}