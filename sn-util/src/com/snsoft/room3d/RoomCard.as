package com.snsoft.room3d{
	import com.snsoft.util.ImageLoader;
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.StringUtil;
	import com.snsoft.util.text.Text;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	[Style(name="roomCardImgBakSkin", type="Class")]
	
	[Style(name="roomCardImgMaskSkin", type="Class")]
	
	[Style(name="roomCardTitleBakSkin", type="Class")]
	
	/**
	 * 房间卡，左侧显示列表，点击房间，右侧显示对应的平面图及观察点 
	 * @author Administrator
	 * 
	 */	
	public class RoomCard extends UIComponent{
		
		private var _roomDO:RoomDO;
		
		private var tfdHeight:Number = 20;
		
		private var fontSize:int = 14;
		
		private var imgMask:MovieClip;
		
		private var imgLayer:Sprite;
		
		private var wateMovie:MovieClip;
		
		public function RoomCard(roomDO:RoomDO)
		{
			this.roomDO = roomDO;
			super();
		}
		
		/**
		 * 
		 */		
		private static var defaultStyles:Object = {
			roomCardImgBakSkin:"RoomCardImgBak_skin",
			roomCardImgMaskSkin:"RoomCardImgMask_skin",
			roomCardTitleBakSkin:"RoomCardTitleBak_skin"
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
			this.invalidate(InvalidationType.ALL,true);
			this.invalidate(InvalidationType.SIZE,true);
			this.mouseChildren = false;
			this.mouseEnabled = true;
			this.buttonMode = true;
			super.configUI();
		}
		
		/**
		 * 
		 * 
		 */		
		override protected function draw():void{
			var back:DisplayObject = getDisplayObjectInstance(getStyleValue("roomCardImgBakSkin"));
			back.height = this.height;
			back.width = this.width;
			this.addChild(back);
			
			wateMovie = SkinsUtil.createSkinByName("WateEffect");
			wateMovie.x = this.width / 2;
			wateMovie.y = (this.height + tfdHeight) / 2;
			this.addChild(wateMovie);
			
			imgLayer = new Sprite();
			this.addChild(imgLayer);
			loadTitleImg();
			
			var titleBak:DisplayObject = getDisplayObjectInstance(getStyleValue("roomCardTitleBakSkin"));
			
			this.addChild(titleBak);
			
			var tft:TextFormat = new TextFormat();
			tft.size = fontSize;
			tft.color = 0x19C3F7;
			tft.align = TextFormatAlign.CENTER;
			
			var n:int = int((this.width - 6) * 2 / fontSize);
			var txt:String = roomDO.textStr;
			if(StringUtil.getByteLen(roomDO.textStr) > n){
				txt = StringUtil.subCNStr(roomDO.textStr,n - 1)+"...";
			}
			
			var tfd:TextField = Text.creatTextField(txt,tft,false);
			tfd.width = this.width;
			tfd.height = tfdHeight;
			this.addChild(tfd);
			
		}
		
		/**
		 * 加载标题图片 
		 * 
		 */		
		public function loadTitleImg():void{
			if(roomDO.titleImgBitmap == null && roomDO.titleImgUrl != null){
				var imgl:ImageLoader = new ImageLoader();
				imgl.loadImage(roomDO.titleImgUrl);
				imgl.addEventListener(Event.COMPLETE,handlerLoaderTitleImgCmp);
			}
		}
		
		/**
		 *加载标题图片完成事件 
		 * @param e
		 * 
		 */		
		private function handlerLoaderTitleImgCmp(e:Event):void{
			wateMovie.stop();
			wateMovie.visible = false;
			var imgl:ImageLoader = e.currentTarget as ImageLoader;
			roomDO.titleImgBitmap = imgl.bitmapData;
			var bm:Bitmap = new Bitmap(roomDO.titleImgBitmap.clone(),"auto",true);
			bm.height = this.height - tfdHeight;
			bm.width = this.width;
			bm.y = tfdHeight;
			imgLayer.addChild(bm);
			
			imgMask = getDisplayObjectInstance(getStyleValue("roomCardImgMaskSkin")) as MovieClip;
			imgMask.height = this.height - tfdHeight;
			imgMask.width = this.width;
			imgMask.y = tfdHeight;
			imgLayer.addChild(imgMask);
			
			this.addEventListener(MouseEvent.MOUSE_OVER,handlerMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT,handlerMouseOut);
		}
		
		/**
		 * 显示特效，鼠标移上，标题图片变亮 
		 * @param e
		 * 
		 */		
		private function handlerMouseOver(e:Event):void{
			imgMask.alpha = 0;
		}
		
		/**
		 * 显示特效，鼠标移上，标题图片变亮暗 
		 * @param e
		 * 
		 */		
		private function handlerMouseOut(e:Event):void{
			imgMask.alpha = 1;
		}

		public function get roomDO():RoomDO
		{
			return _roomDO;
		}

		public function set roomDO(value:RoomDO):void
		{
			_roomDO = value;
		}

	}
}