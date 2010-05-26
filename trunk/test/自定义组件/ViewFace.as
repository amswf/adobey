package {
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	import fl.livepreview.LivePreviewParent;
	import flash.external.ExternalInterface;
	
	public class ViewFace extends ViewTest {

		private var lp:LivePreviewParent;

		public function ViewFace() {
			lp = new LivePreviewParent  ;
			lp.myInstance = this;
		}

		/**
		*当组件中改变参数时触发onUpdate，这时更新值
		*/
		public function onUpdate(e:Event):void {
			this.drawNow();
		}

		/**
		*当组件被调整大小时触发的函数。
		*/
		public function onResize(wid:Number,hei:Number):void {
			this.drawNow();
		}
	}

}