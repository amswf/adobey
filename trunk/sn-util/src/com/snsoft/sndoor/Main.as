package com.snsoft.sndoor{
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.SpriteUtil;
	import com.snsoft.util.complexEvent.CplxEventOpenUrl;
	import com.snsoft.xmldom.Node;
	import com.snsoft.xmldom.NodeList;
	import com.snsoft.xmldom.XMLDom;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
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
		
		/**
		 * 按钮数据对象列表 
		 */		
		private var menuDOV:Vector.<MenuDO>;
		
		
		private var imageBox:ImageBox;
		
		
		/**
		 * 
		 * 
		 */		
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
			creatData(node);
			
		}
		
		private function creatData(node:Node):void{
			imageBox = new ImageBox();
			trace(node.name);
			menuDOV = new Vector.<MenuDO>();
			var menuIs:Node = node.getNodeListFirstNode("menuIs");
			var menuIList:NodeList = menuIs.getNodeList("menuI");
			for(var i:int =0;i<menuIList.length();i++){
				var menuI:Node = menuIList.getNode(i);
				var menuDO:MenuDO = new MenuDO();
				menuDO.name = menuI.getAttributeByName("name");
				menuDO.text = menuI.getAttributeByName("text");
				menuDO.eText = menuI.getAttributeByName("eText");
				menuDO.image = menuI.getAttributeByName("image");
				imageBox.addImageUrl(menuDO.image);
				menuDO.eText = menuI.getAttributeByName("eText");
				menuDO.url = menuI.getAttributeByName("url");
				menuDO.type = menuI.getAttributeByName("type");
				var menuIIList:NodeList = menuI.getNodeList("menuII");
				if(menuIIList != null){
					for(var j:int =0;j<menuIIList.length();j++){
						var menuII:Node = menuIIList.getNode(j);
						var cmenuDO:MenuDO = new MenuDO();
						cmenuDO.name = menuII.getAttributeByName("name");
						cmenuDO.text = menuII.getAttributeByName("text");
						cmenuDO.eText = menuII.getAttributeByName("eText");
						cmenuDO.image = menuII.getAttributeByName("image");
						imageBox.addImageUrl(cmenuDO.image);
						cmenuDO.eText = menuII.getAttributeByName("eText");
						cmenuDO.url = menuII.getAttributeByName("url");
						cmenuDO.type = menuII.getAttributeByName("type");
						menuDO.pushChildMenuDO(cmenuDO);
					}
				}
				menuDOV.push(menuDO);
				
			}
			
			imageBox.addEventListener(Event.COMPLETE,handlerImageBoxCmp);
			imageBox.loadImage();
			
		}
		
		private function handlerImageBoxCmp(e:Event):void{
			init();
		}
		
		private function init():void{
			
			mainBackLayer = new MovieClip();
			this.addChild(mainBackLayer);
			
			mainLayer = new MovieClip();
			this.addChild(mainLayer);
			
			var menuX:Number = 0;
			var menuY:Number = 72;
			
			menuIback = SkinsUtil.createSkinByName(menuIBackDefaultSkin);
			menuIback.x = menuX;
			menuIback.y = menuY;
			mainBackLayer.addChild(menuIback);
			
			for(var i:int =0;i < menuDOV.length;i++){
				var menuDO:MenuDO = menuDOV[i];
				
				var hasChild:Boolean = false;
				
				if(menuDO.type == MenuDO.TYPE_URL){
					hasChild = false;
				}
				else if(menuDO.childMenuDOs.length > 0){
					hasChild = true;
				}
				
				var mib:MenuIBtn = new MenuIBtn(menuDO.text,hasChild);
				mainLayer.addChild(mib);
				mib.x = menuX;
				mib.y = menuY;
				menuX = mib.x + mib.width;
				
				if(menuDO.type == MenuDO.TYPE_URL){
					var cpl:CplxEventOpenUrl = new CplxEventOpenUrl(mib,MouseEvent.CLICK,menuDO.url);
				}
				else if(menuDO.type == MenuDO.TYPE_CARD || menuDO.type == MenuDO.TYPE_LIST){
					
				}
			}
			
			this.addEventListener(Event.ENTER_FRAME,handlerEnterFrame);
			stage.addEventListener(Event.RESIZE,handlerResize);
		}
		
		
		
		private function handlerLoadXMLError(e:Event):void{
			trace("加载出错！" + DATA_XML_URL);
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