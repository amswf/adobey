package com.snsoft.room3d{
	import com.snsoft.util.HashVector;
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.SpriteUtil;
	import com.snsoft.xmldom.Node;
	import com.snsoft.xmldom.NodeList;
	
	import fl.containers.ScrollPane;
	
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
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	public class Main extends MovieClip{
		
		private var dataUrl:String = "data.xml";
		
		private var xmlLoader:XMLLoader; 
		
		private var roomHV:HashVector;
		
		private static const XML_TAG_ROOM:String = "room";
		
		private static const XML_TAG_PLACE:String = "place";
		
		private static const XML_ATT_BGIMG:String = "bgImg";
		
		private static const XML_ATT_TITLEIMG:String = "titleImg";
		
		private static const XML_ATT_NAME:String = "name";
		
		private static const XML_ATT_VALUE:String = "value";
		
		private static const XML_ATT_TEXT:String = "text";
		
		private static const XML_ATT_X:String = "x";
		
		private static const XML_ATT_Y:String = "y";
		
		private static const XML_ATT_BALLIMG:String = "ballImg";
		
		private static const XML_ATT_FRONTIMG:String = "frontImg";
		
		private static const XML_ATT_BACKIMG:String = "backImg";
		
		private static const XML_ATT_TOPIMG:String = "topImg";
		
		private static const XML_ATT_BOTTOMIMG:String = "bottomImg";
		
		private static const XML_ATT_LEFTIMG:String = "leftImg";
		
		private static const XML_ATT_RIGHTIMG:String = "rightImg";
		
		private static const placeSpace:Number = 10;
		
		private var roomMapLayer:MovieClip = new MovieClip();
		
		private var roomLayer:MovieClip = new MovieClip();
		
		private var roomTextLayer:MovieClip = new MovieClip();
		
		private var seat3dLayer:MovieClip = new MovieClip();
		
		private var seatScrollPane:ScrollPane;
		
		private static const SEAT_SCROLL_PANE_DEFAULT_RECT:Rectangle = new Rectangle(630,20,260,300);
		
		private var menu:Menu;
		
		private static const MENU_DEFAULT_RECT:Rectangle = new Rectangle(630,320);
		
		private var roomMap:RoomMap;
		
		private var currentSeat3D:Seat3D;
		
		private var seat3DBack:MovieClip;
		
		private static const SEAT3D_DEFAULT_RECT:Rectangle = new Rectangle(170,20,450,460);
		
		private var currentStageDisplayStateSign:Boolean = true;
		
		private var isStageResize:Boolean = false;
		
		public function Main(){
			super();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			this.addEventListener(Event.ENTER_FRAME,handlerEnterFrame);
			
		}
		
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
		
		private function handlerStageResize(e:Event):void{
			trace("handlerStageResize",stage.stageHeight,stage.stageWidth);
			setMainDisplayState();
		}
		
		private function loadXML():void{
			xmlLoader = new XMLLoader(dataUrl);
			xmlLoader.addEventListener(Event.COMPLETE,handlerLoadXMLCmp);
			xmlLoader.loadXML();
		}
		
		private function handlerLoadXMLCmp(e:Event):void{
			initData();
		}
		
		private function initData():void{
			var node:Node = xmlLoader.xmlNode;
			var roomList:NodeList = node.getNodeList(XML_TAG_ROOM);
			roomHV = new HashVector();
			var roomCards:Sprite = new Sprite();
			var rcBak:MovieClip = SkinsUtil.createSkinByName("MainRoomCardsBak") as MovieClip;
			rcBak.width = 120 + placeSpace;
			rcBak.height = (100 + placeSpace / 2) * roomList.length() + placeSpace + placeSpace;
			roomCards.addChild(rcBak);
			
			for(var i:int = 0;i < roomList.length();i ++){
				var roomNode:Node = roomList.getNode(i);
				
				var bgImg:String = roomNode.getAttributeByName(XML_ATT_BGIMG);
				var titleImg:String = roomNode.getAttributeByName(XML_ATT_TITLEIMG);
				var name:String = roomNode.getAttributeByName(XML_ATT_NAME);
				var value:String = roomNode.getAttributeByName(XML_ATT_VALUE);
				var text:String = roomNode.getAttributeByName(XML_ATT_TEXT);
				
				var room:RoomDO = new RoomDO();
				room.bgImgUrl = bgImg;
				room.titleImgUrl = titleImg;
				room.nameStr = name;
				room.valueStr = value;
				room.textStr = text;
				
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
					placeHV.push(seatDO);
				}
				room.placeHV = placeHV;
				roomHV.push(room);
				
				var roomCard:RoomCard = new RoomCard(room);
				roomCard.width = 120;
				roomCard.height = 100;
				roomCard.x = placeSpace;
				roomCard.y = (100 + placeSpace / 2) * i + placeSpace;
				
				roomCard.addEventListener(MouseEvent.CLICK,handlerRoomCardMouseClick);
				
				roomCards.addChild(roomCard);
			}
			
			this.addChild(roomCards);
			
			var scrollPane:ScrollPane = new ScrollPane();
			scrollPane.x = placeSpace;
			scrollPane.y = placeSpace * 2;
			scrollPane.width = 150;
			scrollPane.height = 460;
			scrollPane.source = roomCards;
			this.addChild(scrollPane);
			
			
			seat3DBack = SkinsUtil.createSkinByName("Seat3DBack") as MovieClip;
			seat3DBack.visible = false;
			
			this.addChild(this.roomMapLayer);
			this.addChild(this.roomLayer);
			this.addChild(seat3DBack);
			this.addChild(this.seat3dLayer);
			this.addChild(this.roomTextLayer);
			
			seatScrollPane = new ScrollPane();
			seatScrollPane.width = SEAT_SCROLL_PANE_DEFAULT_RECT.width;
			seatScrollPane.height = SEAT_SCROLL_PANE_DEFAULT_RECT.height;
			seatScrollPane.x = SEAT_SCROLL_PANE_DEFAULT_RECT.x;
			seatScrollPane.y = SEAT_SCROLL_PANE_DEFAULT_RECT.y;
			seatScrollPane.scrollDrag = true;
			this.addChild(seatScrollPane);
			
			var roomDefault:RoomDO = roomHV.findByIndex(0) as RoomDO;
			refreshRoomMap(roomDefault);
			
			this.menu = new Menu();
			menu.x = MENU_DEFAULT_RECT.x;
			menu.y = MENU_DEFAULT_RECT.y;
			this.addChild(menu);
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerRoomCardMouseClick(e:Event):void{
			trace("handlerRoomCardMouseClick");
			var roomCard:RoomCard = e.currentTarget as RoomCard;
			refreshRoomMap(roomCard.roomDO); 
		}
		
		/**
		 * 
		 * @param room
		 * 
		 */		
		private function refreshRoomMap(room:RoomDO):void{
			trace("refreshRoomMap");
			SpriteUtil.deleteAllChild(roomMapLayer);
			
			roomMap = new RoomMap(room);
			
			roomMapLayer.addChild(roomMap);
			
			roomMap.addEventListener(RoomMap.EVENT_ROOM_MAP_COMPLETE,handlerLoadBigImgCmp);
			roomMap.addEventListener(RoomMap.EVENT_SEAT_POINT_MOUSE_CLICK,handlerSeatClick);
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerSeatClick(e:Event):void{
			trace("handlerSeatClick");
			var roomMap:RoomMap = e.currentTarget as RoomMap;
			creatSeat3D(roomMap);
		}
		
		/**
		 * 
		 * @param roomMap
		 * 
		 */		
		private function creatSeat3D(roomMap:RoomMap):void{
			trace("creatSeat3D");
			if(currentSeat3D != null){
				currentSeat3D.removeEventListener(Seat3D.CAMERA_ROTATION_EVENT,handlerCameraRotation);
				currentSeat3D.removeEventListener(MouseEvent.DOUBLE_CLICK,handlerCurrentSeatDOMouseDoubleClick);
			}
			SpriteUtil.deleteAllChild(this.seat3dLayer);
			
			var seatDO:SeatDO = roomMap.currentSeatDO;
			var s3d:Seat3D = new Seat3D(this.menu,roomMap.currentSeatDO,SEAT3D_DEFAULT_RECT.width,SEAT3D_DEFAULT_RECT.width);
			s3d.x = SEAT3D_DEFAULT_RECT.x;
			s3d.y = SEAT3D_DEFAULT_RECT.y;
			currentSeat3D = s3d;
			this.seat3dLayer.addChild(s3d);
			s3d.drawNow();
			this.roomMap.setVisualAngleRotation(0);
			s3d.addEventListener(Seat3D.CAMERA_ROTATION_EVENT,handlerCameraRotation);
			s3d.addEventListener(MouseEvent.DOUBLE_CLICK,handlerCurrentSeatDOMouseDoubleClick);
			s3d.doubleClickEnabled = true;
			s3d.addEventListener(Seat3D.SEAT3D_CMP_EVENT,handlerSeat3DCmp);
		}
		
		private function handlerSeat3DCmp(e:Event):void{
			setMainDisplayState();
		}
		
		private function handlerCurrentSeatDOMouseDoubleClick(e:Event):void{
			if(stage.displayState != StageDisplayState.FULL_SCREEN){
				stage.displayState = StageDisplayState.FULL_SCREEN;
			}
			else {
				stage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		private function setMainDisplayState():void{
			if(currentStageDisplayStateSign){
				trace("setMainDisplayState");
				currentStageDisplayStateSign = false;
				
				if(stage.displayState == StageDisplayState.FULL_SCREEN){
					seat3DBack.visible = true;
					seat3DBack.width = stage.fullScreenWidth;
					seat3DBack.height = stage.fullScreenHeight;
					
					if(currentSeat3D != null){						
						var scaleX:Number = stage.fullScreenWidth / SEAT3D_DEFAULT_RECT.width;
						var scaleY:Number = stage.fullScreenHeight / SEAT3D_DEFAULT_RECT.height;
						
						var scale:Number = scaleX > scaleY ? scaleY:scaleX;
						
						
						var viewportWidth:Number = SEAT3D_DEFAULT_RECT.width;
						var viewportHeight:Number = SEAT3D_DEFAULT_RECT.height;
						if(scale == scaleY){
							viewportWidth = stage.fullScreenWidth / scale;
						}
						else if(scale == scaleX){
							viewportHeight = stage.fullScreenHeight / scale;
						}
						
						currentSeat3D.setViewport3DSize(scale,scale,viewportWidth,viewportHeight);
						currentSeat3D.x = 0;
						currentSeat3D.y = 0;
						
						menu.x = (stage.fullScreenWidth - menu.getRect(this).width) / 2;
						menu.y = stage.fullScreenHeight - menu.getRect(this).height - placeSpace;
						
						seatScrollPane.x = stage.fullScreenWidth - SEAT_SCROLL_PANE_DEFAULT_RECT.width - placeSpace;
						seatScrollPane.y = placeSpace;
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
					}
				}
				
				
				
				currentStageDisplayStateSign = true;
			}
			
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerCameraRotation(e:Event):void{
			var s3d:Seat3D = e.currentTarget as Seat3D;
			this.roomMap.setVisualAngleRotation(s3d.cameraRotationY);
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerLoadBigImgCmp(e:Event):void{
			trace("handlerLoadBigImgCmp");
			var roomMap:RoomMap = e.currentTarget as RoomMap;
			var rcBak:MovieClip = SkinsUtil.createSkinByName("MainRoomCardsBak") as MovieClip;
			var rect:Rectangle = roomMap.getRect(roomMapLayer);
			roomMapLayer.addChild(rcBak);
			roomMapLayer.swapChildren(roomMap,rcBak);
			seatScrollPane.source= roomMapLayer;
			seatScrollPane.horizontalScrollPosition = 0;
			seatScrollPane.verticalScrollPosition = 0;
			seatScrollPane.update();
			
			creatSeat3D(roomMap);
		}
		
	}
}