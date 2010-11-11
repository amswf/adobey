﻿package com.snsoft.sndoor{
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
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
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
		
		
		private var menuIBtnsLayer:MovieClip;
		
		private var menuIIBtnsLayer:MovieClip;
		
		private var adLayer:MovieClip;
		
		private var logoLayer:MovieClip;
		
		private var menuIBtnV:Vector.<MenuIBtn> = new Vector.<MenuIBtn>();
		
		
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
				if(menuDO.image != null){
					imageBox.addImageUrl(menuDO.image);
				}
				menuDO.eText = menuI.getAttributeByName("eText");
				menuDO.url = menuI.getAttributeByName("url");
				menuDO.type = menuI.getAttributeByName("type");
				menuDO.window = menuI.getAttributeByName("window");
				menuDO.contents = menuI.getAttributeByName("contents");
				var menuIIList:NodeList = menuI.getNodeList("menuII");
				if(menuIIList != null){
					for(var j:int =0;j<menuIIList.length();j++){
						var menuII:Node = menuIIList.getNode(j);
						var cmenuDO:MenuDO = new MenuDO();
						cmenuDO.name = menuII.getAttributeByName("name");
						cmenuDO.text = menuII.getAttributeByName("text");
						cmenuDO.eText = menuII.getAttributeByName("eText");
						cmenuDO.image = menuII.getAttributeByName("image");
						if(cmenuDO.image != null){
							trace(cmenuDO.image);
							imageBox.addImageUrl(cmenuDO.image);
						}
						cmenuDO.eText = menuII.getAttributeByName("eText");
						cmenuDO.url = menuII.getAttributeByName("url");
						cmenuDO.type = menuII.getAttributeByName("type");
						cmenuDO.window = menuII.getAttributeByName("window");
						cmenuDO.contents = menuII.getAttributeByName("contents");
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
			
			var menuIsLayerX:Number = 0;
			var menuIsLayerY:Number = 72;
			
			var menuIHeight:Number = 37;
			
			mainBackLayer = new MovieClip();
			this.addChild(mainBackLayer);
			mainBackLayer.addEventListener(MouseEvent.MOUSE_MOVE,handlerMenuIIBtnsLayerMouseOut);
			
			mainLayer = new MovieClip();
			this.addChild(mainLayer);
			
			logoLayer = new MovieClip();
			mainLayer.addChild(logoLayer);
			logoLayer.addEventListener(MouseEvent.MOUSE_MOVE,handlerMenuIIBtnsLayerMouseOut);
			
			adLayer = new MovieClip();
			mainLayer.addChild(adLayer);
			adLayer.x = menuIsLayerX;
			adLayer.y = menuIsLayerY + menuIHeight;
			adLayer.addEventListener(MouseEvent.MOUSE_MOVE,handlerMenuIIBtnsLayerMouseOut);
		
			menuIIBtnsLayer = new MovieClip();
			mainLayer.addChild(menuIIBtnsLayer);
			menuIIBtnsLayer.x = menuIsLayerX;
			menuIIBtnsLayer.y = menuIsLayerY + menuIHeight;
			
			menuIBtnsLayer = new MovieClip();
			mainLayer.addChild(menuIBtnsLayer);
			menuIBtnsLayer.x = menuIsLayerX;
			menuIBtnsLayer.y = menuIsLayerY;
			
			var logoBack:MovieClip = SkinsUtil.createSkinByName("BtnTop_skin");
			logoBack.width = MAIN_WIDTH;
			logoBack.height = menuIsLayerY;
			logoLayer.addChild(logoBack);
			
			var ad:MovieClip = SkinsUtil.createSkinByName("BtnTop_skin");
			ad.width = MAIN_WIDTH;
			ad.height = 400;
			adLayer.addChild(ad);
			
			menuIback = SkinsUtil.createSkinByName(menuIBackDefaultSkin);
			menuIback.x = menuIsLayerX;
			menuIback.y = menuIsLayerY;
			mainBackLayer.addChild(menuIback);
			
			this.addEventListener(Event.ENTER_FRAME,handlerEnterFrame);
			stage.addEventListener(Event.RESIZE,handlerResize);
			
			
			var menuX:Number = 0;
			var menuY:Number = 0;
			//一级栏目
			for(var i:int = 0;i < menuDOV.length;i++){
				var menuDO:MenuDO = menuDOV[i];
				
				var hasChild:Boolean = false;
				
				if(menuDO.type == MenuDO.TYPE_URL){
					hasChild = false;
				}
				else if(menuDO.childMenuDOs.length > 0){
					hasChild = true;
				}
				
				if(i > 0 && i < menuDOV.length){
					var seprator:MovieClip = SkinsUtil.createSkinByName("MenuISeparator_defaultSkin");
					menuIBtnsLayer.addChild(seprator);
					seprator.x = menuX;
					seprator.y = menuY;
				}
				
				var mib:MenuIBtn = new MenuIBtn(menuDO,i,hasChild);
				menuIBtnsLayer.addChild(mib);
				menuIBtnV.push(mib);
				mib.x = menuX;
				mib.y = menuY;
				
				mib.addEventListener(MouseEvent.MOUSE_OVER,handlerMenuIBtnOver);
				if(menuDO.type == MenuDO.TYPE_URL){
					var cpl:CplxEventOpenUrl = new CplxEventOpenUrl(mib,MouseEvent.CLICK,menuDO.url);
				}
				
				menuX = mib.x + mib.width;
			}		
		}
		
		private function resetMenuIBtnsStateExceptIndex(index:int = -1):void{
			for(var i:int = 0 ;i < menuIBtnV.length;i++){
				var mibtn:MenuIBtn = menuIBtnV[i];
				if(i != index){
					mibtn.setStateToDefault();
				}
			}
		}
		
		private function handlerMenuIIBtnsLayerMouseOut(e:Event):void{
			resetMenuIBtnsStateExceptIndex();
			SpriteUtil.deleteAllChild(menuIIBtnsLayer);
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerMenuIBtnOver(e:Event):void{
			SpriteUtil.deleteAllChild(menuIIBtnsLayer);
			var effect:MovieClip = SkinsUtil.createSkinByName("MenuIIsEffect");
			var imageLayer:MovieClip = effect.effectLayer;
			menuIIBtnsLayer.addChild(effect);
			
			var mib:MenuIBtn = e.currentTarget as MenuIBtn;
			var menuDO:MenuDO = mib.menuDO;
			var cmenuDOV:Vector.<MenuDO> = menuDO.childMenuDOs;
			
			resetMenuIBtnsStateExceptIndex(mib.index);
			if(cmenuDOV.length > 0){
				var miiBack:MovieClip = SkinsUtil.createSkinByName("MenuIIBack_defaultSkin");
				imageLayer.addChild(miiBack);
				
				var miiBackBorder:MovieClip = SkinsUtil.createSkinByName("MenuIIBackBorder_defaultSkin");
				miiBackBorder.mouseEnabled = false;
				imageLayer.addChild(miiBackBorder);
				
				var baseX:Number = 0;
				var baseY:Number = 0;
				
				var bx:Number = 0;
				var by:Number = 0;
				
				var backWidth:Number = MAIN_WIDTH;
				var backHeight:Number = 0;
				
				var menuHeight:Number = 0;
				
				var rowNum:int = 0;
				if(menuDO.type == MenuDO.TYPE_CARD){
					rowNum = 3;
					baseX = 0;
					baseY = 0;
					
					bx = baseX;
					by = baseY;
					
					for(var i:int =0;i < cmenuDOV.length;i++){
						
						if(i % rowNum != 0 || i % rowNum != rowNum - 1){
							var separator:MovieClip = SkinsUtil.createSkinByName("MenuIISeparator_defaultSkin");
							separator.x = bx;
							separator.y = by;
							imageLayer.addChild(separator);
						}
						
						var cmdo:MenuDO = cmenuDOV[i];
						var bmd:BitmapData = imageBox.getImageByUrl(cmdo.image);
						cmdo.text = cmdo.text;
						cmdo.contents = cmdo.contents;
						var miicb:MenuIICardBtn = new MenuIICardBtn(cmdo,bmd);
						miicb.x = bx;
						miicb.y = by;
						imageLayer.addChild(miicb);
						bx = miicb.x + miicb.width;
						if(i % rowNum == rowNum - 1){
							bx = baseX;
							by += miicb.height;
						}
						menuHeight = miicb.height;
					}
					backHeight = (int((cmenuDOV.length - 1) / rowNum) + 1) * menuHeight;
				}
				else if(menuDO.type == MenuDO.TYPE_LIST){
					rowNum = 4;
					var boarder:Number = 10;
					var imgi:BitmapData = imageBox.getImageByUrl(menuDO.image);
					var imagibm:Bitmap = new Bitmap(imgi,"auto",true);
					imageLayer.addChild(imagibm);
					imagibm.x = boarder;
					imagibm.y = boarder;
					
					baseX = imagibm.x + imgi.width + boarder * 4;
					baseY = 0;
					
					bx = baseX;
					by = baseY;
					
					var my:Number = 0;
					for(var ii:int =0;ii < cmenuDOV.length;ii++){
						if(ii < cmenuDOV.length && ii % (rowNum * 2) < rowNum){
							var separatorList:MovieClip = SkinsUtil.createSkinByName("MenuIISeparator_defaultSkin");
							separatorList.x = bx;
							separatorList.y = by;
							imageLayer.addChild(separatorList);
						}
						
						var cmldo:MenuDO = cmenuDOV[ii];
						var bmdl:BitmapData = imageBox.getImageByUrl(cmldo.image);
						cmldo.text = cmldo.text;
						cmldo.contents = cmldo.contents;
						var miilb:MenuIIListBtn = new MenuIIListBtn(cmldo,145,imgi.height / 2);
						miilb.x = bx;
						miilb.y = by;
						imageLayer.addChild(miilb);
						bx = miilb.x + miilb.width;
						if(ii % rowNum == rowNum - 1){
							bx = baseX;
							by += miilb.height;
						}
						menuHeight = miilb.height;
					}
					my = (int((cmenuDOV.length - 1) / (rowNum *2)) + 1) * menuHeight * 2;
					
					backHeight = boarder + imgi.height + boarder;
					
					if(my > backHeight){
						backHeight = my;
					}
				}
				miiBack.width = MAIN_WIDTH;
				miiBack.height = backHeight;
				
				miiBackBorder.width = MAIN_WIDTH;
				miiBackBorder.height = backHeight;
			}
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
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