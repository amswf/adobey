package {
	import fl.core.UIComponent;
	import com.snsoft.util.SkinsUtil;
	import flash.display.MovieClip;
	import fl.core.InvalidationType;
	import flash.text.TextField;
	import flash.events.TouchEvent;
	import flash.events.Event;
	import fl.livepreview.LivePreviewParent;
	import com.snsoft.map.util.MapUtil;
	import flash.display.Sprite;
	import fl.events.ComponentEvent;
	import flash.utils.getDefinitionByName;

	public class ViewTest extends UIComponent {

		private var mc:MovieClip;

		private var _varTitle:Array;

		private var tfds:Sprite;

		private var lp:LivePreviewParent;


		public function set varTitle(varTitle:Array):void {
			this._varTitle = varTitle;
			this.drawNow();//设置可视属性时重绘组件，不然无法实时显示。
		}

		public function get varTitle():Array {
			return this._varTitle;
		}

		public function ViewTest() {
		}


		override protected function configUI():void {
			mc = com.snsoft.util.SkinsUtil.createSkinByName("View_skin");
			this.addChild(mc);

			tfds = new Sprite();
			this.addChild(tfds);

			this.invalidate(InvalidationType.ALL,true);
			this.invalidate(InvalidationType.SIZE,true);
			super.configUI();
		}

		private function handler(e:Event):void {
			this.drawNow();
		}

		/**
		 * 
		 * 
		 */
		override protected function draw():void {
			this.mc.width = this.width;
			this.mc.height = this.height;
			com.snsoft.map.util.MapUtil.deleteAllChild(tfds);
			if (this.varTitle != null) {
				for (var i:int =0; i<this.varTitle.length; i++) {
					var tfd:TextField = new TextField();
					tfd.text = (this.varTitle[i] as String);
					var cmc:MovieClip = com.snsoft.util.SkinsUtil.createSkinByName("View_skin");
					cmc.height = 20;
					cmc.width = this.width;
					cmc.y = i * 20;
					tfd.width = this.width;
					tfd.y = i * 20;
					this.tfds.addChild(cmc);
					this.tfds.addChild(tfd);
				}
			}
		}
	}

}