package com.snsoft.tvc2.map{
	import com.snsoft.map.MapAreaDO;
	import com.snsoft.map.util.MapUtil;
	import com.snsoft.mapview.util.MapViewDraw;
	import com.snsoft.mapview.util.MyColorTransform;
	import com.snsoft.tvc2.text.EffectText;
	import com.snsoft.tvc2.text.Text;
	import com.snsoft.util.ColorTransformUtil;
	import com.snsoft.util.TextFieldUtil;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	[Style(name="myTextFormat", type="Class")]
	
	/**
	 * 显示地图分块 
	 * @author Administrator
	 * 
	 */	
	public class AreaView extends UIComponent{
		
		//地图块数据对象
		private var _mapAreaDO:MapAreaDO = null;
		
		//地图块按钮层
		private var areaBtnLayer:Sprite = new Sprite();
		
		//地图块名称层
		private var areaNameLayer:Sprite = new Sprite();
		
		//标记是否显示完成
		private var isDrawCmp:Boolean = false;
		/**
		 * 
		 * 
		 */		
		public function AreaView()
		{
			super();
		}
		
		public static const TEXT_FORMAT:String = "myTextFormat";
		
		/**
		 * 
		 */		
		private static var defaultStyles:Object = {
			myTextFormat:new TextFormat("宋体",13,0x000000)
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
		override protected function configUI():void{
			this.buttonMode = false;
			this.mouseChildren = false;
			this.mouseEnabled = false;
			
			this.invalidate(InvalidationType.ALL,true);
			this.invalidate(InvalidationType.SIZE,true);
			super.configUI();
		}
		
		/**
		 * 
		 * 
		 */		
		override protected function draw():void{
			if(!isDrawCmp){
				isDrawCmp = true;
				MapUtil.deleteAllChild(this);
				MapUtil.deleteAllChild(areaBtnLayer);
				MapUtil.deleteAllChild(areaNameLayer);
				this.addChild(areaBtnLayer);
				this.addChild(areaNameLayer);
				
				var mado:MapAreaDO = this.mapAreaDO;
				if(mado != null){
					var pointAry:Array = mado.pointArray.toArray();
					var cl:Shape = MapViewDraw.drawFill(0xffffff,0x000000,1,1,pointAry);
					areaBtnLayer.addChild(cl);
					setAreaColor(0xcccccc,0);
					var dobj:Rectangle = cl.getRect(this);
					
//					var tft:TextFormat = this.getStyleValue(TEXT_FORMAT) as TextFormat;
//					var tfd:TextField = EffectText.creatShadowTextField(mado.areaName,tft);
//					tfd.x =dobj.x + (dobj.width - tfd.width) * 0.5 + mado.areaNamePlace.x;
//					tfd.y =dobj.y + (dobj.height - tfd.height) * 0.5 + mado.areaNamePlace.y;
//					areaNameLayer.addChild(tfd);
				}
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		public function setAreaColor(color:uint,alpha:Number = 1):void{
			ColorTransformUtil.setColor(areaBtnLayer,color);
			areaBtnLayer.alpha = alpha;
		}
		
		public function get mapAreaDO():MapAreaDO
		{
			return _mapAreaDO;
		}
		
		public function set mapAreaDO(value:MapAreaDO):void
		{
			_mapAreaDO = value;
		}
		
	}
}