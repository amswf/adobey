package com.snsoft.ltree {
	import com.snsoft.util.SpriteUtil;
	import com.snsoft.util.rlm.rs.RSImages;
	import com.snsoft.util.xmldom.Node;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class LNode extends Sprite {

		private var nodeText:TextField = null;

		private var lNodeDO:LNodeDO = null;

		private var minusOrPlusLayer:Sprite = new Sprite();

		private var plusImag:Bitmap = null;

		private var minusImag:Bitmap = null;

		private var BMD_SIZE:Point = new Point(18, 18);

		private var _lNodeList:Vector.<LNode> = new Vector.<LNode>();

		private var _orderNum:int;

		public function LNode(lNodeDO:LNodeDO) {
			super();
			this.lNodeDO = lNodeDO;
			init();
		}

		public function init():void {
			if (lNodeDO != null) {

				var text:String = lNodeDO.text;
				if (text != null) {
					var baseX:int = 0;

					var plist:Vector.<int> = lNodeDO.placeTypeList;
					for (var i:int = 0; i < plist.length; i++) {
						var place:int = plist[i];

						var bmd:BitmapData = null;
						if (place == LNodePlaceType.CENTER) {
							if (i == plist.length - 1) {
								bmd = lNodeDO.images.lineCenter;
							}
							else {
								bmd = lNodeDO.images.lineConn;
							}
						}
						if (i == plist.length - 1 && place == LNodePlaceType.BOTTOM) {
							bmd = lNodeDO.images.lineBottom;
						}
						if (bmd != null) {
							var bm:Bitmap = new Bitmap(bmd, "auto", true);
							this.addChild(bm);
							bm.x = baseX;
						}
						baseX += BMD_SIZE.x;
					}
					baseX -= BMD_SIZE.x;

					this.addChild(minusOrPlusLayer);
					minusOrPlusLayer.x = baseX;
					minusOrPlusLayer.mouseEnabled = true;
					minusOrPlusLayer.mouseChildren = false;
					minusOrPlusLayer.buttonMode = true;
					minusOrPlusLayer.addEventListener(MouseEvent.CLICK, handlerMinusOrPlusImageClick);

					plusImag = new Bitmap(lNodeDO.images.plusNoLine, "auto", true);
					plusImag.visible = false;
					minusOrPlusLayer.addChild(plusImag);

					minusImag = new Bitmap(lNodeDO.images.minusNoLine, "auto", true);
					minusImag.visible = false;
					minusOrPlusLayer.addChild(minusImag);
					changeMinusOrPlusImage();

					baseX += BMD_SIZE.x;

					nodeText = new TextField();
					nodeText.defaultTextFormat = new TextFormat(null, 13, 0x000000);
					nodeText.autoSize = TextFieldAutoSize.LEFT;
					nodeText.text = text;
					nodeText.x = baseX;
					this.addChild(nodeText);

					var rect:Rectangle = nodeText.getRect(this);
					var spr:Sprite = Utils.drawRect(rect.width, rect.height);
					spr.alpha = 0.1;
					spr.x = baseX;
					this.addChild(spr);
				}
			}
		}

		private function handlerMinusOrPlusImageClick(event:Event):void {
			lNodeDO.open = !lNodeDO.open;
			changeMinusOrPlusImage();
			this.dispatchEvent(new Event(MouseEvent.CLICK));
		}

		private function changeMinusOrPlusImage():void {
			minusImag.visible = !lNodeDO.open;
			plusImag.visible = lNodeDO.open;
		}

		public function get lNodeList():Vector.<LNode> {
			return _lNodeList;
		}

		public function addChildNode(lNode:LNode):void {
			this.lNodeList.push(lNode);
		}

		public function get orderNum():int
		{
			return _orderNum;
		}

		public function set orderNum(value:int):void
		{
			_orderNum = value;
		}


	}
}
