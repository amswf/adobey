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
	
	public class MenuIICardBtn extends UIComponent{
		
		private var titleText:TextField;
		
		private var contentsText:TextField;
		
		private var image:MovieClip;
		
		private var imageBitmapData:BitmapData;
		
		private var imageDefaultAlpha:Number = 1;
		
		private var _menuDO:MenuDO;
		
		private var imagCplx:CplxEventOpenUrl;
		
		public function MenuIICardBtn(menuDO:MenuDO,imageBitmapData:BitmapData){
			super();
			this._menuDO = menuDO;
			this.imageBitmapData = imageBitmapData;
				
			
			var boarder:Number = 10;
			
			var textWidth:Number = 110;
			
			//显示图片
			var imageBitmap:Bitmap = new Bitmap(imageBitmapData,"auto",true);
			image = SkinsUtil.createSkinByName("ImageEffect");
			image.buttonMode = true;
			image.x = boarder;
			image.y = boarder;
			var imageLayer:MovieClip = image.imageLayer;
			imageLayer.addChild(imageBitmap);
			image.alpha = imageDefaultAlpha;
			image.addEventListener(MouseEvent.MOUSE_OVER,handlerMouseOver);
			image.addEventListener(MouseEvent.MOUSE_OUT,handlerMouseOut);
			if(menuDO.url != null){
				imagCplx = new CplxEventOpenUrl(image,MouseEvent.CLICK,menuDO.url,menuDO.window);
			}
			//标题
			titleText = new TextField();
			titleText.mouseEnabled = false;
			titleText.htmlText = "<b>"+menuDO.text+"</b>";
			titleText.x = image.x + image.width + boarder;
			titleText.y = 30;
			 
			titleText.width = textWidth;
			titleText.height = 20;
			
			//内容
			contentsText = new TextField();
			contentsText.mouseEnabled = false;
			contentsText.htmlText = menuDO.contents;
			contentsText.x = image.x + image.width + boarder;
			contentsText.y = 60;
			contentsText.width = textWidth;
			contentsText.height = 81;
			
			this.width = boarder + image.width + boarder + textWidth + boarder;
			this.height = boarder + image.height + boarder;
		}
		
		/**
		 * 
		 */			
		private static var defaultStyles:Object = {
			titleDefaultTextFormat:new TextFormat("",14,0x5f5f5f),
			contentsDefaultTextFormat:new TextFormat("",12,0x949494)
		};
		
		/**
		 * 样式 
		 */						
		private static const titleDefaultTextFormat:String = "titleDefaultTextFormat";
		
		/**
		 * 
		 */		
		private static const contentsDefaultTextFormat:String = "contentsDefaultTextFormat";
		
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
			this.addChild(image);
			this.addChild(titleText);
			titleText.setTextFormat(getStyleValue(titleDefaultTextFormat) as TextFormat);
			this.addChild(contentsText);
			contentsText.setTextFormat(getStyleValue(contentsDefaultTextFormat) as TextFormat);
		}
		
		private function handlerMouseOver(e:Event):void{
			image.alpha = 1;
		}
		
		private function handlerMouseOut(e:Event):void{
			image.alpha = imageDefaultAlpha;
		}

		public function get menuDO():MenuDO
		{
			return _menuDO;
		}

	}
}