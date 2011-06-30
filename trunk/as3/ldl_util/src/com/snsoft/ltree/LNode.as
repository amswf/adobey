package com.snsoft.ltree {
	import com.snsoft.util.rlm.rs.RSImages;
	import com.snsoft.util.xmldom.Node;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class LNode extends Sprite {

		private var nodeText:TextField = null;

		private var lNodeDO:LNodeDO = null;

		private var open:Boolean = false;

		private var minusOrPlusImage:Bitmap;

		private var BMD_SIZE:Point = new Point(18, 18);

		public function LNode(lNodeDO:LNodeDO) {
			super();
			this.lNodeDO = lNodeDO;
			init();
		}

		public function init():void {
			if (lNodeDO != null) {
				var node:Node = lNodeDO.node;
				if (node) {

					var text:String = node.getAttributeByName("text");
					if (text != null) {
						var baseX:int = 0;

						var plist:Vector.<int> = lNodeDO.placeTypeList;
						for (var i:int = 0; i < plist.length; i++) {
							var place:int = plist[i];

							var bmd:BitmapData = null;
							if (place == LNodePlaceType.CENTER) {
								bmd = lNodeDO.lineConn;
							}
							if (i == plist.length - 1 && place == LNodePlaceType.BOTTOM) {
								bmd = lNodeDO.lineBottom;
							}
							if (bmd != null) {
								var bm:Bitmap = new Bitmap(bmd, "auto", true);
								this.addChild(bm);
								bm.x = baseX;
							}

							baseX += BMD_SIZE.x;
						}
						baseX -= BMD_SIZE.x;

						var mpBmd:BitmapData = null;
						if (place == LNodePlaceType.NOLINE) {
							mpBmd = lNodeDO.plusNoLine;
						}
						else {
							mpBmd = lNodeDO.plusBottom;
						}
						minusOrPlusImage = new Bitmap(mpBmd, "auto", true);
						minusOrPlusImage.x = baseX;
						baseX += BMD_SIZE.x;
						this.addChild(minusOrPlusImage);

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
		}

		public function getSkin(placeType:int):BitmapData {
			if (placeType == LNodePlaceType.BOTTOM) {
				return lNodeDO.lineBottom;
			}
			else if (placeType == LNodePlaceType.CENTER) {
				return lNodeDO.lineConn;
			}
			return null;
		}

		public function setMinusOrPlusImage(bmd:BitmapData):void {
			var mx:int = minusOrPlusImage.x;
			this.removeChild(minusOrPlusImage);
			minusOrPlusImage = new Bitmap(bmd, "auto", true);
			minusOrPlusImage.x = mx;
			this.addChild(minusOrPlusImage);
		}
	}
}
