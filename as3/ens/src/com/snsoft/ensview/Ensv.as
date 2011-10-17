package com.snsoft.ensview {
	import ascb.util.StringUtilities;

	import com.snsoft.mapview.AreaNameView;
	import com.snsoft.mapview.dataObj.MapAreaDO;
	import com.snsoft.mapview.dataObj.WorkSpaceDO;
	import com.snsoft.mapview.util.MapViewXMLLoader;
	import com.snsoft.util.HashVector;
	import com.snsoft.util.Math.Polar;
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.SpriteUtil;
	import com.snsoft.util.complexEvent.CplxMouseDrag;
	import com.snsoft.util.rlm.ResLoadManager;
	import com.snsoft.util.rlm.rs.RSTextFile;
	import com.snsoft.util.xmldom.Node;
	import com.snsoft.util.xmldom.NodeList;
	import com.snsoft.util.xmldom.XMLDom;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class Ensv extends MovieClip {

		public static const EVENT_BTN:String = "EVENT_BTN";

		public static const BTN_TYPE_BACK:String = "back";

		private var btnType:String;

		private var boader:int = 10;

		private var rsxml:RSTextFile;

		private var boothMsgXMLUrl:String = "boothMsg.xml";

		private var mapXMLUrl:String = "flash_map/1x/ws_1.xml";

		private var boothDOs:Vector.<EnsvBoothDO> = new Vector.<EnsvBoothDO>();

		private var wayfvv:Vector.<Vector.<Boolean>> = new Vector.<Vector.<Boolean>>();

		private var booths:Vector.<EnsvBooth> = new Vector.<EnsvBooth>();

		private var boothClickLock:Boolean = false;

		private var wayLayer:Sprite = new Sprite();

		private var pathLayer:Sprite = new Sprite();

		private var mapLayer:Sprite = new Sprite();

		private var boothsLayer:Sprite = new Sprite();

		private var cardLayer:Sprite = new Sprite();

		private var dragLayer:Sprite = new Sprite();

		private var dragLimitLayer:Sprite = new Sprite();

		private var dragLimit:Sprite = new Sprite();

		private var viewLayer:Sprite = new Sprite();

		private var viewDrag:Sprite = new Sprite();

		private var searchLayer:Sprite = new Sprite();

		private var searchListLayer:Sprite = new Sprite();

		private var boothMsgLayer:Sprite = new Sprite();

		private var btnsLayer:Sprite = new Sprite();

		private var currentPosition:Point = new Point();

		private var stageWidth:int = 0;

		private var stageHeight:int = 0;

		private var ensvBoothMsgDOHV:HashVector = new HashVector();

		private var searchBooths:Vector.<EnsvBooth>;

		private var mapPathManager:MapPathManager = null;

		private var mapView:MapView = null;

		public function Ensv(stageWidth:int, stageHeight:int) {
			super();
			this.stageWidth = stageWidth;
			this.stageHeight = stageHeight;

			this.addChild(dragLayer);
			dragLayer.addChild(mapLayer);
			dragLayer.addChild(wayLayer);
			wayLayer.mouseEnabled = false;
			wayLayer.mouseChildren = false;
			dragLayer.addChild(cardLayer);
			cardLayer.mouseChildren = false;
			cardLayer.mouseEnabled = false;
			this.addChild(viewLayer);
			viewLayer.mouseEnabled = false;
			viewLayer.mouseChildren = false;
			this.addEventListener(Event.ENTER_FRAME, handlerEnterFrame);

			this.addChild(searchLayer);
			searchLayer.x = stageWidth - 510;
			searchLayer.y = 80;

			this.addChild(searchListLayer);
			searchListLayer.x = stageWidth - 290;
			searchListLayer.y = 120;

			this.addChild(btnsLayer);

			this.addChild(boothMsgLayer);

			wayLayer.addChild(pathLayer);
		}

		public function getBtnType():String {
			return btnType;
		}

		private function handlerEnterFrame(e:Event):void {
			this.removeEventListener(Event.ENTER_FRAME, handlerEnterFrame);
			init();
		}

		private function init():void {
			var backBtn:MovieClip = SkinsUtil.createSkinByName("BackBtn");
			backBtn.x = stage.stageWidth - backBtn.width - 50;
			backBtn.y = 0;
			backBtn.buttonMode = true;
			btnsLayer.addChild(backBtn);
			backBtn.addEventListener(MouseEvent.CLICK, handlerBackBtnClick);

			//stage.addEventListener(Event.RESIZE, handlerStageResize);
			loadXML();
		}

		private function handlerBackBtnClick(e:Event):void {
			this.btnType = BTN_TYPE_BACK;
			this.dispatchEvent(new Event(EVENT_BTN));
		}

		private function loadXML():void {
			rsxml = new RSTextFile();
			rsxml.addResUrl(boothMsgXMLUrl);
			rsxml.addResUrl(mapXMLUrl);

			var rsm:ResLoadManager = new ResLoadManager();
			rsm.addResSet(rsxml);
			rsm.addEventListener(Event.COMPLETE, handlerLoadXMLCmp);
			rsm.load();
		}

		private function handlerLoadXMLCmp(e:Event):void {
			parseBoothMsg();
			parseMapMsg();
		}

		private function parseBoothMsg():void {
			var xmlStr:String = rsxml.getTextByUrl(boothMsgXMLUrl);
			var xml:XML = new XML(xmlStr);
			var xdom:XMLDom = new XMLDom(xml);
			var node:Node = xdom.parse();
			var recordNodeList:NodeList = node.getNodeList("record");
			for (var i:int = 0; i < recordNodeList.length(); i++) {
				var rNode:Node = recordNodeList.getNode(i);
				var ebmdo:EnsvBoothMsgDO = new EnsvBoothMsgDO();
				rNode.attrToObj(ebmdo);
				rNode.childNodeTextTObj(ebmdo);
				ensvBoothMsgDOHV.push(ebmdo, ebmdo.id);
			}
		}

		private function parseMapMsg():void {
			var xmlStr:String = rsxml.getTextByUrl(mapXMLUrl);
			var xml:XML = new XML(xmlStr);
			var wsdo:WorkSpaceDO = MapViewXMLLoader.creatWorkSpaceDO(xml, this.mapXMLUrl);

			initMap(wsdo);
			initSearch();
			stateResizeSetState();
		}

		private function initSearch():void {
			var sb:SearchBar = new SearchBar();
			searchLayer.addChild(sb);
			sb.addEventListener(SearchBar.EVENT_VIEW_LIST, handlerSearchList);
			sb.addEventListener(SearchBar.EVENT_SEARCH, handlerSearch);
		}

		private function handlerSearch(e:Event):void {
			SpriteUtil.deleteAllChild(searchListLayer);
			searchListLayer.visible = true;

			var sb:SearchBar = e.currentTarget as SearchBar;
			var stext:String = sb.searchText;

			var searchListHeight:int = 0;
			var searchListItemLayer:Sprite = new Sprite();
			var n:int = 0;
			if (stext != null) {
				stext = StringUtilities.trim(stext);
				if (stext.length > 0) {
					for (var i:int = 0; i < ensvBoothMsgDOHV.length; i++) {
						var msg:EnsvBoothMsgDO = ensvBoothMsgDOHV.findByIndex(i) as EnsvBoothMsgDO;
						if (msg != null) {
							if ((msg.name != null && msg.name.indexOf(stext) >= 0) || (msg.des != null && msg.des.indexOf(stext) >= 0)) {
								var eli:EnsvListItem = new EnsvListItem(msg.name);

								eli.id = msg.id;
								eli.y = eli.height * n;
								eli.addEventListener(MouseEvent.CLICK, handlerEnsvListItemClick);
								searchListHeight += eli.height;
								searchListItemLayer.addChild(eli);
								n++;
							}
						}
					}
				}
			}

			if (n > 0) {
				var barh:int = viewLayer.y - searchListLayer.y - 20;

				searchListLayer.addChild(searchListItemLayer);

				var msk:MovieClip = new MovieClip();
				msk.graphics.beginFill(0x000000, 1);
				msk.graphics.drawRect(-16, -1, 226, barh + 2);
				msk.graphics.endFill();
				searchListLayer.addChild(msk);
				searchListItemLayer.mask = msk;

				if (barh <= searchListHeight) {
					var sbar:ScrollBar = new ScrollBar(barh, searchListHeight);
					sbar.x = 210;
					searchListLayer.addChild(sbar);
					sbar.addEventListener(ScrollBar.EVENT_SCROLLING, function():void {searchListItemLayer.y = -int(searchListHeight - barh) * sbar.getScrollValue()});
				}
			}
		}

		private function handlerEnsvListItemClick(e:Event):void {
			var eli:EnsvListItem = e.currentTarget as EnsvListItem;
			var anv:AreaNameView = mapView.areaNameViewHV.findByName(eli.id) as AreaNameView;
			if (anv != null) {
				anv.dispatchEvent(new Event(MouseEvent.CLICK));
				anv.dispatchEvent(new Event(MouseEvent.DOUBLE_CLICK));
			}
		}

		private function viewEnsvBoothMsg(booth:EnsvBooth):void {
			if (booth != null && booth.ensvBoothDO != null && booth.ensvBoothDO.msg != null) {
				SpriteUtil.deleteAllChild(boothMsgLayer);

				var msk:MovieClip = new MovieClip();
				msk.graphics.beginFill(0x000000, 0.1);
				msk.graphics.drawRect(0, 0, stageWidth, stageHeight);
				msk.graphics.endFill();
				boothMsgLayer.addChild(msk);

				var msg:EnsvBoothMsgDO = booth.ensvBoothDO.msg;
				var ebm:EnsvBoothMsg = new EnsvBoothMsg(msg);
				ebm.x = (stageWidth - ebm.width) / 2;
				ebm.y = (stageHeight - ebm.height) / 2;
				boothMsgLayer.addChild(ebm);
				ebm.addEventListener(EnsvBoothMsg.EVENT_CLOSE, function():void {SpriteUtil.deleteAllChild(boothMsgLayer);});
			}
		}

		private function handlerSearchList(e:Event):void {
			var sb:SearchBar = e.currentTarget as SearchBar;
			searchListLayer.visible = !searchListLayer.visible;
		}

		private function initMap(wsdo:WorkSpaceDO):void {

			mapView = new MapView();
			mapView.workSpaceDO = wsdo;
			mapView.drawNow();
			boothsLayer.addChild(mapView);
			mapView.addEventListener(MapView.AREA_CLICK_EVENT, handlerAreaClick);
			mapView.addEventListener(MapView.AREA_DOUBLE_CLICK_EVENT, handlerAreaDoubleClick);
			mapView.addEventListener(MapView.AREA_MOUSE_OUT_EVENT, handlerAreaMouseOut);
			mapView.addEventListener(MapView.AREA_MOUSE_OVER_EVENT, handlerAreaMouseOver);

			var areaCode:String = mapView.currentPositionAreaView.mapAreaDO.areaId;
			currentPosition.x = mapView.currentPositionAreaView.center.x;
			currentPosition.y = mapView.currentPositionAreaView.center.y;

			mapPathManager = new MapPathManager(wsdo.sections, areaCode);

			var maprect:Rectangle = mapView.getRect(boothsLayer);

			var back:Sprite = new Sprite();
			back.graphics.lineStyle(2, 0x000000, 1);
			back.graphics.beginFill(0xfffffff, 1);
			back.graphics.drawRect(0, 0, maprect.width + maprect.x + boader, maprect.height + maprect.y + boader);
			back.graphics.endFill();
			mapLayer.addChild(back);
			mapLayer.addChild(boothsLayer);

			dragLimit = new Sprite();
			dragLimit.graphics.beginFill(0x000000, 0);
			dragLimit.graphics.drawRect(0, 0, stageWidth, stageHeight);
			dragLimit.graphics.endFill();
			dragLimitLayer.addChild(dragLimit);

			var vl:Sprite = new Sprite();
			vl.graphics.beginFill(0x000000, 0.1);
			vl.graphics.drawRect(0, 0, 200, 150);
			vl.graphics.endFill();
			viewLayer.addChild(vl);

			var wp:MovieClip = SkinsUtil.createSkinByName("SmallCurrentPosition");

			var wpw:int = wp.width;
			var wph:int = wp.height;
			trace(vl.width, maprect.width, currentPosition.x);
			var wpx:int = vl.width * currentPosition.x / (maprect.width + maprect.x);
			var wpy:int = vl.height * currentPosition.y / (maprect.height + maprect.y);

			if (wpx > vl.width - wpw) {
				wpx = vl.width - wpw;
			}
			else if (wpx < 0) {
				wpx = 0;
			}
			if (wpy > vl.height - wph) {
				wpy = vl.height - wph;
			}
			else if (wpy < 0) {
				wpy = 0;
			}
			wp.x = wpx;
			wp.y = wpy;

			viewLayer.addChild(wp);

			viewDrag = new Sprite();
			viewDrag.graphics.beginFill(0x000000, 0.1);
			viewDrag.graphics.drawRect(0, 0, 100, 75);
			viewDrag.graphics.endFill();
			viewLayer.addChild(viewDrag);

			var cmd:CplxMouseDrag = new CplxMouseDrag();
			cmd.addEvents(dragLayer, dragLimit, viewDrag, vl);
			cmd.addEventListener(CplxMouseDrag.DRAG_MOVE_EVENT, handlerCplxDragMove);
			cmd.addEventListener(CplxMouseDrag.DRAG_COMPLETE_EVENT, handlerCplxDragCmp);

			var cp:MovieClip = SkinsUtil.createSkinByName("SmallCurrentPosition");
			cp.x = currentPosition.x - cp.width / 2;
			cp.y = currentPosition.y - cp.height / 2;
			wayLayer.addChild(cp);
		}

		private function handlerAreaClick(e:Event):void {
			var mapView:MapView = e.currentTarget as MapView;
			var areaView:AreaNameView = mapView.currentAreaView;
			var areaDO:MapAreaDO = areaView.mapAreaDO;

			var points:Vector.<Point> = mapPathManager.findPath(areaDO.areaId);

			SpriteUtil.deleteAllChild(pathLayer);
			if (points != null) {
				if (points.length >= 2) {
					for (var i:int = 0; i < points.length - 1; i++) {
						var p1:Point = points[i];
						var p2:Point = points[i + 1];
						var sp:Point = p2.subtract(p1);
						var po:Polar = Polar.point(sp.x, sp.y);
						var w:int = 30;
						var len:int = 0;
						while (len + 15 < po.len) {
							var mc:MovieClip = SkinsUtil.createSkinByName("FootO");
							var p:Point = Point.polar(len, po.angle);
							var np:Point = p1.add(p);
							mc.x = np.x;
							mc.y = np.y;
							mc.rotation = po.rotation;
							pathLayer.addChild(mc);
							len += w;
						}

					}
				}
			}
		}

		private function handlerAreaDoubleClick(e:Event):void {
			SpriteUtil.deleteAllChild(boothMsgLayer);
			var mapView:MapView = e.currentTarget as MapView;
			var areaView:AreaNameView = mapView.currentAreaView;
			var areaDO:MapAreaDO = areaView.mapAreaDO;
			var msg:EnsvBoothMsgDO = ensvBoothMsgDOHV.findByName(areaDO.areaCode) as EnsvBoothMsgDO;
			if (msg != null) {
				var msk:MovieClip = new MovieClip();
				msk.graphics.beginFill(0x000000, 0.1);
				msk.graphics.drawRect(0, 0, stageWidth, stageHeight);
				msk.graphics.endFill();
				boothMsgLayer.addChild(msk);

				var ebm:EnsvBoothMsg = new EnsvBoothMsg(msg);
				ebm.x = (stageWidth - ebm.width) / 2;
				ebm.y = (stageHeight - ebm.height) / 2;
				boothMsgLayer.addChild(ebm);
				ebm.addEventListener(EnsvBoothMsg.EVENT_CLOSE, function():void {SpriteUtil.deleteAllChild(boothMsgLayer);});
			}
		}

		private function handlerAreaMouseOut(e:Event):void {
			SpriteUtil.deleteAllChild(cardLayer);
		}

		private function handlerAreaMouseOver(e:Event):void {
			SpriteUtil.deleteAllChild(cardLayer);
			var mapView:MapView = e.currentTarget as MapView;
			var areaView:AreaNameView = mapView.currentAreaView;
			var areaDO:MapAreaDO = areaView.mapAreaDO;
			var msg:EnsvBoothMsgDO = ensvBoothMsgDOHV.findByName(areaDO.areaCode) as EnsvBoothMsgDO;

			if (msg != null) {
				var dName:String = "";
				var dText:String = "";

				dName = msg.name;
				dText = msg.goods;

				var ebc:EnsvBoothCard = new EnsvBoothCard();
				ebc.dName = dName;
				ebc.dText = dText;
				cardLayer.addChild(ebc);

				var firstPane:EnsvPane; /////////////////////////////

				var fprect:Rectangle = new Rectangle(areaView.center.x, areaView.center.y);

				var p:Point = McEffect.getCuntryLablePoint(ebc.getRect(dragLayer), fprect, mapLayer.getRect(dragLayer));
				ebc.x = p.x;
				ebc.y = p.y;

				var cc:MovieClip = McEffect.createLightFace(ebc.getRect(dragLayer), fprect, mapLayer.getRect(dragLayer), new Point());
				cardLayer.addChild(cc);
			}

		}

		private function handlerCplxDragMove(e:Event):void {
			cardLayer.visible = false;
		}

		private function handlerCplxDragCmp(e:Event):void {
			cardLayer.visible = true;
		}

		private function handlerStageResize(e:Event):void {
			stateResizeSetState();
		}

		public function stateResizeSetState():void {

			viewLayer.x = stageWidth - viewLayer.width;
			viewLayer.y = stageHeight - viewLayer.height;

			dragLayer.x = (stageWidth - dragLayer.width) / 2;
			dragLayer.y = (stageHeight - dragLayer.height) / 2;

			if (dragLimit != null) {
				dragLimit.width = stageWidth;
				dragLimit.height = stageHeight;
			}
			if (viewDrag != null) {
				viewDrag.x = (dragLimit.width - viewDrag.width) / 2;
				viewDrag.y = (dragLimit.height - viewDrag.height) / 2;
			}
		}

		private function handlerBoothMouseOut(e:Event):void {
			var cbooth:EnsvBooth = e.currentTarget as EnsvBooth;
			SpriteUtil.deleteAllChild(cardLayer);
		}

		private function handlerBoothMouseOver(e:Event):void {

			var cbooth:EnsvBooth = e.currentTarget as EnsvBooth;
			SpriteUtil.deleteAllChild(cardLayer);

			if (cbooth.ensvBoothDO != null && cbooth.ensvBoothDO.msg != null) {
				var dName:String = "";
				var dText:String = "";

				dName = cbooth.ensvBoothDO.msg.text;
				dText = cbooth.ensvBoothDO.msg.goods;

				var ebc:EnsvBoothCard = new EnsvBoothCard();
				ebc.dName = dName;
				ebc.dText = dText;
				cardLayer.addChild(ebc);

				var firstPane:EnsvPane = cbooth.panes[0];

				var fprect:Rectangle = firstPane.getRect(dragLayer);
				fprect.x += fprect.width / 2;
				fprect.y += fprect.height / 2;

				var p:Point = McEffect.getCuntryLablePoint(ebc.getRect(dragLayer), fprect, mapLayer.getRect(dragLayer));
				ebc.x = p.x;
				ebc.y = p.y;

				var cc:MovieClip = McEffect.createLightFace(ebc.getRect(dragLayer), fprect, mapLayer.getRect(dragLayer), new Point());
				cardLayer.addChild(cc);
			}
		}

		private function setBoothSelectedFilters(booth:Sprite):void {
			var array:Array = new Array();
			array.push(new DropShadowFilter(0, 0, 0xffffff, 3, 2, 2, 255));
			array.push(new DropShadowFilter(0, 0, 0x000000, 3, 4, 4, 1));
			booth.filters = array;
		}

		private function setBoothUnSelectedFilters(booth:Sprite):void {
			var array:Array = new Array();
			array.push(new DropShadowFilter(0, 0, 0x666666, 3, 2, 2, 255, 1, true));
			booth.filters = array;
		}

	}
}
