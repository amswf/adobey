package com.snsoft.room3d{
	import com.snsoft.util.HashVector;
	import com.snsoft.util.ImageLoader;
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.SpriteUtil;
	import com.snsoft.util.StringUtil;
	import com.snsoft.util.text.Text;
	import com.snsoft.xmldom.Node;
	import com.snsoft.xmldom.NodeList;
	
	import fl.containers.ScrollPane;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getDefinitionByName;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import org.papervision3d.materials.MovieAssetMaterial;
	
	public class Main extends MovieClip{
		
		/**
		 * <var name="isTsp" value="true"/>
		 */		
		private static const IS_TSP:String = "isTsp";
		
		/**
		 * 是否触摸屏使用 
		 */		
		private var isTsp:Boolean = false;
		
		/**
		 * 默认的数据文件 
		 */		
		private var dataUrl:String = "data.xml";
		
		/**
		 * XML加载
		 */		
		private var xmlLoader:XMLLoader; 
		
		/**
		 * 房间列表 
		 */		
		private var roomHV:HashVector;
		
		/**
		 * xml数据标签名称 
		 */		
		private static const XML_TAG_VARS:String = "vars";
		
		/**
		 * xml数据标签名称 
		 */		
		private static const XML_TAG_VAR:String = "var";
		
		/**
		 * xml数据标签名称 
		 */		
		private static const XML_TAG_ROOM:String = "room";
		
		/**
		 * xml数据标签名称 
		 */
		private static const XML_TAG_PLACE:String = "place";
		
		/**
		 * xml数据标签属性 
		 */
		private static const XML_ATT_BGIMG:String = "bgImg";
		
		/**
		 * xml数据标签属性 
		 */
		private static const XML_ATT_TITLEIMG:String = "titleImg";
		
		/**
		 * xml数据标签属性 
		 */
		private static const XML_ATT_NAME:String = "name";
		
		/**
		 * xml数据标签属性 
		 */
		private static const XML_ATT_VALUE:String = "value";
		
		/**
		 * xml数据标签属性 
		 */
		private static const XML_ATT_TEXT:String = "text";
		
		/**
		 * xml数据标签属性 
		 */
		private static const XML_ATT_X:String = "x";
		
		/**
		 * xml数据标签属性 
		 */
		private static const XML_ATT_Y:String = "y";
		
		/**
		 * xml数据标签属性 
		 */
		private static const XML_ATT_BALLIMG:String = "ballImg";
		
		/**
		 * xml数据标签属性 
		 */
		private static const XML_ATT_FRONTIMG:String = "frontImg";
		
		/**
		 * xml数据标签属性 
		 */
		private static const XML_ATT_BACKIMG:String = "backImg";
		
		/**
		 * xml数据标签属性 
		 */
		private static const XML_ATT_TOPIMG:String = "topImg";
		
		/**
		 * xml数据标签属性 
		 */
		private static const XML_ATT_BOTTOMIMG:String = "bottomImg";
		
		/**
		 * xml数据标签属性 
		 */
		private static const XML_ATT_LEFTIMG:String = "leftImg";
		
		/**
		 * xml数据标签属性 
		 */
		private static const XML_ATT_RIGHTIMG:String = "rightImg";
		
		/**
		 * xml数据标签属性 
		 */
		private static const PLACE_SPACE_10:Number = 10;
		
		/**
		 * xml数据标签属性 
		 */
		private static const PLACE_SPACE_2:Number = 2;
		
		/**
		 *房间平面图所在的层 
		 */		
		private var roomMapLayer:MovieClip = new MovieClip();
		
		/**
		 * 房间所在的层 
		 */		
		private var roomLayer:MovieClip = new MovieClip();
		
		/**
		 * 房间文字层 
		 */		
		private var roomTextLayer:MovieClip = new MovieClip();
		
		/**
		 * 观查点文字层 
		 */		
		private var seatTextLayer:MovieClip = new MovieClip();
		
		
		/**
		 * 观查点文字层 
		 */		
		private var seatWindowMsgLayer:MovieClip = new MovieClip();
		
		/**
		 * 3d全景对象
		 */		
		private var seat3dLayer:MovieClip = new MovieClip();
		
		/**
		 * 房间平面图滚动条 
		 */		
		private var seatScrollPane:ScrollPane;
		
		/**
		 * 房间平面图滚动条默认尺寸和宽高 
		 */		
		private static const SEAT_SCROLL_PANE_DEFAULT_RECT:Rectangle = new Rectangle(630,20,260,300);
		
		/**
		 *按钮对象 
		 */		
		private var menu:Menu;
		
		/**
		 * 按钮默认尺寸位置信息 
		 */		
		private static const MENU_DEFAULT_RECT:Rectangle = new Rectangle(630,320);
		
		/**
		 * 房间地图 
		 */		
		private var roomMap:RoomMap;
		
		/**
		 *当前3D显示 
		 */		
		private var currentSeat3D:Seat3D;
		
		/**
		 * 3D显示背景，用于全屏切换时，挡住其它显示对象 
		 */		
		private var seat3DBack:MovieClip;
		
		/**
		 * 房间名称显示尺寸位置 信息
		 */		
		private static const ROOM_TEXT_RECT:Rectangle = new Rectangle(170,20,450,20);
		
		/**
		 * 3D全景默认宽高位置信息 
		 */		
		private static const SEAT3D_DEFAULT_RECT:Rectangle = new Rectangle(170,50,450,378);
		
		/**
		 * 观察点标题信 默认宽高位置
		 */		
		private static const SEAT_TITLE_DEFAULT_RECT:Rectangle = new Rectangle(170,438,450,42);
		
		/**
		 * 观察点标题信 全屏时宽高位置
		 */		
		private static const SEAT_TITLE_FULL_SCREEN_RECT:Rectangle = new Rectangle(10,10,450,42);
		
		/**
		 * 当前场景的全屏状态 
		 */		
		private var currentStageDisplayStateSign:Boolean = true;
		
		/**
		 * 当前场景是否有缩放事件的标记 
		 */		
		private var isStageResize:Boolean = false;
		
		
		/**
		 * 主背景影片剪辑 
		 */		
		private var bakMC:MovieClip;
		
		/**
		 * 房间卡滚动组件 
		 */		
		private var roomCardsScrollPane:ScrollPane;
		
		/**
		 * 房间卡滚动组件默认Rect
		 */		
		private static const ROOM_CARDS_SCROLLPANE_RECT:Rectangle = new Rectangle(10,20,150,460);
		
		/**
		 * 主显示层 
		 */		
		private var mainLayer:MovieClip;
		
		/**
		 * 观察点简介信息 
		 */		
		private var introMsg:IntroMsg;	
		
		/**
		 * 观察点详细信息 
		 */		
		private var windowMsg:WindowMsg;	
		
		private var currentSeatDO:SeatDO;
		
		
		private var creatSeat3DSign:Boolean = true;
		
		/**
		 * 构造方法 
		 * 
		 */		
		public function Main(){
			super();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			this.addEventListener(Event.ENTER_FRAME,handlerEnterFrame);
			
		}
		
		/**
		 * 场景进入下一帧时，初始化显示对象 
		 * @param e
		 * 
		 */		
		private function handlerEnterFrame(e:Event):void{
			trace("handlerEnterFrame");
			this.removeEventListener(Event.ENTER_FRAME,handlerEnterFrame);
			
			
			stage.addEventListener(Event.RESIZE,handlerStageResize);
			
			var url:String = loaderInfo.parameters["url"];
			if(url != null){
				this.dataUrl = url;
			}
			loadXML();
		}
		
		/**
		 * 全屏非全屏时，设置显示对象的位置和宽高 
		 * @param e
		 * 
		 */		
		private function handlerStageResize(e:Event):void{
			if(!isTsp){
				trace("handlerStageResize",stage.stageHeight,stage.stageWidth);
				setMainDisplayState();
			}
		}
		
		/**
		 * 加载XML数据 
		 * 
		 */		
		private function loadXML():void{
			xmlLoader = new XMLLoader(dataUrl);
			xmlLoader.addEventListener(Event.COMPLETE,handlerLoadXMLCmp);
			xmlLoader.loadXML();
		}
		
		/**
		 * 加载XML完成事件，加载logo图片 
		 * @param e
		 * 
		 */		
		private function handlerLoadXMLCmp(e:Event):void{
			var url:String = "logo.png";
			var il:ImageLoader = new ImageLoader();
			il.loadImage(url);
			il.addEventListener(Event.COMPLETE,handlerLoaderLogoImgCmp);
		}
		
		/**
		 * 加载logo图片 完成后，初始化显示对象
		 * @param e
		 * 
		 */		
		private function handlerLoaderLogoImgCmp(e:Event):void{
			var il:ImageLoader = e.currentTarget as ImageLoader;
			il.bitmapData;
			il.url;
			ImgCatch.imgHV.push(il.bitmapData.clone(),il.url);
			
			initData();
		}
		
		
		/**
		 * 初始化信息
		 * 
		 */		
		private function initData():void{
			
			bakMC = this.getChildByName("bak") as MovieClip;
			
			mainLayer = new MovieClip();
			mainLayer.x = bakMC.x;
			mainLayer.y = bakMC.y;
			this.addChild(mainLayer);
			
			var node:Node = xmlLoader.xmlNode;
			
			var varsList:NodeList = node.getNodeList(XML_TAG_VARS);
			for(var iVar:int = 0;iVar < varsList.length();iVar ++){
				var varsNode:Node = varsList.getNode(iVar);
				var varList:NodeList = varsNode.getNodeList(XML_TAG_VAR);
				for(var jVar:int = 0;jVar < varList.length();jVar ++){
					var varNode:Node = varList.getNode(jVar);
					var varName:String = varNode.getAttributeByName(XML_ATT_NAME);
					var varValue:String = varNode.getAttributeByName(XML_ATT_VALUE);
					if(varName == IS_TSP){
						if(varValue != null && varValue.toLocaleLowerCase() == "true"){
							isTsp = true;
						}
						else {
							isTsp = false;
						}
					}
					trace(isTsp);
				}
			}
			var roomList:NodeList = node.getNodeList(XML_TAG_ROOM);
			roomHV = new HashVector();
			var roomCards:Sprite = new Sprite();
			var rcBak:MovieClip = SkinsUtil.createSkinByName("MainRoomCardsBak") as MovieClip;
			rcBak.width = 120 + PLACE_SPACE_10;
			rcBak.height = (100 + PLACE_SPACE_10 / 2) * roomList.length() + PLACE_SPACE_10 + PLACE_SPACE_10;
			roomCards.addChild(rcBak);
			
			for(var i:int = 0;i < roomList.length();i ++){
				var roomNode:Node = roomList.getNode(i);
				
				var bgImg:String = roomNode.getAttributeByName(XML_ATT_BGIMG);
				var titleImg:String = roomNode.getAttributeByName(XML_ATT_TITLEIMG);
				var name:String = roomNode.getAttributeByName(XML_ATT_NAME);
				var value:String = roomNode.getAttributeByName(XML_ATT_VALUE);
				var text:String = roomNode.getAttributeByName(XML_ATT_TEXT);
				
				var roomDO:RoomDO = new RoomDO();
				roomDO.bgImgUrl = bgImg;
				roomDO.titleImgUrl = titleImg;
				roomDO.nameStr = name;
				roomDO.valueStr = value;
				roomDO.textStr = text;
				
				var placeHV:HashVector = new HashVector();
				var placeList:NodeList = roomNode.getNodeList(XML_TAG_PLACE);
				for(var j:int = 0;j < placeList.length();j ++){
					var placeNode:Node = placeList.getNode(j);
					var nameStr:String = placeNode.getAttributeByName(XML_ATT_NAME);
					var valueStr:String = placeNode.getAttributeByName(XML_ATT_VALUE);
					var textStr:String = placeNode.getAttributeByName(XML_ATT_TEXT);
					var ballImgUrl:String = placeNode.getAttributeByName(XML_ATT_BALLIMG);
					var frontImgUrl:String = placeNode.getAttributeByName(XML_ATT_FRONTIMG);
					var backImgUrl:String = placeNode.getAttributeByName(XML_ATT_BACKIMG);
					var topImgUrl:String = placeNode.getAttributeByName(XML_ATT_TOPIMG);
					var bottomImgUrl:String = placeNode.getAttributeByName(XML_ATT_BOTTOMIMG);
					var leftImgUrl:String = placeNode.getAttributeByName(XML_ATT_LEFTIMG);
					var rightImgUrl:String = placeNode.getAttributeByName(XML_ATT_RIGHTIMG);
					var xStr:String = placeNode.getAttributeByName(XML_ATT_X);
					var yStr:String = placeNode.getAttributeByName(XML_ATT_Y);
					var p:Point = new Point(Number(xStr),Number(yStr));
					
					trace(ballImgUrl);
					
					var seatDO:SeatDO = new SeatDO();
					seatDO.nameStr = nameStr;
					seatDO.valueStr = valueStr;
					seatDO.textStr = textStr;
					seatDO.ballImageUrl = ballImgUrl;
					seatDO.imageUrlHV.push(frontImgUrl,SeatDO.FRONT);
					seatDO.imageUrlHV.push(backImgUrl,SeatDO.BACK);
					seatDO.imageUrlHV.push(leftImgUrl,SeatDO.LEFT);
					seatDO.imageUrlHV.push(rightImgUrl,SeatDO.RIGHT);
					seatDO.imageUrlHV.push(topImgUrl,SeatDO.TOP);
					seatDO.imageUrlHV.push(bottomImgUrl,SeatDO.BOTTOM);
					seatDO.place = p;
					
					var muralsList:NodeList =placeNode.getNodeList("murals");
					if(muralsList != null && muralsList.length() > 0){
						var muralsNode:Node = muralsList.getNode(0);
						var muralList:NodeList = muralsNode.getNodeList("mural");
						for(var k:int = 0;k < muralList.length();k ++){
							var muralNode:Node = muralList.getNode(k);
							var muralX:Number = Number(muralNode.getAttributeByName("x"));
							var muralY:Number = Number(muralNode.getAttributeByName("y"));
							var muralType:String = String(muralNode.getAttributeByName("type"));
							var muralW:Number = 0;
							if(muralType == SeatDO.RIGHT){
								muralW = 1;
							}
							else if(muralType == SeatDO.BACK){
								muralW = 2;
							}
							else if(muralType == SeatDO.LEFT){
								muralW = 3;
							}
							else{
								muralW = 0;
							}
							
							var muralText:String = String(muralNode.getAttributeByName("text"));
							var muralUrl:String = String(muralNode.getAttributeByName("url"));
							
							var mdo:MuralDO = new MuralDO();
							mdo.x = muralX;
							mdo.y = muralY;
							mdo.type = muralW;
							mdo.text = muralText;;
							mdo.url = muralUrl;
							seatDO.murals.push(mdo);
						}
					}
					
					var seatLinksList:NodeList =placeNode.getNodeList("seatLinks");
					if(seatLinksList != null && seatLinksList.length() > 0){
						var seatLinksNode:Node = seatLinksList.getNode(0);
						var seatLinkList:NodeList = seatLinksNode.getNodeList("seatLink");
						for(var k2:int = 0;k2 < seatLinkList.length();k2 ++){
							var seatLinkNode:Node = seatLinkList.getNode(k2);
							var seatLinkX:Number = Number(seatLinkNode.getAttributeByName("x"));
							var seatLinkY:Number = Number(seatLinkNode.getAttributeByName("y"));
							var seatLinkType:String = String(seatLinkNode.getAttributeByName("type"));
							var seatLinkW:Number = 0;
							if(seatLinkType == SeatDO.RIGHT){
								seatLinkW = 1;
							}
							else if(seatLinkType == SeatDO.BACK){
								seatLinkW = 2;
							}
							else if(seatLinkType == SeatDO.LEFT){
								seatLinkW = 3;
							}
							else{
								seatLinkW = 0;
							}
							var seatLinkName:String = String(seatLinksNode.getAttributeByName("text"));
							 
							var pdo:SeatLinkDO = new SeatLinkDO();
							pdo.x = seatLinkX;
							pdo.y = seatLinkY;
							pdo.type = seatLinkW;
							pdo.name = seatLinkName;;
							seatDO.seatLinks.push(pdo);
						}
					}
					
					var msgList:NodeList =placeNode.getNodeList("msg");
					if(msgList != null && msgList.length() > 0){
						var msgNode:Node = msgList.getNode(0);
						seatDO.msg = msgNode.text;
					}
					placeHV.push(seatDO);
				}
				roomDO.placeHV = placeHV;
				roomHV.push(roomDO);
				
				var roomCard:RoomCard = new RoomCard(roomDO);
				roomCard.width = 120;
				roomCard.height = 100;
				roomCard.x = PLACE_SPACE_10 -2;
				roomCard.y = (100 + PLACE_SPACE_10 / 2) * i + PLACE_SPACE_10;
				
				roomCard.addEventListener(MouseEvent.CLICK,handlerRoomCardMouseClick);
				
				roomCards.addChild(roomCard);
			}
			
			mainLayer.addChild(roomCards);
			
			roomCardsScrollPane = new ScrollPane();
			roomCardsScrollPane.x = ROOM_CARDS_SCROLLPANE_RECT.x;
			roomCardsScrollPane.y = ROOM_CARDS_SCROLLPANE_RECT.y;
			roomCardsScrollPane.width = ROOM_CARDS_SCROLLPANE_RECT.width;
			roomCardsScrollPane.height = ROOM_CARDS_SCROLLPANE_RECT.height;
			roomCardsScrollPane.source = roomCards;
			mainLayer.addChild(roomCardsScrollPane);
			
			
			seat3DBack = SkinsUtil.createSkinByName("Seat3DBack") as MovieClip;
			seat3DBack.visible = false;
			
			mainLayer.addChild(this.roomMapLayer);
			mainLayer.addChild(this.roomLayer);
			mainLayer.addChild(this.roomTextLayer);
			mainLayer.addChild(seat3DBack);
			mainLayer.addChild(this.seat3dLayer);
			mainLayer.addChild(this.seatTextLayer);
			
			seatScrollPane = new ScrollPane();
			seatScrollPane.width = SEAT_SCROLL_PANE_DEFAULT_RECT.width;
			seatScrollPane.height = SEAT_SCROLL_PANE_DEFAULT_RECT.height;
			seatScrollPane.x = SEAT_SCROLL_PANE_DEFAULT_RECT.x;
			seatScrollPane.y = SEAT_SCROLL_PANE_DEFAULT_RECT.y;
			//seatScrollPane.scrollDrag = true;
			mainLayer.addChild(seatScrollPane);
			
			var roomDefault:RoomDO = roomHV.findByIndex(0) as RoomDO;
			refreshRoomMap(roomDefault);
			
			this.menu = new Menu();
			menu.x = MENU_DEFAULT_RECT.x;
			menu.y = MENU_DEFAULT_RECT.y;
			mainLayer.addChild(menu);
			
			mainLayer.addChild(this.seatWindowMsgLayer);
			
			introMsg = new IntroMsg("");
			introMsg.width = SEAT_TITLE_DEFAULT_RECT.width;
			introMsg.height = SEAT_TITLE_DEFAULT_RECT.height;
			introMsg.x = SEAT_TITLE_DEFAULT_RECT.x;
			introMsg.y = SEAT_TITLE_DEFAULT_RECT.y;
			this.seatTextLayer.addChild(introMsg);
			introMsg.drawNow();
			
			windowMsg = new WindowMsg("","");
			windowMsg.visible = false;
			windowMsg.width = 400;
			windowMsg.height = 300;
			this.seatWindowMsgLayer.addChild(windowMsg);
			windowMsg.drawNow();
			
		}
		
		/**
		 * 房间卡片点击事件
		 * @param e
		 * 
		 */		
		private function handlerRoomCardMouseClick(e:Event):void{
			trace("handlerRoomCardMouseClick");
			var roomCard:RoomCard = e.currentTarget as RoomCard;
			refreshRoomMap(roomCard.roomDO); 
			
			
		}
		
		/**
		 * 更新房间显示对象
		 * @param room
		 * 
		 */		
		private function refreshRoomMap(roomDO:RoomDO):void{
			trace("refreshRoomMap");
			
			
			SpriteUtil.deleteAllChild(this.roomTextLayer);
			var tft:TextFormat = new TextFormat();
			tft.size = 18;
			tft.color = 0x19C3F7;
			tft.align = TextFormatAlign.CENTER;
			
			var n:int = int((ROOM_TEXT_RECT.width - 6) * 2 / int(tft.size));
			var txt:String = roomDO.textStr;
			if(StringUtil.getByteLen(txt) > n){
				txt = StringUtil.subCNStr(txt,n - 1)+"...";
			}
			
			var tfd:TextField = Text.creatTextField(txt,tft,false);
			tfd.x = ROOM_TEXT_RECT.x;
			tfd.y = ROOM_TEXT_RECT.y;
			tfd.width = ROOM_TEXT_RECT.width;
			this.roomTextLayer.addChild(tfd);
			
			SpriteUtil.deleteAllChild(roomMapLayer);
			roomMap = new RoomMap(roomDO);
			roomMapLayer.addChild(roomMap);
			roomMap.addEventListener(RoomMap.EVENT_ROOM_MAP_COMPLETE,handlerLoadBigImgCmp);
			roomMap.addEventListener(RoomMap.EVENT_SEAT_POINT_MOUSE_CLICK,handlerSeatClick);
			roomMap.addEventListener(RoomMap.EVENT_VISUAL_ANGLE_ROTATE,handlerVisualAngleRotate);
		}
		
		private function handlerVisualAngleRotate(e:Event):void{
			currentSeat3D.setCameraRotation(roomMap.getVisualAngleRotation());
		}
		
		/**
		 * 房间内观察点点击事件
		 * @param e
		 * 
		 */		
		private function handlerSeatClick(e:Event):void{
			trace("handlerSeatClick");
			var roomMap:RoomMap = e.currentTarget as RoomMap;
			creatSeat3D(roomMap);
		}
		
		/**
		 * 创建观察点的3d全景显示
		 * @param roomMap
		 * 
		 */		
		private function creatSeat3D(roomMap:RoomMap):void{
			if(creatSeat3DSign){
				creatSeat3DSign = false;
				trace("creatSeat3D");
				if(currentSeat3D != null){
					currentSeat3D.removeEventListener(Seat3D.CAMERA_ROTATION_EVENT,handlerCameraRotation);
					currentSeat3D.removeEventListener(MouseEvent.DOUBLE_CLICK,handlerCurrentSeat3DMouseDoubleClick);
				}
				SpriteUtil.deleteAllChild(this.seat3dLayer);
				System.gc();
				currentSeatDO = roomMap.currentSeatDO;
				var s3d:Seat3D = new Seat3D(this.menu,currentSeatDO,SEAT3D_DEFAULT_RECT.width,SEAT3D_DEFAULT_RECT.height);
				s3d.addEventListener(Seat3D.CAMERA_ROTATION_EVENT,handlerCameraRotation);
				s3d.addEventListener(MouseEvent.DOUBLE_CLICK,handlerCurrentSeat3DMouseDoubleClick);
				s3d.doubleClickEnabled = true;
				s3d.addEventListener(Seat3D.SEAT3D_CMP_EVENT,handlerSeat3DCmp);
				s3d.addEventListener(Seat3D.MURAL_CLICK,handlerMuralClick);
				s3d.addEventListener(Seat3D.SEAT_LINK_CLICK,handlerSeatLinkClick);
				s3d.x = SEAT3D_DEFAULT_RECT.x;
				s3d.y = SEAT3D_DEFAULT_RECT.y;
				currentSeat3D = s3d;
				this.seat3dLayer.addChild(s3d);
				
				this.roomMap.setVisualAngleRotation(0);
				
				introMsg.refreshText(currentSeatDO.textStr);
				windowMsg.visible = false;
				introMsg.removeEventListener(IntroMsg.BUTTON_CLICK,handlerIntroMsgBtnClick);
				if(currentSeatDO.textStr != null && currentSeatDO.textStr.length > 0 && currentSeatDO.msg != null && currentSeatDO.msg.length > 0){
					trace("addEventListener");
					introMsg.addEventListener(IntroMsg.BUTTON_CLICK,handlerIntroMsgBtnClick);	
				}
				creatSeat3DSign = true;
				trace("this.seat3dLayer.numChildren",this.seat3dLayer.numChildren);
			}
		}
		
		private function handlerMuralClick(e:Event):void{
			trace("handlerMuralClick");
		}
		
		private function handlerSeatLinkClick(e:Event):void{
			trace("handlerSeatLinkClick");
		}
		
		private function handlerIntroMsgBtnClick(e:Event):void{
			trace("handlerIntroMsgBtnClick");
			windowMsg.visible = true;
			windowMsg.refreshText(currentSeatDO.textStr,currentSeatDO.msg);
			windowMsg.resetPlaceAndMask(stage);
		}
		
		/**
		 * 3D全景对象初始化完成 
		 * @param e
		 * 
		 */		
		private function handlerSeat3DCmp(e:Event):void{
			if(this.visible){
				setMainDisplayState();
			}
		}
		
		/**
		 * 3D全景对象鼠标双击全屏/退出全屏事件 
		 * @param e
		 * 
		 */		
		private function handlerCurrentSeat3DMouseDoubleClick(e:Event):void{
			if(!isTsp){
				if(stage.displayState != StageDisplayState.FULL_SCREEN){
					stage.displayState = StageDisplayState.FULL_SCREEN;
				}
				else {
					stage.displayState = StageDisplayState.NORMAL;
				}
			}
		}
		
		/**
		 * 设置场景中显示对象的状态及显示属性
		 * 
		 */		
		private function setMainDisplayState():void{
			if(currentStageDisplayStateSign){
				trace("setMainDisplayState");
				currentStageDisplayStateSign = false;
				
				var seat3DFullScreenRect:Rectangle = new Rectangle();
				
				//				if(isTsp){
				//					seat3DFullScreenRect.x = SEAT3D_DEFAULT_RECT.x;
				//					seat3DFullScreenRect.y = SEAT3D_DEFAULT_RECT.y;
				//				}
				
				if(stage.displayState == StageDisplayState.FULL_SCREEN && !isTsp){
					seat3DBack.visible = true;
					seat3DBack.width = stage.fullScreenWidth - seat3DFullScreenRect.x;
					seat3DBack.height = stage.fullScreenHeight;
					seat3DBack.x = seat3DFullScreenRect.x;
					seat3DBack.y = seat3DFullScreenRect.y;
					
					if(currentSeat3D != null){						
						var scaleX:Number = (stage.fullScreenWidth - seat3DFullScreenRect.x) / SEAT3D_DEFAULT_RECT.width;
						var scaleY:Number = (stage.fullScreenHeight - seat3DFullScreenRect.y) / SEAT3D_DEFAULT_RECT.height;
						
						var scale:Number = scaleX > scaleY ? scaleY:scaleX;
						
						seat3DFullScreenRect.width = SEAT3D_DEFAULT_RECT.width;
						seat3DFullScreenRect.height = SEAT3D_DEFAULT_RECT.height;
						
						if(scale == scaleY){
							seat3DFullScreenRect.width = (stage.fullScreenWidth - seat3DFullScreenRect.x) / scale;
						}
						else if(scale == scaleX){
							seat3DFullScreenRect.height = (stage.fullScreenHeight - seat3DFullScreenRect.y) / scale;
						}
						
						currentSeat3D.setViewport3DSize(scale,scale,seat3DFullScreenRect.width,seat3DFullScreenRect.height);
						currentSeat3D.x = seat3DFullScreenRect.x;
						currentSeat3D.y = seat3DFullScreenRect.y;
						
						menu.x = (stage.fullScreenWidth - menu.getRect(this).width) / 2;
						menu.y = stage.fullScreenHeight - menu.getRect(this).height - PLACE_SPACE_10;
						
						seatScrollPane.x = stage.fullScreenWidth - SEAT_SCROLL_PANE_DEFAULT_RECT.width - PLACE_SPACE_10;
						seatScrollPane.y = PLACE_SPACE_10;
						
						introMsg.x = SEAT_TITLE_FULL_SCREEN_RECT.x;
						introMsg.y = SEAT_TITLE_FULL_SCREEN_RECT.y;
						
						//						if(isTsp){
						//							roomCardsScrollPane.height = stage.fullScreenHeight - PLACE_SPACE_10 - PLACE_SPACE_10;
						//						}
						
						if(bakMC != null){
							bakMC.visible = false;
						}
					}
				}
				else {
					seat3DBack.visible = false;
					if(currentSeat3D != null){
						currentSeat3D.setViewport3DSize(1,1,SEAT3D_DEFAULT_RECT.width,SEAT3D_DEFAULT_RECT.height);
						currentSeat3D.x = SEAT3D_DEFAULT_RECT.x;
						currentSeat3D.y = SEAT3D_DEFAULT_RECT.y;
						
						menu.x = MENU_DEFAULT_RECT.x;
						menu.y = MENU_DEFAULT_RECT.y;
						
						seatScrollPane.x = SEAT_SCROLL_PANE_DEFAULT_RECT.x;
						seatScrollPane.y = SEAT_SCROLL_PANE_DEFAULT_RECT.y;
						introMsg.x = SEAT_TITLE_DEFAULT_RECT.x;
						introMsg.y = SEAT_TITLE_DEFAULT_RECT.y;
						
						//						if(isTsp){
						//							roomCardsScrollPane.height = ROOM_CARDS_SCROLLPANE_RECT.height;
						//						}
						
						if(bakMC != null){
							bakMC.visible = true;
						}
					}
				}
				currentStageDisplayStateSign = true;
			}
			
		}
		
		/**
		 * 3D全景对象，摄像机旋转事件
		 * @param e
		 * 
		 */		
		private function handlerCameraRotation(e:Event):void{
			var s3d:Seat3D = e.currentTarget as Seat3D;
			this.roomMap.setVisualAngleRotation(s3d.cameraRotationY);
		}
		
		/**
		 * 房间平面图加载完成事件
		 * @param e
		 * 
		 */		
		private function handlerLoadBigImgCmp(e:Event):void{
			trace("handlerLoadBigImgCmp");
			var roomMap:RoomMap = e.currentTarget as RoomMap;
			var rcBak:MovieClip = SkinsUtil.createSkinByName("MainRoomCardsBak") as MovieClip;
			var rect:Rectangle = roomMap.getRect(roomMapLayer);
			rcBak.width = rect.width + PLACE_SPACE_2;
			rcBak.height = rect.height + PLACE_SPACE_2;
			roomMap.x = PLACE_SPACE_2;
			roomMap.y = PLACE_SPACE_2;
			roomMapLayer.addChild(rcBak);
			roomMapLayer.swapChildren(roomMap,rcBak);
			
			var hsp:Number = 0;
			var vsp:Number = 0;
			
			seatScrollPane.source= roomMapLayer;
			if(roomMap.room != null && roomMap.room.placeHV != null){
				var firstSeatDO:SeatDO = roomMap.room.placeHV.findByIndex(0) as SeatDO;
				hsp = firstSeatDO.place.x - seatScrollPane.width / 2;
				vsp = firstSeatDO.place.y - seatScrollPane.height / 2;
				if(hsp > seatScrollPane.maxHorizontalScrollPosition){
					hsp = seatScrollPane.maxHorizontalScrollPosition;
				}
				else if(hsp < 0){
					hsp = 0;
				}
				if(vsp > seatScrollPane.maxVerticalScrollPosition){
					vsp = seatScrollPane.maxVerticalScrollPosition;
				}
				else if(vsp < 0){
					vsp = 0;
				}
			}
			seatScrollPane.horizontalScrollPosition = hsp;
			seatScrollPane.verticalScrollPosition = vsp;
			seatScrollPane.update();
			
			creatSeat3D(roomMap);
		}
		
	}
}