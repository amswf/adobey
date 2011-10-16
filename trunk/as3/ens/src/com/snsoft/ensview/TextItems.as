package com.snsoft.ensview {
	import com.snsoft.util.SpriteUtil;
	import com.snsoft.util.xmldom.Node;
	import com.snsoft.util.xmldom.NodeList;
	import com.snsoft.util.xmldom.XMLDom;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class TextItems extends MovieClip {

		public static const EVENT_BTN:String = "EVENT_BTN";

		public static const BTN_TYPE_MAP:String = "map";

		public static const BTN_TYPE_INTRO:String = "intro";

		public static const BTN_TYPE_ITEMS:String = "items";

		public static const BTN_TYPE_BACK:String = "back";

		private var maskLayer:Sprite = new Sprite();

		private var itemsLayer:Sprite = new Sprite();

		private var scrollLayer:Sprite = new Sprite();

		private var lockLayer:Sprite = new Sprite();

		private var msgLayer:Sprite = new Sprite();

		private var ix:int = 75;

		private var iy:int = 180;

		private var _btnType:String;

		public function TextItems() {
			super();
			this.addEventListener(Event.ENTER_FRAME, handlerEnterFrame);
		}

		private function handlerEnterFrame(e:Event):void {
			this.removeEventListener(Event.ENTER_FRAME, handlerEnterFrame);

			this.addChild(itemsLayer);
			this.addChild(maskLayer);
			this.addChild(scrollLayer);
			this.addChild(lockLayer);
			this.addChild(msgLayer);

			addEvent("mapBtn", BTN_TYPE_MAP);
			addEvent("itemsBtn", BTN_TYPE_ITEMS);
			addEvent("introBtn", BTN_TYPE_INTRO);
			addEvent("backBtn", BTN_TYPE_BACK);

			var lock:Sprite = new Sprite();
			lock.graphics.beginFill(0xffffff, 0);
			lock.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			lock.graphics.endFill();
			lockLayer.addChild(lock);
			lock.x = -this.x;
			lock.y = -this.y;
			lockLayer.visible = false;

			itemsLayer.x = ix;
			itemsLayer.y = iy;

			maskLayer.x = ix;
			maskLayer.y = iy;

			var msk:Sprite = new Sprite();
			msk.graphics.beginFill(0x000000, 1);
			msk.graphics.drawRect(0, 0, 870, 500);
			msk.graphics.endFill();
			maskLayer.addChild(msk);

			itemsLayer.mask = maskLayer;

			loadXML();
		}

		private function addEvent(btnName:String, type:String):void {
			var mc:MovieClip = this;
			var mapBtn:MovieClip = this.getChildByName(btnName) as MovieClip;
			if (mapBtn != null) {
				mapBtn.buttonMode = true;
				mapBtn.addEventListener(MouseEvent.CLICK, function(e:Event):void {_btnType = type;mc.dispatchEvent(new Event(EVENT_BTN));});
			}
		}

		public function get btnType():String {
			return _btnType;
		}

		private function loadXML():void {
			var ul:URLLoader = new URLLoader();
			ul.addEventListener(Event.COMPLETE, handlerLoadXMLCmp);
			ul.load(new URLRequest("boothMsg.xml"));
		}

		private function handlerLoadXMLCmp(e:Event):void {
			var ul:URLLoader = e.currentTarget as URLLoader;
			var xml:XML = new XML(ul.data);
			parseBoothMsg(xml);
		}

		private function parseBoothMsg(xml:XML):void {
			var xdom:XMLDom = new XMLDom(xml);
			var node:Node = xdom.parse();
			var recordNodeList:NodeList = node.getNodeList("record");
			for (var i:int = 0; i < recordNodeList.length(); i++) {
				var rNode:Node = recordNodeList.getNode(i);
				var ebmdo:EnsvBoothMsgDO = new EnsvBoothMsgDO();
				rNode.attrToObj(ebmdo);
				rNode.childNodeTextTObj(ebmdo);
				var ebi:EnsvBoothItem = new EnsvBoothItem(ebmdo);
				ebi.mouseChildren = false;
				ebi.buttonMode = true;
				ebi.addEventListener(MouseEvent.CLICK, handlerItemClick);
				itemsLayer.addChild(ebi);
				ebi.y = i * ebi.height;
			}

			var sbar:ScrollBar = new ScrollBar(500, itemsLayer.height);
			sbar.addEventListener(ScrollBar.EVENT_SCROLLING, function():void {itemsLayer.y = iy - int(itemsLayer.height - 500) * sbar.getScrollValue()});
			scrollLayer.addChild(sbar);
			sbar.x = ix + itemsLayer.width + 20;
			sbar.y = iy;
		}

		private function handlerItemClick(e:Event):void {
			trace("handlerItemClick");
			lockLayer.visible = true;
			var ebi:EnsvBoothItem = e.currentTarget as EnsvBoothItem;
			var ebm:EnsvBoothMsg = new EnsvBoothMsg(ebi.ensvBoothMsgDO);
			SpriteUtil.deleteAllChild(msgLayer);
			msgLayer.addChild(ebm);
			ebm.x = (1024 - ebm.width) / 2;
			ebm.y = (768 - ebm.height) / 2;
			ebm.addEventListener(EnsvBoothMsg.EVENT_CLOSE, function():void {lockLayer.visible = false;SpriteUtil.deleteAllChild(msgLayer);});
		}
	}
}
