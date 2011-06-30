package com.snsoft.ltree {
	import com.snsoft.util.di.ObjectProperty;
	import com.snsoft.util.rlm.ResLoadManager;
	import com.snsoft.util.rlm.rs.RSImages;
	import com.snsoft.util.rlm.rs.RSTextFile;
	import com.snsoft.util.xmldom.Node;
	import com.snsoft.util.xmldom.NodeList;
	import com.snsoft.util.xmldom.XMLDom;

	import fl.core.InvalidationType;
	import fl.core.UIComponent;

	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;

	public class LTree extends UIComponent {

		private var lTreeDO:LTreeDO = new LTreeDO;

		private var nodeList:NodeList = null;

		private var nodeNum:int = 0;

		public function LTree() {
			super();
		}

		/**
		 *
		 */
		private static var defaultStyles:Object = {
				testSkin: "Test_Skin"
			};

		/**
		 *
		 * @return
		 *
		 */
		public static function getStyleDefinition():Object {
			return UIComponent.mergeStyles(UIComponent.getStyleDefinition(), defaultStyles);
		}

		/**
		 *
		 *
		 */
		override protected function configUI():void {
			this.invalidate(InvalidationType.ALL, true);
			this.invalidate(InvalidationType.SIZE, true);
			super.configUI();
		}

		/**
		 *
		 * 绘制组件显示
		 */
		override protected function draw():void {
			//getDisplayObjectInstance(getStyleValue("testSkin")) as MovieClip;
		}

		public function init(xmlUrl:String):void {
			var rstf:RSTextFile = new RSTextFile();
			rstf.addResUrl(xmlUrl);
			var rlm:ResLoadManager = new ResLoadManager();
			rlm.addResSet(rstf);
			rlm.load();
			rlm.addEventListener(Event.COMPLETE, handlerLoadXMLCmp);
		}

		private function handlerLoadXMLCmp(e:Event):void {
			var rlm:ResLoadManager = e.currentTarget as ResLoadManager;
			var str:String = rlm.getResByIndex(0) as String;
			var xml:XML = new XML(str);
			var xdom:XMLDom = new XMLDom(xml);
			var xmlNode:Node = xdom.parse();
			nodeList = xmlNode.getNodeList("node");

			var ltcs:LTreeCommonSkin = new LTreeCommonSkin();
			var op:ObjectProperty = new ObjectProperty(ltcs);
			var names:Vector.<String> = op.getAllPropertyNames();
			var rsImages:RSImages = new RSImages();
			lTreeDO.rsImages = rsImages;
			lTreeDO.lTreeCommonSkin = ltcs;
			if (names) {
				for (var i:int = 0; i < names.length; i++) {
					var url:String = ltcs[names[i]];
					rsImages.addResUrl(url);
				}
			}

			var rlmi:ResLoadManager = new ResLoadManager();
			rlmi.addResSet(rsImages);
			rlmi.load();
			rlmi.addEventListener(Event.COMPLETE, handlerLoadImageCmp);
		}

		private function handlerLoadImageCmp(e:Event):void {
			addLNodes(nodeList);
		}

		private function addLNodes(nodeList:NodeList, parentLNodeDO:LNodeDO = null):void {
			if (nodeList) {

				var ltcs:LTreeCommonSkin = lTreeDO.lTreeCommonSkin;
				for (var i:int = 0; i < nodeList.length(); i++) {

					var node:Node = nodeList.getNode(i);

					var lndo:LNodeDO = new LNodeDO();
					lndo.node = node;
					lndo.parentLNodeDO = parentLNodeDO;
					setLNodeDOImages(lndo, lTreeDO.rsImages, ltcs);
					var isRoot:Boolean = (parentLNodeDO == null);
					var placeType:int = getPlaceType(node, nodeList, i, isRoot);
					lndo.placeType = placeType;

					var pptl:Vector.<int> = null;
					if (parentLNodeDO != null) {
						pptl = parentLNodeDO.placeTypeList;
					}

					var list:Vector.<int> = creatPlaceTypeList(pptl, placeType);
					lndo.placeTypeList = list;
					trace(list);

					var lnode:LNode = new LNode(lndo);
					lnode.y = lnode.height * nodeNum;
					this.addChild(lnode);
					nodeNum++;
					addLNodes(node.getNodeList("node"), lndo);
				}
			}
		}

		private function creatPlaceTypeList(list:Vector.<int>, placeType:int):Vector.<int> {
			var cv:Vector.<int> = new Vector.<int>();
			if (list != null) {
				for (var i:int = 0; i < list.length; i++) {
					var type:int = list[i];
					cv.push(type);
				}
			}
			cv.push(placeType);
			return cv;
		}

		private function setLNodeDOImages(lNodeDO:LNodeDO, rsImages:RSImages, ltcs:LTreeCommonSkin):void {
			var op:ObjectProperty = new ObjectProperty(ltcs);
			var list:Vector.<String> = op.propertyNames;
			for (var i:int = 0; i < list.length; i++) {
				var name:String = list[i];
				lNodeDO[name] = rsImages.getImageByUrl(ltcs[name]);
			}
		}

		private function getPlaceType(node:Node, nodeList:NodeList, nodeIndex:int, isRoot:Boolean):int {
			var bmd:BitmapData = null;
			var skin:LTreeCommonSkin = lTreeDO.lTreeCommonSkin;
			var placeType:int = 0;
			if (node != null && skin != null) {

				if (nodeList != null && nodeList.length() > 0) {
					if (isRoot && nodeIndex == 0 && nodeList.length() == 1) {
						placeType = LNodePlaceType.NOLINE;
					}
					else if (isRoot && nodeIndex == 0) {
						placeType = LNodePlaceType.TOP;
					}
					else if (nodeList.length() == 1) {
						placeType = LNodePlaceType.BOTTOM;
					}
					else if (nodeIndex == nodeList.length() - 1) {
						placeType = LNodePlaceType.BOTTOM
					}
					else {
						placeType = LNodePlaceType.CENTER;
					}
				}
			}
			return placeType;
		}
	}
}
