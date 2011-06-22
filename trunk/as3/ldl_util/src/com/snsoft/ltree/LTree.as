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

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;

	public class LTree extends UIComponent {

		private var lTreeDO:LTreeDO = new LTreeDO;

		private var nodeList:NodeList = null;

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

			if (nodeList) {
				for (var i:int = 0; i < nodeList.length(); i++) {
					var node:Node = nodeList.getNode(i);
					var lp:LPanel = new LPanel(node, lTreeDO);
					this.addChild(lp);
				}
			}
		}

	}
}
