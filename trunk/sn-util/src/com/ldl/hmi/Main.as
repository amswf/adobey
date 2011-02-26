package com.ldl.hmi{
	import com.snsoft.font.EmbedFonts;
	import com.snsoft.font.EmbedFontsEvent;
	import com.snsoft.util.uiloading.LoadingProgress;
	import com.snsoft.xmldom.Node;
	import com.snsoft.xmldom.XMLDom;
	import com.snsoft.xmldom.XMLLoader;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	public class Main extends Sprite{
		
		private var lp:LoadingProgress;
		
		public function Main(){
			lp = new LoadingProgress(38,38,0xffffff);
			lp.x = 400;
			this.addChild(lp);
			
			this.addEventListener(Event.ENTER_FRAME,handlerEnterFrame);
		}
		
		/**
		 * 事件	播放帧事件
		 * @param e
		 * 
		 */		
		private function handlerEnterFrame(e:Event):void{
			this.removeEventListener(Event.ENTER_FRAME,handlerEnterFrame);
			
			loadFonts();
		}
		
		private function loadXML():void{
			var xl:XMLLoader = new XMLLoader("data.xml");
			xl.addEventListener(Event.COMPLETE,handlerLoadXMLCmp);
		}
		
		private function handlerLoadXMLCmp(e:Event):void{
			var xl:XMLLoader = e.currentTarget as XMLLoader;
			var xd:XMLDom = new XMLDom(xl.xml);
			var node:Node = xd.parse();
			node.getNodeListFirstNode("menus");
			setProgressValue();
		}
		
		private function loadFonts():void{
			var ef:EmbedFonts = new EmbedFonts("FZHeiB01S");
			ef.loadFontSwf();
			ef.addEventListener(Event.COMPLETE,handlerLoadFontCmp);
			ef.addEventListener(EmbedFontsEvent.IO_ERROR,handlerIOError);
			ef.addEventListener(ProgressEvent.PROGRESS,handlerProgress);
		}
		
		private function handlerProgress(e:Event):void{
			var ef:EmbedFonts = e.currentTarget as EmbedFonts;
			trace(ef.getProgressValue());
			
			//进度条输出.......................................................
			//和XML解析,顺序加载
		}
		
		private function handlerLoadFontCmp(e:Event):void{
			setProgressValue();
		}
		
		private function handlerIOError(e:Event):void{
			trace("字体加载出错");
		}
		
		private function setProgressValue():void{
			if(lp != null){
				this.removeChild(lp);
				lp = null;
				init();
				
			}
		}
		
		private function init():void{
			var mb:MenuBtn = new MenuBtn();
			mb.x = 25;
			mb.y = 3;
			mb.setText("联系我们","EMPLOYMENT");
			this.addChild(mb);
		}
	}
}