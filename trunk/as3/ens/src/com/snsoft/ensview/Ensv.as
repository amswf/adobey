package com.snsoft.ensview {
	import ascb.util.StringUtilities;

	import com.snsoft.mapview.AreaNameView;
	import com.snsoft.mapview.dataObj.MapAreaDO;
	import com.snsoft.mapview.dataObj.WorkSpaceDO;
	import com.snsoft.mapview.util.MapViewXMLLoader;
	import com.snsoft.util.HashVector;
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.SpriteUtil;
	import com.snsoft.util.complexEvent.CplxMouseDrag;
	import com.snsoft.util.netPathfinding.NetNode;
	import com.snsoft.util.rlm.ResLoadManager;
	import com.snsoft.util.rlm.rs.RSTextFile;
	import com.snsoft.util.wayfinding.WayFinding;
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

		private var rsxml:RSTextFile;

		private var boothMsgXMLUrl:String = "boothMsg.xml";

		private var mapXMLUrl:String = "flash_map/1x/ws_1.xml";

		private var esRow:int = 1;

		private var esCol:int = 1;

		private var paneWidth:int = 30;

		private var paneHeight:int = 30;

		private var boothDOs:Vector.<EnsvBoothDO> = new Vector.<EnsvBoothDO>();

		private var wayfvv:Vector.<Vector.<Boolean>> = new Vector.<Vector.<Boolean>>();

		private var booths:Vector.<EnsvBooth> = new Vector.<EnsvBooth>();

		private var boothClickLock:Boolean = false;

		private var wayFinding:WayFinding;

		private var wayLayer:Sprite = new Sprite();

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

		private var currentPosition:Point = new Point();

		private var stageWidth:int = 0;

		private var stageHeight:int = 0;

		private var ensvBoothMsgDOHV:HashVector = new HashVector();

		private var searchBooths:Vector.<EnsvBooth>;

		private var mapPathManager:MapPathManager = null;

		public function Ensv(stageWidth:int, stageHeight:int) {
			super();
			this.stageWidth = stageWidth;
			this.stageHeight = stageHeight;

			this.addChild(dragLayer);
			dragLayer.addChild(mapLayer);
			dragLayer.addChild(wayLayer);
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

			this.addChild(boothMsgLayer);
		}

		private function handlerEnterFrame(e:Event):void {
			this.removeEventListener(Event.ENTER_FRAME, handlerEnterFrame);
			init();
		}

		private function init():void {
			//stage.addEventListener(Event.RESIZE, handlerStageResize);
			loadXML();
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

			mapPathManager = new MapPathManager(wsdo.sections);

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

			searchBooths = new Vector.<EnsvBooth>();

			var sb:SearchBar = e.currentTarget as SearchBar;
			var stext:String = sb.searchText;

			var searchListHeight:int = 0;
			var searchListItemLayer:Sprite = new Sprite();
			if (stext != null) {
				stext = StringUtilities.trim(stext);
				if (stext.length > 0) {

					var n:int = 0;
					for (var i:int = 0; i < boothDOs.length; i++) {
						var bdo:EnsvBoothDO = boothDOs[i];
						var msg:EnsvBoothMsgDO = bdo.msg;
						if (msg != null) {
							if ((msg.text != null && msg.text.indexOf(stext) >= 0) || (msg.des != null && msg.des.indexOf(stext) >= 0)) {
								var ensvb:EnsvBooth = boothsLayer.getChildAt(i) as EnsvBooth;
								searchBooths.push(ensvb);

								var eli:EnsvListItem = new EnsvListItem(msg.text);
								eli.ensvBooth = ensvb;
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

			if (searchBooths.length > 0) {
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
					sbar.addEventListener(ScrollBar.EVENT_SCROLLING, function():void {searchListItemLayer.y = -int(searchListHeight - 500) * sbar.getScrollValue()});
				}
			}
		}

		private function handlerEnsvListItemClick(e:Event):void {
			var eli:EnsvListItem  = e.currentTarget as EnsvListItem;
			eli.ensvBooth.dispatchEvent(new Event(MouseEvent.CLICK));
			SpriteUtil.deleteAllChild(cardLayer);

			if (eli.ensvBooth != null) {
				viewEnsvBoothMsg(eli.ensvBooth);
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

			var back:Sprite = new Sprite();
			back.graphics.lineStyle(2, 0x000000, 1);
			back.graphics.beginFill(0xfffffff, 1);
			back.graphics.drawRect(0, 0, esCol * paneWidth, esRow * paneHeight);
			back.graphics.endFill();
			mapLayer.addChild(back);
			mapLayer.addChild(boothsLayer);

			var mapView:MapView = new MapView();
			mapView.workSpaceDO = wsdo;
			mapView.drawNow();
			boothsLayer.addChild(mapView);
			mapView.addEventListener(MapView.AREA_CLICK_EVENT, handlerAreaClick);
			mapView.addEventListener(MapView.AREA_DOUBLE_CLICK_EVENT, handlerAreaDoubleClick);
			mapView.addEventListener(MapView.AREA_MOUSE_OUT_EVENT, handlerAreaMouseOut);
			mapView.addEventListener(MapView.AREA_MOUSE_OVER_EVENT, handlerAreaMouseOver);

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
			var wpw:int = wp.width / 2;
			var wph:int = wp.height / 2;
			var wpx:int = vl.width * (currentPosition.x + 1) / esCol - wpw;
			var wpy:int = vl.height * (currentPosition.y + 1) / esRow - wph;
			if (wpx >= vl.width - wpw) {
				wpx -= wpw;
			}
			else if (wpx <= wpw) {
				wpx += wpw;
			}
			if (wpy >= vl.height - wph) {
				wpy -= wph;
			}
			else if (wpy <= wph) {
				wpy += wph;
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
			cp.x = currentPosition.x * cp.width;
			cp.y = currentPosition.y * cp.height;
			wayLayer.addChild(cp);
		}

		private function handlerAreaClick(e:Event):void {
			var mapView:MapView = e.currentTarget as MapView;
			var areaView:AreaNameView = mapView.currentAreaView;
			var areaDO:MapAreaDO = areaView.mapAreaDO;

			var n1:NetNode = mapPathManager.findNodeByPosition(new Point(239, 463));
			//var n2:NetNode = mapPathManager.findNodeByPosition(new Point(121, 43));
			var n2:NetNode = mapPathManager.findNodeByAreaName(areaDO.areaId);
			var points:Vector.<Point> = mapPathManager.findPath(n1, n2);

			wayLayer.graphics.clear();
			for (var i:int = 0; i < points.length; i++) {
				var p:Point = points[i];

				wayLayer.graphics.lineStyle(2, 0x000000);
				if (i == 0) {
					wayLayer.graphics.moveTo(p.x, p.y);
				}
				else {
					wayLayer.graphics.lineTo(p.x, p.y);
				}
			}

		}

		private function handlerAreaDoubleClick(e:Event):void {

		}

		private function handlerAreaMouseOut(e:Event):void {

		}

		private function handlerAreaMouseOver(e:Event):void {

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

			dragLayer.x = 0;
			dragLayer.y = 0;

			if (dragLimit != null) {
				dragLimit.width = stageWidth;
				dragLimit.height = stageHeight;
			}
			if (viewDrag != null) {
				viewDrag.x = 0;
				viewDrag.y = 0;
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

		private function handlerBoothDoubleClick(e:Event):void {
			var booth:EnsvBooth = e.currentTarget as EnsvBooth;
			viewEnsvBoothMsg(booth);
		}

		private function handlerBoothClick(e:Event):void {
			if (!boothClickLock) {
				boothClickLock = true;
				var cbooth:EnsvBooth = e.currentTarget as EnsvBooth;
				for (var i:int = 0; i < booths.length; i++) {
					var booth:EnsvBooth = booths[i];
					if (cbooth.order != i) {
						setBoothUnSelectedFilters(booth);
					}
					else {
						setBoothSelectedFilters(booth);
					}
				}
				findWay(boothDOs[cbooth.order]);
				boothClickLock = false;
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

		private function findWay(boothDO:EnsvBoothDO):void {
			var pv:Vector.<EnsvPaneDO> = boothDO.paneDOs;
			var minv:Vector.<Point> = null;
			var min:int = int.MAX_VALUE;
			for (var j:int = 0; j < pv.length; j++) {
				var pdo:EnsvPaneDO = pv[j];
				var v:Vector.<Point> = wayFinding.find(currentPosition, new Point(pdo.col, pdo.row));
				if (v.length < min && v.length > 0) {
					minv = v;
					min = v.length;
				}
			}
			SpriteUtil.deleteAllChild(wayLayer);

			if (minv != null) {
				for (var i:int = 0; i < minv.length - 1; i++) {

					var pp:Point = null;
					var p:Point = null;
					var np:Point = null;

					p = minv[i];
					if ((i - 1) >= 0) {
						pp = minv[i - 1];
					}
					if ((i + 1) < minv.length) {
						np = minv[i + 1];
					}

					var rotation:int = 0;
					var skinName:String = "";
					if (pp == null && np != null) {
						skinName = "WayPoint";
						if (np.x > p.x) {
							rotation = 0;
						}
						else if (np.x < p.x) {
							rotation = 180;
						}
						else if (np.y > p.y) {
							rotation = 90;
						}
						else if (np.y < p.y) {
							rotation = -90;
						}
					}
					else if (pp != null && np == null) {
						skinName = "FootD";
						if (p.x > pp.x) {
							rotation = 0;
						}
						else if (p.x < pp.x) {
							rotation = 180;
						}
						else if (p.y > pp.y) {
							rotation = 90;
						}
						else if (p.y < pp.y) {
							rotation = -90;
						}
					}
					else if (pp != null && np != null) {
						if (p.x == pp.x && pp.x == np.x) {
							skinName = "FootD";
							if (pp.y < np.y) {
								rotation = 90;
							}
							else if (pp.y > np.y) {
								rotation = -90;
							}
						}
						else if (p.y == pp.y && pp.y == np.y) {
							skinName = "FootD";
							if (pp.x < np.x) {
								rotation = 0;
							}
							else if (pp.x > np.x) {
								rotation = 180;
							}
						}
						else {

							if (p.x > pp.x && np.y > p.y) {
								skinName = "FootR";
								rotation = 0;
							}
							else if (p.y > pp.y && np.x < p.x) {
								skinName = "FootR";
								rotation = 90;
							}
							else if (p.x < pp.x && np.y < p.y) {
								skinName = "FootR";
								rotation = 180;
							}
							else if (p.y < pp.y && np.x > p.x) {
								skinName = "FootR";
								rotation = -90;
							}
							else if (p.x > pp.x && np.y < p.y) {
								skinName = "FootL";
								rotation = 0;
							}
							else if (p.y < pp.y && np.x < p.x) {
								skinName = "FootL";
								rotation = -90;
							}
							else if (p.x < pp.x && np.y > p.y) {
								skinName = "FootL";
								rotation = -180;
							}
							else if (p.y > pp.y && np.x > p.x) {
								skinName = "FootL";
								rotation = 90;
							}
						}
					}
					var mc:MovieClip = new MovieClip();

					var skin:MovieClip = SkinsUtil.createSkinByName(skinName);
					skin.x = -skin.width / 2;
					skin.y = -skin.height / 2;
					mc.addChild(skin);
					mc.rotation = rotation;
					mc.x = p.x * paneWidth + skin.width / 2;
					mc.y = p.y * paneHeight + skin.height / 2;
					wayLayer.addChild(mc);
				}
			}
		}

	}
}
