package com.snsoft.imgedt{
	import com.adobe.crypto.MD5;
	import com.adobe.images.JPGEncoder;
	import com.snsoft.util.FileUtil;
	import com.snsoft.util.GridImageUtil;
	import com.snsoft.util.ImageLoader;
	import com.snsoft.util.SpriteUtil;
	import com.snsoft.util.complexEvent.CplxMouseDrag;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	public class ImageEditor extends UIComponent{
		
		private static var IMAGE_FRAME_SIZE_REVISE:Number = 2;
		
		private var BASE_URL:String = "http://127.0.0.1:8080/image-upload/";
		
		private var FILE_UPLOAD:String = "upload.jsp"; 
		
		private var PATH_UPLOAD:String = "admin/upload/";
		
		private var FILE_SAVE:String = "save.jsp";
		
		private var PATH_SAVE:String = "admin/save/";
		
		private var frameWidth:Number;
		
		private var frameHeight:Number;
		
		private var btnsLayer:Sprite = new Sprite();
		
		private var editorLayer:Sprite = new Sprite();
		
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
		
		private var fileReference:FileReference = new FileReference();
		
		private var fileFilterArray:Array = new Array(new FileFilter("图片 (*.jpg,*.png)","*.jpg;*.png"));
		
		private var editorWidth:Number;
		
		private var editorHeight:Number;
		
		private var currentSoleMD5FileName:String;
		
		private var currentImageBmd:BitmapData;
		
		public function ImageEditor(frameWidth:Number = 124,frameHeight:Number = 124){
			super();
			this.width = 320;
			this.height = 320;
			this.frameWidth = frameWidth;
			this.frameHeight = frameHeight;
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
			assistRect:"AssistRect"
			
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
			initEditor();
			initFileReference();
			initBtns();
			
		}
		
		private function initEditor():void{
			editorLayer.addChild(assistBackGridLayer);
			editorLayer.addChild(assistImagRotationLayer);
			editorLayer.addChild(assistMaskLayer);
			editorLayer.addChild(assistTopGridLayer);
			editorLayer.addChild(mainFrameLayer);
			editorLayer.addChild(mainImagRotationLayer);
			editorLayer.addChild(mainMaskLayer);
			
			assistImagRotationLayer.addChild(assistImagDragLimitLayer);
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
			//assistImagRotationLayer.rotation = 45;
			
			mainImagRotationLayer.x = assistImagRotationLayer.x;
			mainImagRotationLayer.y = assistImagRotationLayer.y;
			//mainImagRotationLayer.rotation = 45;
			
			mainImagLayer.mask = mainMaskLayer;
			assistImagLayer.mask = assistMaskLayer;
			
			var assistBackBmd:BitmapData = GridImageUtil.drawShepherdSheck(editorWidth,editorHeight);
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
			
			assistImagDragLimitLayer.x = ( - frameWidth) / 2;
			assistImagDragLimitLayer.y = ( - frameWidth) / 2;
			
			var dragLimit:MovieClip = getDisplayObjectInstance(getStyleValue(assistRect)) as MovieClip;
			dragLimit.width = frameWidth;
			dragLimit.height = frameHeight;
			dragLimit.visible = false;
			assistImagDragLimitLayer.addChild(dragLimit);
			
			var cplxd:CplxMouseDrag = new CplxMouseDrag();
			cplxd.addEvents(assistImagLayer,assistImagDragLimitLayer);
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
		}
		
		private function handlerSaveBtnClick(e:Event):void{
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
			var url:String = BASE_URL + FILE_SAVE + "?fileName=" + currentSoleMD5FileName;
			var request:URLRequest = new URLRequest(url);
			request.data = bytes;
			request.method = URLRequestMethod.POST;
			request.contentType = "application/octet-stream";
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,handlerSaveImageCmp);
			loader.load(request);
		}
		
		private function handlerSaveImageCmp(e:Event):void{
			trace("图片保存成功！");
		}
		
		private function handlerOpenBtnClick(e:Event):void{
			fileReference.browse(fileFilterArray);
		}
		
		private function handlerFileReferenceSelect(e:Event):void{
			trace("selected！");
			var req:URLRequest = new URLRequest(BASE_URL + FILE_UPLOAD);
			var variables:URLVariables = new URLVariables();
			currentSoleMD5FileName = FileUtil.creatSoleMD5FileName(fileReference.name);
			var fileName:String = FileUtil.getFileName(currentSoleMD5FileName);
			variables["fileNameMD5"] = fileName;
			req.data = variables;
			fileReference.upload(req);
		}
		
		private function handlerFileReferenceCmp(e:Event):void{
			trace("上传成功！"+fileReference.name);
			var url:String = BASE_URL + PATH_UPLOAD + currentSoleMD5FileName;
			var il:ImageLoader = new ImageLoader();
			il.loadImage(url);
			il.addEventListener(Event.COMPLETE,handlerLoadUploadImgCmp);
		}
		
		private function handlerLoadUploadImgCmp(e:Event):void{
			var il:ImageLoader = e.currentTarget as ImageLoader;
			currentImageBmd = il.bitmapData.clone();
			var mainbm:Bitmap = new Bitmap(il.bitmapData,"auto",true);
			SpriteUtil.deleteAllChild(mainImagLayer);
			mainImagLayer.addChild(mainbm);
			
			var assistbm:Bitmap = new Bitmap(il.bitmapData,"auto",true);
			SpriteUtil.deleteAllChild(assistImagLayer);
			assistImagLayer.addChild(assistbm);
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
		
	}
}