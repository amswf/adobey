﻿package com.snsoft.ensview {
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.SpriteUtil;
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

	public class Ensv extends Sprite {

		private var rsxml:RSTextFile;

		private var xmlUrl:String = "data.xml";

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

		public function Ensv() {
			super();

			this.addChild(mapLayer);
			this.addChild(wayLayer);

			loadXML();
		}

		private function loadXML():void {
			rsxml = new RSTextFile();
			rsxml.addResUrl(xmlUrl);

			var rsm:ResLoadManager = new ResLoadManager();
			rsm.addResSet(rsxml);
			rsm.addEventListener(Event.COMPLETE, handlerLoadXMLCmp);
			rsm.load();
		}

		private function handlerLoadXMLCmp(e:Event):void {
			var xmlStr:String = rsxml.getTextByUrl(xmlUrl);
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
					var paneList:NodeList = boothNode.getNodeList("pane");
					for (var jj:int = 0; jj < paneList.length(); jj++) {
						var paneNode:Node = paneList.getNode(jj);
						var pdo:EnsvPaneDO = new EnsvPaneDO();
						pdo.row = parseInt(paneNode.getAttributeByName("row")) - 1;
						pdo.col = parseInt(paneNode.getAttributeByName("col")) - 1;
						pdo.width = paneWidth;
						pdo.height = paneHeight;
						//矩阵设置
						wayfvv[pdo.row][pdo.col] = false;
						ebdo.addPane(pdo);
					}
					boothDOs.push(ebdo);
				}
			}

			wayFinding = new WayFinding(wayfvv);
			initMap();

		}

		private function initMap():void {
			for (var i:int = 0; i < boothDOs.length; i++) {
				var booth:EnsvBooth = new EnsvBooth(boothDOs[i]);
				booth.order = i;
				mapLayer.addChild(booth);
				booths.push(booth);
				setBoothUnSelectedFilters(booth);
				booth.addEventListener(MouseEvent.CLICK, handlerBoothClick);
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
				var v:Vector.<Point> = wayFinding.find(new Point(8, 4), new Point(pdo.col, pdo.row));
				if (v.length < min && v.length > 0) {
					minv = v;
					min = v.length;
				}
			}
			SpriteUtil.deleteAllChild(wayLayer);

			if (minv != null) {
				for (var i:int = 0; i < minv.length; i++) {
					var mc:MovieClip = SkinsUtil.createSkinByName("WayPoint");
					var p:Point = minv[i];
					mc.x = p.x * paneWidth;
					mc.y = p.y * paneHeight;
					wayLayer.addChild(mc);
				}
			}
		}

	}
}
