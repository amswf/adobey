package com.snsoft.ensview {
	import ascb.util.StringUtilities;

	import com.snsoft.util.HashVector;
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.SpriteUtil;
	import com.snsoft.util.complexEvent.CplxMouseDrag;
	import com.snsoft.util.rlm.ResLoadManager;
	import com.snsoft.util.rlm.rs.RSTextFile;
	import com.snsoft.util.wayfinding.WayFinding;
	import com.snsoft.util.xmldom.Node;
	import com.snsoft.util.xmldom.NodeList;
	import com.snsoft.util.xmldom.XMLDom;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class Ensv extends MovieClip {

		private var rsxml:RSTextFile;

		private var dataXMLUrl:String = "data.xml";

		private var boothMsgXMLUrl:String = "boothMsg.xml";

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

		private var currentPosition:Point = new Point();

		private var stageWidth:int = 0;

		private var stageHeight:int = 0;

		private var ensvBoothMsgDOHV:HashVector = new HashVector();

		private var searchBooths:Vector.<EnsvBooth>;

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
			rsxml.addResUrl(dataXMLUrl);
			rsxml.addResUrl(boothMsgXMLUrl);

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
			var xmlStr:String = rsxml.getTextByUrl(dataXMLUrl);
			var xml:XML = new XML(xmlStr);
			var xdom:XMLDom = new XMLDom(xml);
			var node:Node = xdom.parse();
			var ensNode:Node = node.getNodeListFirstNode("ens");
			esRow = parseInt(ensNode.getAttributeByName("row"));
			esCol = parseInt(ensNode.getAttributeByName("col"));

			//初始化矩阵
			for (var i:int = 0; i < esRow; i++) {
				var v:Vector.<Boolean> = new Vector.<Boolean>();
				for (var j:int = 0; j < esCol; j++) {
					v.push(true);
				}
				wayfvv.push(v);
			}

			var boothList:NodeList = ensNode.getNodeList("booth");

			if (boothList != null) {
				for (var ii:int = 0; ii < boothList.length(); ii++) {
					var boothNode:Node = boothList.getNode(ii);
					var ebdo:EnsvBoothDO = new EnsvBoothDO();
					ebdo.id = boothNode.getAttributeByName("value");
					ebdo.text = boothNode.getAttributeByName("name");
					ebdo.isCurrentPosition = (boothNode.getAttributeByName("isCurrentPosition") == "true") ? true : false;
					var paneList:NodeList = boothNode.getNodeList("pane");
					var ebmdo:EnsvBoothMsgDO = ensvBoothMsgDOHV.findByName(ebdo.id) as EnsvBoothMsgDO;

					if (ebmdo != null) {
						ebdo.msg = ebmdo;
					}

					if (ebdo.isCurrentPosition) {
						if (paneList.length() > 0) {
							var fPaneNode:Node = paneList.getNode(0);
							currentPosition.y = parseInt(fPaneNode.getAttributeByName("row")) - 1;
							currentPosition.x = parseInt(fPaneNode.getAttributeByName("col")) - 1;
						}
					}

					for (var jj:int = 0; jj < paneList.length(); jj++) {
						var paneNode:Node = paneList.getNode(jj);
						var pdo:EnsvPaneDO = new EnsvPaneDO();
						pdo.row = parseInt(paneNode.getAttributeByName("row")) - 1;
						pdo.col = parseInt(paneNode.getAttributeByName("col")) - 1;
						pdo.width = paneWidth;
						pdo.height = paneHeight;
						//矩阵设置
						if (!ebdo.isCurrentPosition) {
							wayfvv[pdo.row][pdo.col] = false;
						}
						ebdo.addPane(pdo);
					}
					boothDOs.push(ebdo);
				}
			}

			wayFinding = new WayFinding(wayfvv);
			initMap();
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
			searchBooths = new Vector.<EnsvBooth>();

			var sb:SearchBar = e.currentTarget as SearchBar;
			var stext:String = sb.searchText;

			var searchListHeight:int = 0;
			var searchListItemLayer:Sprite = new Sprite();
			if (stext != null) {
				stext = StringUtilities.trim(stext);
				if (stext.length > 0) {
					SpriteUtil.deleteAllChild(searchListLayer);
					searchListLayer.visible = true;

					var n:int = 0;
					for (var i:int = 0; i < boothDOs.length; i++) {
						var bdo:EnsvBoothDO = boothDOs[i];
						var msg:EnsvBoothMsgDO = bdo.msg;
						if (msg != null) {
							if ((msg.text != null && msg.text.indexOf(stext) >= 0) || (msg.des != null && msg.des.indexOf(stext) >= 0)) {
								var eli:EnsvListItem = new EnsvListItem(msg.text);
								eli.y = eli.height * n;
								searchListHeight += eli.height;
								searchListItemLayer.addChild(eli);
								var ensvb:EnsvBooth = boothsLayer.getChildAt(i) as EnsvBooth;
								searchBooths.push(ensvb);
								n++;
							}
						}
					}
				}
			}

			if (searchBooths.length > 0) {
				var barh:int = viewLayer.y - searchListLayer.y - 20;
				var sbar:ScrollBar = new ScrollBar(barh, searchListHeight);
				sbar.x = 210;
				searchListLayer.addChild(sbar);
				searchListLayer.addChild(searchListItemLayer);

				var msk:MovieClip = new MovieClip();
				msk.graphics.beginFill(0x000000, 1);
				msk.graphics.drawRect(-16, -1, 226, barh + 2);
				msk.graphics.endFill();
				searchListLayer.addChild(msk);
				searchListItemLayer.mask = msk;

				sbar.addEventListener(ScrollBar.EVENT_SCROLLING, function():void {searchListItemLayer.y = -int(searchListHeight - 500) * sbar.getScrollValue()});
			}
		}

		private function handlerSearchList(e:Event):void {
			var sb:SearchBar = e.currentTarget as SearchBar;
			searchListLayer.visible = !searchListLayer.visible;
		}

		private function initMap():void {

			var back:Sprite = new Sprite();
			back.graphics.beginFill(0x000000, 0.1);
			back.graphics.drawRect(0, 0, esCol * paneWidth, esRow * paneHeight);
			back.graphics.endFill();
			mapLayer.addChild(back);
			mapLayer.addChild(boothsLayer);

			for (var i:int = 0; i < boothDOs.length; i++) {
				var booth:EnsvBooth = new EnsvBooth(boothDOs[i]);
				booth.order = i;
				boothsLayer.addChild(booth);
				booths.push(booth);
				setBoothUnSelectedFilters(booth);
				booth.addEventListener(MouseEvent.CLICK, handlerBoothClick);
				booth.addEventListener(MouseEvent.MOUSE_OVER, handlerBoothMouseOver);
				booth.addEventListener(MouseEvent.MOUSE_OUT, handlerBoothMouseOut);
			}

//			for (var j:int = 0; j < esCol; j++) {
//				for (var k:int = 0; k < esRow; k++) {
//					var tfd:TextField = new TextField();
//					tfd.autoSize = TextFieldAutoSize.LEFT;
//					tfd.text = "" + j + "" + k;
//					tfd.x = j * 30;
//					tfd.y = k * 30;
//					tfd.mouseEnabled = false;
//					mapLayer.addChild(tfd);
//				}
//			}

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
