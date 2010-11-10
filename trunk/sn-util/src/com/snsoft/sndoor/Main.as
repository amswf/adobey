package com.snsoft.sndoor{
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.SpriteUtil;
	import com.snsoft.xmldom.Node;
	import com.snsoft.xmldom.NodeList;
	import com.snsoft.xmldom.XMLDom;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class Main extends MovieClip{
		
		private static const menuIBackDefaultSkin:String = "MenuIBack_defaultSkin";
		
		private static const DATA_XML_URL:String = "data.xml";
		
		private var mainBackLayer:MovieClip;
		
		private var mainLayer:MovieClip;
		
		private var MAIN_WIDTH:Number = 1002;
		
		/**
		 * 一级按钮背景 
		 */		
		private var menuIback:MovieClip;
		
	
		
		
		public function Main()
		{
			super();
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loadXML();
		}
		
		
		private function loadXML():void{
			var url:String = DATA_XML_URL;
			var req:URLRequest = new URLRequest(url);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,handlerLoadXMLCmp);
			loader.addEventListener(IOErrorEvent.IO_ERROR,handlerLoadXMLError);
			loader.load(req);
		}
		
		private function handlerLoadXMLCmp(e:Event):void{
			var loader:URLLoader = e.currentTarget as URLLoader;
			var xml:XML = new XML(loader.data);
			var xmldom:XMLDom = new XMLDom(xml);
			var node:Node = xmldom.parse();
			creatDO(node);
			init();
		}
		
		private function creatDO(node:Node):void{
			trace(node.name);
			var menuIs:Node = node.getNodeListFirstNode("menuIs");
			var menuList:NodeList = menuIs.getNodeList("menuI");
			for(var i:int =0;i<menuList.length();i++){
				var menuI:Node = menuList.getNode(i);
			}
			trace(menuList.length());
		}
		
		private function handlerLoadXMLError(e:Event):void{
			trace("加载出错！" + DATA_XML_URL);
		}
		
		
		private function init():void{
			
			mainBackLayer = new MovieClip();
			this.addChild(mainBackLayer);
			
			mainLayer = new MovieClip();
			this.addChild(mainLayer);
			
			menuIback = SkinsUtil.createSkinByName(menuIBackDefaultSkin);
			menuIback.x = 0;
			menuIback.y = 72;
			mainBackLayer.addChild(menuIback);
			
			var mib:MenuIBtn = new MenuIBtn("政府用户",true);
			mainLayer.addChild(mib);
			mib.x = 0;
			mib.y = 72;
			
			var mib2:MenuIBtn = new MenuIBtn("政府用户",true);
			mainLayer.addChild(mib2);
			mib2.x = mib.width + mib.x;
			mib2.y = 72;
			
			this.addEventListener(Event.ENTER_FRAME,handlerEnterFrame);
			stage.addEventListener(Event.RESIZE,handlerResize);
		}
		
		private function handlerEnterFrame(e:Event):void{
			this.removeEventListener(Event.ENTER_FRAME,handlerEnterFrame);
			resize();
		}
		
		private function handlerResize(e:Event):void{
			resize();
		}
		
		private function resize():void{
			alignCenter(mainLayer, MAIN_WIDTH, stage.stageWidth);
			updateToStageWidth(menuIback);
		}
		
		private function alignCenter(sprite:Sprite,width:Number,parentWidth:Number):void{
			var x:Number = 0;
			if(width <= parentWidth){
				x = (parentWidth - width) * 0.5;
			}
			sprite.x =x;
		}
		
		private function updateToStageWidth(sprite:Sprite):void{
			sprite.width = stage.stageWidth;
		}
	}
}