package com.snsoft.ltree {
	import com.snsoft.util.rlm.rs.RSImages;
	import com.snsoft.util.xmldom.Node;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class LText extends Sprite {

		private var nodeText:TextField = null;

		private var lTreeDO:LTreeDO = null;

		private var open:Boolean = false;

		private var minusOrPlusImage:Bitmap;

		public function LText(node:Node, lTreeDO:LTreeDO) {
			super();
			this.lTreeDO = lTreeDO;

			if (node != null) {
				var text:String = node.getAttributeByName("text");
				if (text != null) {
					nodeText = new TextField();
					nodeText.defaultTextFormat = new TextFormat(null, 13, 0x000000);
					nodeText.autoSize = TextFieldAutoSize.LEFT;
					nodeText.text = text;
					this.addChild(nodeText);

					var rect:Rectangle = nodeText.getRect(this);

					var spr:Sprite = Utils.drawRect(rect.width, rect.height);
					spr.alpha = 0.2;
					this.addChild(spr);
				}
			}
		}

		public function setMinusOrPlusImage(imageUrl:String):void {
			var bmd:BitmapData = lTreeDO.rsImages.getImageByUrl(imageUrl);
			if (minusOrPlusImage != null) {
				this.removeChild(minusOrPlusImage);
			}
			minusOrPlusImage = new Bitmap(bmd, "auto", true);
			this.addChild(minusOrPlusImage);
		}
	}
}
