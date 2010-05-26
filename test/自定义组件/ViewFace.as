package 
{
	import flash.display.*;
	import flash.text.*;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	import fl.livepreview.LivePreviewParent;
	import flash.external.ExternalInterface;
	import com.snsoft.util.SkinsUtil;

	public class ViewFace extends MovieClip
	{

		private var mc:MovieClip;

		private var tfd:TextField;

		private var lp:LivePreviewParent;

		public function ViewFace()
		{
			lp = new LivePreviewParent  ;
			lp.myInstance = this;

			// constructor code
			mc = com.snsoft.util.SkinsUtil.createSkinByName("View_skin");
			tfd = new TextField  ;
			tfd.text = "asdf";
			this.addChild(mc);
			this.addChild(tfd);
		}

		/**
		*当组件中改变参数时触发onUpdate，这时更新值
		*/
		public function onUpdate(e:Event):void
		{
			if (mc != null)
			{
				mc.width = this.width;
				mc.height = this.height;
				tfd.text = "asdf";
			}

		}

		/**
		*当组件被调整大小时触发的函数。
		*/
		public function onResize(wid:Number,hei:Number):void
		{
			if (mc != null)
			{
				mc.width = this.width;
				mc.height = this.height;
				tfd.text = "asdf";
			}
		}
	}

}