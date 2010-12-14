package com.snsoft.imgedt{
	import com.adobe.crypto.MD5;
	import com.adobe.images.JPGEncoder;
	import com.snsoft.util.FileUtil;
	import com.snsoft.util.GridImageUtil;
	import com.snsoft.util.ImageLoader;
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.SpriteUtil;
	import com.snsoft.util.complexEvent.CplxMouseDrag;
	import com.snsoft.util.text.EffectText;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	public class ImageEditor extends UIComponent{
		
		public static const SAVE_COMPLETE:String = "SAVE_COMPLETE";
		
		private static var IMAGE_FRAME_SIZE_REVISE:Number = 4;
		
		private var rootUrl:String = "http://127.0.0.1:8080/image-upload/";
		
		private var uploadFile:String = "upload.jsp"; 
		
		private var uploadBaseUrl:String = "admin/upload/";
		
		private var saveFile:String = "save.jsp";
		
		private var saveBaseUrl:String = "admin/save/";
		
		private var frameWidth:Number;
		
		private var frameHeight:Number;
		
		private var btnsLayer:Sprite = new Sprite();
		
		private var editorLayer:Sprite = new Sprite();
		
		private var waitEffectLayer:Sprite = new Sprite();
		
		private var msgLayer:Sprite = new Sprite();
		
		private var assistImagLayer:Sprite = new Sprite();
		
		private var assistImagDragLimitLayer:Sprite = new Sprite();
		
		private var assistImagRotationLayer:Sprite = new Sprite();
		
		private var assistMaskLayer:Sprite = new Sprite();
		
		private var assistTopGridLayer:Sprite = new Sprite();
		
		private var assistBackGridLayer:Sprite = new Sprite();
		
		private var mainImagLayer:Sprite = new Sprite();
		
		private var mainImagRotationLayer:Sprite = new Sprite();
		
		private var mainMaskLayer:Sprite = new Sprite();
		
		private var mainFrameLayer:Sprite = new Sprite();
		
		private var mainFrame:MovieClip;
		
		private var dragLimit:MovieClip;
		
		private var fileReference:FileReference = new FileReference();
		
		private var fileFilterArray:Array = new Array(new FileFilter("图片 (*.jpg,*.png)","*.jpg;*.png"));
		
		private var editorWidth:Number;
		
		private var editorHeight:Number;
		
		private var currentSoleMD5FileName:String;
		
		private var currentImageBmd:BitmapData;
		
		private var waiting:Boolean = false;
		
		//private var waitTimer:Timer = new Timer(15000,1);
		
		private var waitEffect:Sprite;
		
		private var msgmc:Sprite = new Sprite();
		
		private var msgTextField:TextField;
		
		private var msgTimer:Timer = new Timer(3000,1);
		
		private var _saveFileUrl:String;
		
		public function ImageEditor(frameWidth:Number = 124,
									frameHeight:Number = 124,
									rootUrl:String = null,
									uploadFile:String = null,
									uploadBaseUrl:String = null,
									saveFile:String = null,
									saveBaseUrl:String = null){
			super();
			this.width = 320;
			this.height = 320;
			this.frameWidth = frameWidth;
			this.frameHeight = frameHeight;
			
			if(rootUrl != null){
				this.rootUrl = rootUrl;
			}
			if(uploadFile != null){
				this.uploadFile = uploadFile;
			}
			if(uploadBaseUrl != null){
				this.uploadBaseUrl = uploadBaseUrl;
			}
			if(saveFile != null){
				this.saveFile = saveFile;
			}
			if(saveBaseUrl != null){
				this.saveBaseUrl = saveBaseUrl;
			}
		}
		
		/**
		 * 
		 */			
		private static var defaultStyles:Object = {
			
			rotationRightBtnDefaultSkin:"RotationRightBtn_defaultSkin",
			rotationLeftBtnDefaultSkin:"RotationLeftBtn_defaultSkin",
			saveBtnDefaultSkin:"SaveBtn_defaultSkin",
			zoomInBtnDefaultSkin:"ZoomInBtn_defaultSkin",
			zoomOutBtnDefaultSkin:"ZoomOutBtn_defaultSkin",
			resetBtnDefaultSkin:"ResetBtn_defaultSkin",
			openBtnDefaultSkin:"OpenBtn_defaultSkin",
			imageFrameDefaultSkin:"ImageFrame_defaultSkin",
			assistRect:"AssistRect",
			waitBackDefaultSkin:"WaitBack_defaultSkin",
			msgBackDefaultSkin:"MsgBack_defaultSkin"
			
			
		};
		
		private static var rotationRightBtnDefaultSkin:String = "rotationRightBtnDefaultSkin";
		
		private static var rotationLeftBtnDefaultSkin:String = "rotationLeftBtnDefaultSkin";
		
		private static var saveBtnDefaultSkin:String = "saveBtnDefaultSkin";
		
		private static var zoomInBtnDefaultSkin:String = "zoomInBtnDefaultSkin";
		
		private static var zoomOutBtnDefaultSkin:String = "zoomOutBtnDefaultSkin";
		
		private static var resetBtnDefaultSkin:String = "resetBtnDefaultSkin";
		
		private static var openBtnDefaultSkin:String = "openBtnDefaultSkin";
		
		private static var imageFrameDefaultSkin:String = "imageFrameDefaultSkin";
		
		private static var assistRect:String = "assistRect";
		
		private static var waitBackDefaultSkin:String = "waitBackDefaultSkin";
		
		private static var msgBackDefaultSkin:String = "msgBackDefaultSkin";
		
		
		
		/**
		 * 
		 * 绘制组件显示
		 */		
		override protected function draw():void{
			
			var btnsHeight:Number = 35;
			
			editorWidth = this.width;
			editorHeight = this.height - btnsHeight;
			
			this.addChild(editorLayer);
			editorLayer.y = btnsHeight;
			this.addChild(btnsLayer);
			this.addChild(waitEffectLayer);
			this.addChild(msgLayer);
			initEditor();
			initFileReference();
			initBtns();
			initWaitEffect();
			initMsgEffect();
			//waitTimer.addEventListener(TimerEvent.TIMER_COMPLETE,handlerWaitTimerCmp);
			msgTimer.addEventListener(TimerEvent.TIMER_COMPLETE,handlerMsgTimerCmp);
		}
		
		private function handlerWaitTimerCmp(e:Event):void{
			setWaitEffect(false);
			setMsg("链接超时！");
		}
		
		private function handlerMsgTimerCmp(e:Event):void{
			msgmc.visible = false;
		}
		
		private function initEditor():void{
			editorLayer.addChild(assistBackGridLayer);
			editorLayer.addChild(assistImagRotationLayer);
			editorLayer.addChild(assistImagDragLimitLayer);
			editorLayer.addChild(assistMaskLayer);
			editorLayer.addChild(assistTopGridLayer);
			editorLayer.addChild(mainFrameLayer);
			editorLayer.addChild(mainImagRotationLayer);
			editorLayer.addChild(mainMaskLayer);
			
			assistImagRotationLayer.addChild(assistImagLayer);
			mainImagRotationLayer.addChild(mainImagLayer);
			
			assistTopGridLayer.mouseEnabled = false;
			assistTopGridLayer.mouseChildren = false;
			mainFrameLayer.mouseEnabled = false;
			mainFrameLayer.mouseChildren = false;
			mainImagRotationLayer.mouseEnabled = false;
			mainImagRotationLayer.mouseChildren = false;
			mainMaskLayer.mouseEnabled = false;
			mainMaskLayer.mouseChildren = false;
			
			assistImagRotationLayer.x = editorWidth / 2;
			assistImagRotationLayer.y = editorHeight / 2;
			
			assistImagDragLimitLayer.x = editorWidth / 2;
			assistImagDragLimitLayer.y = editorHeight / 2;
			assistImagDragLimitLayer.mouseEnabled = false;
			assistImagDragLimitLayer.mouseChildren = false;
			
			//assistImagRotationLayer.rotation = 45;
			
			mainImagRotationLayer.x = assistImagRotationLayer.x;
			mainImagRotationLayer.y = assistImagRotationLayer.y;
			//mainImagRotationLayer.rotation = 45;
			
			mainImagLayer.mask = mainMaskLayer;
			assistImagLayer.mask = assistMaskLayer;
			
			var assistBackBmd:BitmapData = GridImageUtil.drawShepherdSheck(editorWidth,editorHeight,8,8,0xffffffff,0xffbbbbbb);
			var assistBackbm:Bitmap = new Bitmap(assistBackBmd);
			assistBackGridLayer.addChild(assistBackbm);
			
			var assistTopGridBmd:BitmapData = GridImageUtil.drawGridLine(editorWidth,editorHeight);
			var assistTopGridbm:Bitmap = new Bitmap(assistTopGridBmd);
			
			assistTopGridLayer.addChild(assistTopGridbm);
			
			var assistMask:MovieClip = getDisplayObjectInstance(getStyleValue(assistRect)) as MovieClip;
			assistMask.width = editorWidth;
			assistMask.height = editorHeight;
			assistMaskLayer.addChild(assistMask);
			
			mainImagLayer.x = - mainImagRotationLayer.x;
			mainImagLayer.y = - mainImagRotationLayer.y;
			
			assistImagLayer.x = - assistImagRotationLayer.x;
			assistImagLayer.y = - assistImagRotationLayer.y;
			
			
			
			dragLimit = getDisplayObjectInstance(getStyleValue(assistRect)) as MovieClip;
			setDragLimit(dragLimit,1);
			assistImagDragLimitLayer.addChild(dragLimit);
			
			var cplxd:CplxMouseDrag = new CplxMouseDrag();
			cplxd.addEvents(assistImagLayer,dragLimit);
			cplxd.addEventListener(CplxMouseDrag.DRAG_MOVE_EVENT,handlerDragMove);
			
			mainFrame = getDisplayObjectInstance(getStyleValue(imageFrameDefaultSkin)) as MovieClip;
			mainFrame.width = frameWidth + IMAGE_FRAME_SIZE_REVISE;
			mainFrame.height = frameHeight + IMAGE_FRAME_SIZE_REVISE;
			mainFrame.x = (editorWidth - frameWidth) / 2;
			mainFrame.y = (editorHeight - frameHeight) / 2;
			mainFrameLayer.addChild(mainFrame);
			
			var mainMask:MovieClip = getDisplayObjectInstance(getStyleValue(assistRect)) as MovieClip;
			mainMask.x = mainFrame.x;
			mainMask.y = mainFrame.y;
			mainMask.width = frameWidth;
			mainMask.height = frameWidth;
			mainMaskLayer.addChild(mainMask);
		}
		
		private function handlerDragMove(e:Event):void{
			var cplxd:CplxMouseDrag = e.currentTarget as CplxMouseDrag;
			var rect:Rectangle = cplxd.getDragRect();
			mainImagLayer.x = rect.x;
			mainImagLayer.y = rect.y;
		}
		
		private function initFileReference():void{
			fileReference.addEventListener(Event.SELECT,handlerFileReferenceSelect);
			fileReference.addEventListener(Event.COMPLETE,handlerFileReferenceCmp);
			fileReference.addEventListener(IOErrorEvent.IO_ERROR,handlerIOError);
		}
		
		private function initMsgEffect():void{
			
			var msgBack:MovieClip = getDisplayObjectInstance(getStyleValue(msgBackDefaultSkin)) as MovieClip;
			msgBack.width = this.width;
			msgBack.height = 25;
			msgmc.addChild(msgBack);
			msgTextField = EffectText.creatShadowTextField("",new TextFormat());
			msgTextField.width = this.width;
			msgTextField.height = 25;
			msgTextField.x = this.width / 2;
			msgTextField.y = 4;
			msgTextField.autoSize = TextFieldAutoSize.CENTER;
			msgmc.addChild(msgTextField);
			msgmc.x = 0;
			msgmc.y = this.height - msgBack.height; 
			msgmc.visible = false;
			msgLayer.addChild(msgmc);
		}
		
		public function setMsg(msg:String):void{
			msgTextField.text = msg;
			var tft:TextFormat = new TextFormat(null,14,0x000000);
			msgTextField.setTextFormat(tft);
			msgmc.visible = true;
			msgTimer.stop();
			msgTimer.start();
		}
		
		private function initWaitEffect():void{
			waitEffect = new Sprite();
			var waitBack:MovieClip = getDisplayObjectInstance(getStyleValue(waitBackDefaultSkin)) as MovieClip;
			waitBack.width = this.width;
			waitBack.height = this.height;
			waitEffect.addChild(waitBack);
			
			var loading:MovieClip = SkinsUtil.createSkinByName("Loading");
			waitEffect.addChild(loading);
			loading.x = editorWidth / 2 + editorLayer.x ;
			loading.y = editorHeight / 2 + editorLayer.y;
			
			waitEffect.visible = false;
			waitEffectLayer.addChild(waitEffect);
		}
		
		private function setWaitEffect(b:Boolean):void{
			//waitTimer.start();
			waiting = b;
			waitEffect.visible = b;
		}
		
		private function initBtns():void{
			var openBtn:MovieClip = getDisplayObjectInstance(getStyleValue(openBtnDefaultSkin)) as MovieClip;
			openBtn.buttonMode = true;
			var saveBtn:MovieClip = getDisplayObjectInstance(getStyleValue(saveBtnDefaultSkin)) as MovieClip;
			saveBtn.buttonMode = true;
			var zoomInBtn:MovieClip = getDisplayObjectInstance(getStyleValue(zoomInBtnDefaultSkin)) as MovieClip;
			zoomInBtn.buttonMode = true;
			var zoomOutBtn:MovieClip = getDisplayObjectInstance(getStyleValue(zoomOutBtnDefaultSkin)) as MovieClip;
			zoomOutBtn.buttonMode = true;
			var rotationLeftBtn:MovieClip = getDisplayObjectInstance(getStyleValue(rotationLeftBtnDefaultSkin)) as MovieClip;
			rotationLeftBtn.buttonMode = true;
			var rotationRightBtn:MovieClip = getDisplayObjectInstance(getStyleValue(rotationRightBtnDefaultSkin)) as MovieClip;
			rotationRightBtn.buttonMode = true;
			var resetBtn:MovieClip = getDisplayObjectInstance(getStyleValue(resetBtnDefaultSkin)) as MovieClip;
			resetBtn.buttonMode = true;
			
			btnsLayer.addChild(openBtn);
			btnsLayer.addChild(saveBtn);
			setBtnPlace(btnsLayer,saveBtn,10);
			btnsLayer.addChild(zoomInBtn);
			setBtnPlace(btnsLayer,zoomInBtn,10);
			btnsLayer.addChild(zoomOutBtn);
			setBtnPlace(btnsLayer,zoomOutBtn,10);
			btnsLayer.addChild(rotationLeftBtn);
			setBtnPlace(btnsLayer,rotationLeftBtn,10);
			btnsLayer.addChild(rotationRightBtn);
			setBtnPlace(btnsLayer,rotationRightBtn,10);
			btnsLayer.addChild(resetBtn);
			setBtnPlace(btnsLayer,resetBtn,10);
			
			openBtn.addEventListener(MouseEvent.CLICK,handlerOpenBtnClick);
			saveBtn.addEventListener(MouseEvent.CLICK,handlerSaveBtnClick);
			rotationLeftBtn.addEventListener(MouseEvent.CLICK,handlerRotationLeftBtnClick);
			rotationRightBtn.addEventListener(MouseEvent.CLICK,handlerRotationRightBtnClick);
			zoomInBtn.addEventListener(MouseEvent.CLICK,handlerRotationZoomInBtnClick);
			zoomOutBtn.addEventListener(MouseEvent.CLICK,handlerRotationZoomOutBtnClick);
			resetBtn.addEventListener(MouseEvent.CLICK,handlerRotationResetBtnClick);
			
		}
		
		private function handlerRotationResetBtnClick(e:Event):void{
			resetImage();
		}
		
		
		
		private function handlerRotationZoomInBtnClick(e:Event):void{
			imageZoom(0.1);
		}
		
		private function handlerRotationZoomOutBtnClick(e:Event):void{
			imageZoom(-0.1);
		}
		
		private function handlerRotationLeftBtnClick(e:Event):void{
			imageRotation(-10);
		}
		
		private function handlerRotationRightBtnClick(e:Event):void{
			imageRotation(10);
		}
		
		
		
		private function resetImage():void{
			mainImagRotationLayer.rotation = 0;
			mainImagRotationLayer.scaleX = 1;
			mainImagRotationLayer.scaleY = 1;
			
			assistImagRotationLayer.rotation = 0;
			assistImagRotationLayer.scaleX = 1;
			assistImagRotationLayer.scaleY = 1;
			
			mainImagLayer.x = -mainImagRotationLayer.x;
			mainImagLayer.y = -mainImagRotationLayer.y;
			
			assistImagLayer.x = -assistImagRotationLayer.x;
			assistImagLayer.y = -assistImagRotationLayer.y;
			
			setDragLimit(dragLimit,1);
		}
		
		private function imageRotation(rotation:int):void{
			mainImagRotationLayer.rotation += rotation;
			assistImagRotationLayer.rotation += rotation;
		}
		
		private function imageZoom(scale:Number):void{
			
			if(mainImagRotationLayer.scaleX < 10){
				var p:Number = 100;
				scale = scale + 1;
				mainImagRotationLayer.scaleX *= scale;
				mainImagRotationLayer.scaleY *= scale;
				
				assistImagRotationLayer.scaleX *= scale;
				assistImagRotationLayer.scaleY *= scale;
				
				setDragLimit(dragLimit,1 / mainImagRotationLayer.scaleX);
			}
		}
		
		private function setDragLimit(dragLimit:Sprite,scale:Number):void{
			var dragWidth:Number = frameWidth * scale;
			var dragHeight:Number = frameHeight * scale;
			dragLimit.x = - dragWidth / 2;
			dragLimit.y = - dragWidth / 2;
			dragLimit.width = dragWidth;
			dragLimit.height = dragHeight;
		}
		
		private function handlerSaveBtnClick(e:Event):void{
			if(!waiting){
				if(mainImagLayer.numChildren > 0){
					setWaitEffect(true);
					var rect:Rectangle = new Rectangle();
					rect.x = assistImagDragLimitLayer.x - assistImagLayer.x;
					rect.y = assistImagDragLimitLayer.y - assistImagLayer.y;
					rect.width = frameWidth;
					rect.height = frameHeight;
					var ilc:BitmapData = new BitmapData(frameWidth,frameHeight,true,0x00ffffffff);
					var matrix:Matrix = new Matrix();
					matrix.translate(-mainFrame.x ,-mainFrame.y );
					ilc.draw(editorLayer,matrix);
					var jpge:JPGEncoder = new JPGEncoder(100);
					var bytes:ByteArray = jpge.encode(ilc);
					var url:String = rootUrl + saveFile + "?fileName=" + currentSoleMD5FileName;
					var request:URLRequest = new URLRequest(url);
					request.data = bytes;
					request.method = URLRequestMethod.POST;
					request.contentType = "application/octet-stream";
					var loader:URLLoader = new URLLoader();
					loader.addEventListener(Event.COMPLETE,handlerSaveImageCmp);
					loader.addEventListener(IOErrorEvent.IO_ERROR,handlerIOError);
					loader.load(request);
				}
				else {
					setMsg("没有需要保存的图片！");
				}
			}
		}
		
		private function handlerSaveImageCmp(e:Event):void{
			setMsg("图片保存成功！");
			this.dispatchEvent(new Event(SAVE_COMPLETE));
			this.saveFileUrl = rootUrl + saveBaseUrl + currentSoleMD5FileName;
			setWaitEffect(false);
		}
		
		private function handlerOpenBtnClick(e:Event):void{
			fileReference.browse(fileFilterArray);
		}
		
		private function handlerFileReferenceSelect(e:Event):void{
			if(!waiting){
				setWaitEffect(true);
				var req:URLRequest = new URLRequest(rootUrl + uploadFile);
				var variables:URLVariables = new URLVariables();
				currentSoleMD5FileName = FileUtil.creatSoleMD5FileName(fileReference.name);
				var fileName:String = FileUtil.getFileName(currentSoleMD5FileName);
				variables["fileNameMD5"] = fileName;
				req.data = variables;
				fileReference.upload(req);
			}
		}
		
		private function handlerIOError(e:Event):void{
			setWaitEffect(false);
			setMsg("链接服务器出错！");
		}
		
		private function handlerFileReferenceCmp(e:Event):void{
			var url:String = rootUrl + uploadBaseUrl + currentSoleMD5FileName;
			var il:ImageLoader = new ImageLoader();
			il.loadImage(url);
			il.addEventListener(Event.COMPLETE,handlerLoadUploadImgCmp);
			il.addEventListener(IOErrorEvent.IO_ERROR,handlerIOError);
		}
		
		private function handlerLoadUploadImgCmp(e:Event):void{
			resetImage();
			var il:ImageLoader = e.currentTarget as ImageLoader;
			currentImageBmd = il.bitmapData.clone();
			var mainbm:Bitmap = new Bitmap(il.bitmapData,"auto",true);
			SpriteUtil.deleteAllChild(mainImagLayer);
			mainImagLayer.addChild(mainbm);
			
			var assistbm:Bitmap = new Bitmap(il.bitmapData,"auto",true);
			SpriteUtil.deleteAllChild(assistImagLayer);
			assistImagLayer.addChild(assistbm);
			setWaitEffect(false);
			setMsg("图片上传成功！");
		}
		
		public function setBtnPlace(baseObj:DisplayObject,obj:DisplayObject,space:Number):void{
			var rect:Rectangle = baseObj.getRect(this);
			obj.x = rect.right + space;
			obj.y = 0;
		}
		
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
			super.configUI();
		}
		
		public function get saveFileUrl():String
		{
			return _saveFileUrl;
		}
		
		public function set saveFileUrl(value:String):void
		{
			_saveFileUrl = value;
		}
		
		
	}
}