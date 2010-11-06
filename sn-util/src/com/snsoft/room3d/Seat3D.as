package com.snsoft.room3d{
	import ascb.util.StringUtilities;
	
	import com.adobe.crypto.MD5;
	import com.snsoft.util.HashVector;
	import com.snsoft.util.ShapeUtil;
	import com.snsoft.util.SkinsUtil;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.materials.BitmapColorMaterial;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.MovieAssetMaterial;
	import org.papervision3d.materials.MovieMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.objects.primitives.Sphere;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	
	/**
	 * 3D展现对象，把图片帖图到3D图形上，并且按钮控制3显示 
	 * @author Administrator
	 * 
	 */	
	public class Seat3D extends UIComponent{
		
		/**
		 * 播放时进入下一帧事件互斥标记 
		 */		
		private var sign:Boolean = true;
		
		/**
		 *  无操作时，刷新3D显示最多次数最大 
		 */		
		private static const MAX_REFRESH_WAIT_TIMES:uint = 20;
		
		/**
		 * 无操作时最大刷新次数 
		 */		
		private var refreshWaitTimes:int = MAX_REFRESH_WAIT_TIMES;
		
		/**
		 *等待一段时间后，自动播放计数器最大计数 
		 */		
		private static const AUTO_MOVE_COUNT_MAX:int = 150;
		
		/**
		 *控制按钮对象 
		 */		
		private var menu:Menu;
		
		/**
		 *是否自动播放 
		 */		
		private var autoMove:Boolean;
		
		private var _seatDO:SeatDO;
		
		/**
		 * 摄像机水平旋转角度 
		 */		
		private var _cameraRotationY:Number;
		
		/**
		 * 3D展现宽度 
		 */		
		private var seat3DWidth:Number;
		
		/**
		 * 3D展现高度 
		 */		
		private var seat3DHeight:Number;
		
		/**
		 * 当前自动播放的方向 
		 */		
		private var currentMoveDirection:String = "";
		
		/**
		 * 摄像机旋转事件类型 
		 */		
		public static const CAMERA_ROTATION_EVENT:String = "CAMERA_ROTATION_EVENT";
		
		/**
		 * 3D展现初始化完成事件类型
		 */		
		public static const SEAT3D_CMP_EVENT:String = "SEAT3D_CMP_EVENT";
		
		public static const MURAL_CLICK:String = "MURAL_CLICK";
		
		public static const SEAT_LINK_CLICK:String = "SEAT_LINK_CLICK";
		
		/**
		 * 等待一段时间后，摄像头步进角度值 
		 */		
		private static const ROTATION_STEP:Number = 0.1;
		
		/**
		 * 方向键控制自动旋转时，摄像头步进角度值  
		 */		
		private static const AUTO_ROTATION_STEP:Number = 0.4;
		
		/**
		 *鼠标拖动旋转时，最小拖动响应阈值 
		 */		
		private static const MOUSE_MIN_MOVE:Number = 20;
		
		/**
		 * 3D视窗 全影图 
		 */		
		private var viewportPanorama:Viewport3D;
		
		/**
		 * 3D渲染器 全影图
		 */		
		private var rendererPanorama:BasicRenderEngine;
		
		/**
		 * 3D场景  全影图
		 */		
		private var scenePanorama:Scene3D;
		
		/**
		 * 摄像机  全影图
		 */		
		private var cameraPanorama:Camera3D;
		
		/**
		 * 3D视窗 全影图上装饰
		 */		
		private var viewportMural:Viewport3D;
		
		/**
		 * 3D渲染器 全影图上装饰
		 */		
		private var rendererMural:BasicRenderEngine;
		
		/**
		 * 3D场景  全影图上装饰
		 */		
		private var sceneMural:Scene3D;
		
		/**
		 * 摄像机  全影图上装饰
		 */		
		private var cameraMural:Camera3D;
		
		/**
		 * 正方体全景显示对象 
		 */		
		private var cube:Cube;
		
		/**
		 *球体全景显示对象 
		 */		
		private var ball:Sphere;
		
		/**
		 * 鼠标拖动时，按下时的坐标 
		 */		
		private var mouseDownPlace:Point;
		
		/**
		 * 是否鼠标按下的标记 
		 */		
		private var isMouseDown:Boolean = false;
		
		/**
		 *是否按钮按下的标记 
		 */		
		private var isBtnDown:Boolean = false;
		
		/**
		 *按钮点击时，摄像机X轴，Y轴旋转步进值 
		 */		
		private var btnStepP:Point = new Point();
		
		/**
		 * 摄像机放大倍数 
		 */		
		private var zoomp:Number = 0;
		
		/**
		 * 鼠标点按下时，显示的鼠标皮肤样式 
		 */		
		private var downMouse:MovieClip;
		
		/**
		 * 鼠标点按下并拖动时，显示的鼠标皮肤样式
		 */		
		private var downMoveMouse:MovieClip;
		
		/**
		 * 等待一段时间后，自动播放计数
		 */		
		private var autoMoveCount:int = AUTO_MOVE_COUNT_MAX;
		
		private var _isDraw:Boolean = false;
		
		/**
		 * 显示边框 
		 */		
		private var frame:MovieClip;
		
		
		private var btn2DLayer:Sprite;		
		
		private var btnMask:MovieClip;
		/**
		 * 正方体 1/2 边长 
		 */		
		private static const CUBE_SIDE_HARF_LEN:Number = 500;
		
		/**
		 * 3D场景中壁画按钮位置对象
		 */		
		private var btn3DMuralFingerV:Vector.<Plane> = new Vector.<Plane>();
		
		/**
		 * 2D场景中壁画按钮位置对象
		 */	
		private var btn2DMuralBtnV:Vector.<MovieClip> = new Vector.<MovieClip>();
		
		/**
		 * 3D场景中位置切换按钮位置对象
		 */		
		private var btn3DSeatLinkFingerV:Vector.<Plane> = new Vector.<Plane>();
		
		/**
		 * 2D场景中位置切换按钮位置对象
		 */	
		private var btn2DSeatLinkBtnV:Vector.<MovieClip> = new Vector.<MovieClip>();
		
		
		/**
		 * 3D场景中等待特效位置对象
		 */		
		private var btn3DWaitMovieV:Vector.<Plane> = new Vector.<Plane>();
		
		/**
		 * 2D场景中等待特效位置对象
		 */	
		private var btn2DWaitMovieV:Vector.<MovieClip> = new Vector.<MovieClip>();
		
		/**
		 * 一行显示多少个等待动画 
		 */		
		private var WAIT_MOVIE_NUM_X:int = 3;
		
		/**
		 * 一列显示多少个等待动画 
		 */		
		private var WAIT_MOVIE_NUM_Y:int = 3;
		
		private var FACE_NUM_3D:int = 6;
		
		/**
		 * 当前壁画数据对象 
		 */		
		private var _currentMuralDO:MuralDO;
		
		/**
		 * 当前观察点链接数据对象 
		 */		
		private var _currentSeatLinkDO:SeatLinkDO;
		
		
		//private var plane:Plane;
		
		/**
		 * 等待加载动画 
		 */		
		//private var waitMovie:MovieClip;
		
		/**
		 *加载数量 
		 */		
		private var loadCount:int = 0;
				
		private var materialFileTypeHV:HashVector = new HashVector();
		
		
		/**
		 * 构造方法 
		 * @param menu
		 * @param seatDO
		 * @param seat3DWidth
		 * @param seat3DHeight
		 * 
		 */		
		public function Seat3D(menu:Menu,seatDO:SeatDO,seat3DWidth:Number,seat3DHeight:Number){
			this.menu = menu;
			this._seatDO = seatDO;
			this.seat3DWidth = seat3DWidth;
			this.seat3DHeight = seat3DHeight;
			super();
		}
		
		
		/**
		 * 
		 */			
		private static var defaultStyles:Object = {
			seatPointSkin:"SeatPoint_Skin",
			seat3DFrameSkin:"Seat3D_frameSkin",
			seat3DMouseDownMoveSkin:"Seat3DMouse_downMoveSkin",
			seat3DMouseDownSkin:"Seat3DMouse_downSkin",
			seat3DFingerpostDefaultSkin:"Seat3DFingerpost_defaultSkin",
			seat3DMuralBtnDefaultSkin:"Seat3DMuralBtn_defaultSkin",
			seat3DPlaceLinkBtnDefaultSkin:"Seat3DPlaceLinkBtn_defaultSkin",
			seat3DBtnMaskDefaultSkin:"Seat3DBtnMask_defaultSkin"
			
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
			super.configUI();
			this.addEventListener(Event.EXIT_FRAME,handler);
		}
		
		/**
		 * 不知道为什么有时候组件不自动执行draw 方法，可能是创建地图
		 * @param e
		 * 
		 */		
		private function handler(e:Event):void{
			this.removeEventListener(Event.EXIT_FRAME,handler);
			if(!isDraw){
				this.drawNow();
			}
		}
		
		/**
		 * 
		 * 绘制组件显示
		 */		
		override protected function draw():void{
			trace("Seat3D draw");
			if(!isDraw){
				_isDraw = true;
				trace("Seat3D draw false");
				init3D();
				create3DDisplayObject();
				creatDownMouse();
			}
			else {
				this.dispatchEvent(new Event(SEAT3D_CMP_EVENT));
			}
		}
		
		
		
		
		/**
		 * 初始化3D显示对象 
		 * 
		 */		
		private function init3D():void
		{
			trace("init3D()");
			/*
			waitMovie = SkinsUtil.createSkinByName("WaitEffect");
			waitMovie.x = seat3DWidth / 2;
			waitMovie.y = seat3DHeight / 2;
			waitMovie.visible = false;
			this.addChild(waitMovie);
			*/
			// Create container sprite and center it in the stage
			viewportPanorama = new Viewport3D(seat3DWidth,seat3DHeight);
			viewportPanorama.x = 0;
			viewportPanorama.y = 0;
			this.addChild( viewportPanorama );
			
			viewportMural = new Viewport3D(seat3DWidth,seat3DHeight);
			viewportMural.x = 0;
			viewportMural.y = 0;
			this.addChild( viewportMural );
			
			
			
			
			frame = getDisplayObjectInstance(getStyleValue("seat3DFrameSkin")) as MovieClip;
			frame.width = seat3DWidth;
			frame.height = seat3DHeight;
			this.addChild(frame);
			
			menu.addEventListener("left_DOWN",handlerMenuMouseEvent);
			menu.addEventListener("right_DOWN",handlerMenuMouseEvent);
			menu.addEventListener("up_DOWN",handlerMenuMouseEvent);
			menu.addEventListener("down_DOWN",handlerMenuMouseEvent);
			menu.addEventListener("def_DOWN",handlerMenuMouseEvent);
			menu.addEventListener("zoomIn_DOWN",handlerMenuMouseEvent);
			menu.addEventListener("zoomOut_DOWN",handlerMenuMouseEvent);
			
			menu.addEventListener("left_UP",handlerMenuMouseUp);
			menu.addEventListener("right_UP",handlerMenuMouseUp);
			menu.addEventListener("up_UP",handlerMenuMouseUp);
			menu.addEventListener("down_UP",handlerMenuMouseUp);
			menu.addEventListener("def_UP",handlerMenuMouseUp);
			menu.addEventListener("zoomIn_UP",handlerMenuMouseUp);
			menu.addEventListener("zoomOut_UP",handlerMenuMouseUp);
			menu.addEventListener("auto_DOWN",handlerMenuMouseAutoClick);
			
			// Create readerer
			rendererPanorama = new BasicRenderEngine();
			
			// Create scene
			scenePanorama = new Scene3D();
			
			// Create camera
			cameraPanorama = new Camera3D();
			
			// Create readerer
			rendererMural = new BasicRenderEngine();
			
			// Create scene
			sceneMural = new Scene3D();
			
			// Create camera
			cameraMural = new Camera3D();
			
			this.addEventListener(Event.REMOVED_FROM_STAGE,handlerRemoveThis);
			
			btn2DLayer = new Sprite();
			this.addChild(btn2DLayer);
			
			btn2DLayer.addEventListener(MouseEvent.MOUSE_OVER,handlerMouseOver);
			btn2DLayer.addEventListener(MouseEvent.MOUSE_OUT,handlerMouseOut);
			
			btnMask = getDisplayObjectInstance(getStyleValue("seat3DBtnMaskDefaultSkin")) as MovieClip;
			btnMask.width = this.seat3DWidth;
			btnMask.height = this.seat3DHeight;
			this.addChild(btnMask);
			btn2DLayer.mask = btnMask;
			
			var murals:Vector.<MuralDO> = this.seatDO.murals;
			for(var i:int =0;i<murals.length;i++){
				var mdo:MuralDO = murals[i];
				var muralBtn:MovieClip = getDisplayObjectInstance(getStyleValue("seat3DMuralBtnDefaultSkin")) as MovieClip;
				muralBtn.visible = false;
				btn2DLayer.addChild(muralBtn);
				btn2DMuralBtnV.push(muralBtn);
				muralBtn.muralsIndex = i;
				muralBtn.addEventListener(MouseEvent.CLICK,handlerMuralBtnClick);
				
			}
			
			var seatLinks:Vector.<SeatLinkDO> = this.seatDO.seatLinks;
			for(var ii:int =0;ii<seatLinks.length;ii++){
				var sdo:SeatLinkDO = seatLinks[ii];
				var seatLinkBtn:MovieClip = getDisplayObjectInstance(getStyleValue("seat3DPlaceLinkBtnDefaultSkin")) as MovieClip;
				seatLinkBtn.visible = false;
				btn2DLayer.addChild(seatLinkBtn);
				btn2DSeatLinkBtnV.push(seatLinkBtn);
				seatLinkBtn.seatLinksIndex = ii;
				seatLinkBtn.addEventListener(MouseEvent.CLICK,handlerSeatLinkBtnClick);	
			}
			
			for(var i3:int = 0;i3 < FACE_NUM_3D;i3 ++){
				var waitN:int = WAIT_MOVIE_NUM_X * WAIT_MOVIE_NUM_Y;
				for(var j3:int =0;j3 < waitN ;j3++){
					var waitMovie:MovieClip = SkinsUtil.createSkinByName("WaitEffect");
					waitMovie.visible = false;
					btn2DLayer.addChild(waitMovie);
					btn2DWaitMovieV.push(waitMovie);
				}
			}
			
		}
		
		/**
		 *创建鼠标按下皮肤 
		 * 
		 */		
		private function creatDownMouse():void{
			downMouse = getDisplayObjectInstance(getStyleValue("seat3DMouseDownSkin")) as MovieClip;
			downMoveMouse = getDisplayObjectInstance(getStyleValue("seat3DMouseDownMoveSkin")) as MovieClip;
			this.addChild(downMouse);
			this.addChild(downMoveMouse);
			downMouse.mouseEnabled = false;
			downMoveMouse.mouseEnabled = false;
			downMouse.visible = false;
			downMoveMouse.visible = false;
		}
		
		
		/**
		 * 创建3D显示物体
		 * 
		 */		
		private function create3DDisplayObject():void{
			trace("create3DDisplayObject()");
			
			//添加壁画标记点
			var murals:Vector.<MuralDO> = this.seatDO.murals;
			for(var i:int =0;i<murals.length;i++){
				var mdo:MuralDO = murals[i];
				var muralPlane:Plane = creatPlane(new Vector3D(mdo.x,mdo.y,0,mdo.type));
				btn3DMuralFingerV.push(muralPlane);
				sceneMural.addChild(muralPlane);
			}
			
			//添加观察点链接标记点
			var seatLinks:Vector.<SeatLinkDO> = this.seatDO.seatLinks;
			for(var ii:int =0;ii<seatLinks.length;ii++){
				var sdo:SeatLinkDO = seatLinks[ii];
				var seatLinkPlane:Plane = creatPlane(new Vector3D(sdo.x,sdo.y,0,sdo.type));
				btn3DSeatLinkFingerV.push(seatLinkPlane);
				sceneMural.addChild(seatLinkPlane);
			}
			
			//添加等待3d动画标记点
			var wms:Number = 100;
			var wmps:Number = CUBE_SIDE_HARF_LEN - wms; 
			for(var i3:int =0;i3<6;i3++){
				for(var j3:int =0;j3<3;j3++){
					for(var k3:int =0;k3<3;k3++){
						var wmx:Number = j3 * wmps + wms;
						var wmy:Number = k3 * wmps + wms;
						var wmPlane:Plane = creatPlane(new Vector3D(wmx,wmy,0,i3));
						sceneMural.addChild(wmPlane);
						btn3DWaitMovieV.push(wmPlane);
					}
				}
			}
			
			//主3D场景，正方体，六面帖图
			var size :Number = CUBE_SIDE_HARF_LEN * 2;
			var quality :Number = 16;
			
			//正方体材质
			var materials:MaterialsList = new MaterialsList(
				{
					//all:
					front:  creatBitMap(seatDO,SeatDO.FRONT),
					back:   creatBitMap(seatDO,SeatDO.BACK),
					right:  creatBitMap(seatDO,SeatDO.RIGHT),
					left:   creatBitMap(seatDO,SeatDO.LEFT),
					top:    creatBitMap(seatDO,SeatDO.TOP),
					bottom: creatBitMap(seatDO,SeatDO.BOTTOM)
				} );
			
			var insideFaces  :int = Cube.ALL;
			var excludeFaces :int = Cube.NONE;
			
			//创建正方体
			cube = new Cube( materials, size, size, size, quality, quality, quality, insideFaces, excludeFaces );
			cube.z = -CUBE_SIDE_HARF_LEN - 500;
			scenePanorama.addChild( cube, "Cube" );
			
			/*
			Sphere
			var material:MaterialObject3D = creatBitMap(seatDO,SeatDO.BALL); 
			material.doubleSided = true;
			material.smooth = true;
			ball = new Sphere(material,2000,60,40);
			ball.z = -1000;
			scene.addChild(ball);
			*/			
			
			this.addEventListener(MouseEvent.MOUSE_WHEEL, handlerMouseWheel);
			this.addEventListener(MouseEvent.MOUSE_DOWN,handlerMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP,handlerMouseUp);
			this.addEventListener(Event.ENTER_FRAME,handlerEnterFrame);
			this.dispatchEvent(new Event(SEAT3D_CMP_EVENT));
		}
		
		private function calculateCubeTo3DRotation(v3d:Vector3D):Vector3D{
			var rotation3D:Vector3D = new Vector3D();
			if(v3d.w == 0){
				rotation3D.y = 0; 
			}
			else if(v3d.w == 1){
				rotation3D.y = 90; 			 
			}
			else if(v3d.w == 2){
				rotation3D.y = 180; 		 
			}
			else if(v3d.w == 3){
				rotation3D.y = 270; 		 
			}
			else if(v3d.w == 4){
				rotation3D.x = 270; 		 
			}
			else if(v3d.w == 5){
				rotation3D.x = 90; 		 
			}
			return rotation3D;
		}
		
		/**
		 * 
		 * @param v3d
		 * @return 
		 * 
		 */		
		private function calculateCubeTo3DPlace(v3d:Vector3D):Vector3D{
			var place3D:Vector3D = new Vector3D();
			if(v3d.w == 0){
				place3D.x = v3d.x - CUBE_SIDE_HARF_LEN;
				place3D.y = -(v3d.y - CUBE_SIDE_HARF_LEN);
				place3D.z = - CUBE_SIDE_HARF_LEN;
			}
			else if(v3d.w == 1){
				place3D.x = CUBE_SIDE_HARF_LEN;
				place3D.y = -(v3d.y - CUBE_SIDE_HARF_LEN);
				place3D.z = - v3d.x - CUBE_SIDE_HARF_LEN;
			}
			else if(v3d.w == 2){
				place3D.x = -(v3d.x - CUBE_SIDE_HARF_LEN);
				place3D.y = -(v3d.y - CUBE_SIDE_HARF_LEN);
				place3D.z = - CUBE_SIDE_HARF_LEN - 500 - CUBE_SIDE_HARF_LEN;
			}
			else if(v3d.w == 3){
				place3D.x = -CUBE_SIDE_HARF_LEN;
				place3D.y = -(v3d.y - CUBE_SIDE_HARF_LEN);
				place3D.z = v3d.x - CUBE_SIDE_HARF_LEN - 500 - CUBE_SIDE_HARF_LEN;
			}
			else if(v3d.w == 4){
				place3D.x = v3d.x - CUBE_SIDE_HARF_LEN;
				place3D.y = CUBE_SIDE_HARF_LEN;
				place3D.z = v3d.y - CUBE_SIDE_HARF_LEN - 500 - CUBE_SIDE_HARF_LEN;
			}
			else if(v3d.w == 5){
				place3D.x = v3d.x - CUBE_SIDE_HARF_LEN;
				place3D.y = -CUBE_SIDE_HARF_LEN;
				place3D.z = -(v3d.y - CUBE_SIDE_HARF_LEN) - 500 - CUBE_SIDE_HARF_LEN;
			}
			return place3D;
		}
		
		/**
		 * 
		 * @param place3D
		 * @param rotation
		 * @return 
		 * 
		 */		
		private function creatPlane(placeCube:Vector3D):Plane{
			
			var place3D:Vector3D = calculateCubeTo3DPlace(placeCube);
			var rotation3D:Vector3D = calculateCubeTo3DRotation(placeCube);
			
			var mc:MovieClip = getDisplayObjectInstance(getStyleValue("seat3DFingerpostDefaultSkin")) as MovieClip;
			var material:MovieMaterial = new MovieMaterial(mc,true);
			var plane:Plane = new Plane(material,mc.width,mc.height,1,1);
			plane.x = place3D.x;
			plane.y = place3D.y;
			plane.z = place3D.z;
			
			plane.rotationX = rotation3D.x;
			plane.rotationY = rotation3D.y;
			plane.rotationZ = rotation3D.z;
			
			return plane;
		}
		
		
		/**
		 * 创建贴图 
		 * @param seatDO
		 * @param fileType
		 * @return 
		 * 
		 */		
		private function creatBitMap(seatDO:SeatDO,fileType:String):MaterialObject3D{
			var isLoad:Boolean = false;
			var material:MaterialObject3D;
			var typeInt:int = CubeFaceType.transTypeToInt(fileType);
			if(seatDO != null && fileType != null && fileType.length > 0){
				var bitMapData:BitmapData = seatDO.imageBitMapData.findByName(fileType) as BitmapData;
				if(bitMapData == null){
					var burl:String = seatDO.imageUrlHV.findByName(fileType) as String;;
					var catchBitmapData:BitmapData = ImgCatch.imgHV.findByName(burl) as BitmapData;
					
					if(catchBitmapData != null){
						material = new BitmapMaterial(catchBitmapData);
					}
					else {
						material = new BitmapFileMaterial(burl);
						material.name = MD5.hash(burl);
						materialFileTypeHV.push(fileType,material.name);
						//waitMovie.visible = true;
						//loadCount ++;
						material.addEventListener(FileLoadEvent.LOAD_COMPLETE,handlerLoadBallImgCmp);
						material.addEventListener(FileLoadEvent.LOAD_ERROR,handlerLoadBallImgError);
						isLoad = true;
						
					}	
				}
				else {
					material = new BitmapMaterial(bitMapData);
				}
			}
			if(material != null){
				material.smooth = true;
				material.oneSide = true;
				//material.opposite = true;
			}
			if(!isLoad){
				if(material.bitmap.width > 1 && material.bitmap.height > 1){
					deleteFaceWaitMovies(typeInt);
				}
			}
			return material;
		}
		
		
		
		/**
		 * 
		 * 
		 */		
		public function refresh2DBtns():void{
			var murals:Vector.<MuralDO> = this.seatDO.murals;
			
			var s3dw:Number = this.viewportMural.viewportWidth * this.viewportMural.scaleX;
			var s3dh:Number = this.viewportMural.viewportHeight * this.viewportMural.scaleY;
			
			var s3dsclx:Number = this.viewportMural.scaleX;
			var s3dscly:Number = this.viewportMural.scaleY;
			
			
			for(var i:int =0;i < btn2DMuralBtnV.length;i++){
				var mdo:MuralDO = murals[i];
				var typem:Number = mdo.type;
				var muralPlane:Plane = btn3DMuralFingerV[i];
				muralPlane.calculateScreenCoords(cameraPanorama);
				var real2DX:Number = muralPlane.screen.x * s3dsclx+s3dw/2;
				var real2DY:Number = muralPlane.screen.y * s3dsclx+s3dh/2;
				
				var muralBtn:MovieClip = btn2DMuralBtnV[i];
				var mtrect:Rectangle = muralBtn.getRect(btn2DLayer);
				
				var isVisibleWidth:Boolean = isIntervalValue(real2DX,- mtrect.width,s3dw);
				var isVisibleHeight:Boolean = isIntervalValue(real2DY,- mtrect.height,s3dh);
				var isBV:Boolean = isBtnVisible(typem,this.cameraMural.rotationX,this.cameraMural.rotationY);
				if(isBV && isVisibleWidth && isVisibleHeight){
					muralBtn.visible = true;
					muralBtn.x = getIntervalValue(real2DX,- mtrect.width,s3dw);
					muralBtn.y = getIntervalValue(real2DY,- mtrect.height,s3dh);
					
				}
				else {
					muralBtn.visible  = false;
				}	
			}
			
			var seatLinks:Vector.<SeatLinkDO> = this.seatDO.seatLinks;
			for(var ii:int =0;ii<btn2DSeatLinkBtnV.length;ii++){
				var sdo:SeatLinkDO = seatLinks[ii];
				var typeSL:Number = sdo.type;
				var seatLinkPlane:Plane = btn3DSeatLinkFingerV[ii];
				seatLinkPlane.calculateScreenCoords(cameraPanorama);
				var seatLinkReal2DX:Number = seatLinkPlane.screen.x * s3dsclx + s3dw/2;
				var seatLinkReal2DY:Number = seatLinkPlane.screen.y * s3dsclx + s3dh/2;
				
				var seatLinkBtn:MovieClip = btn2DSeatLinkBtnV[ii];
				var slbrect:Rectangle = seatLinkBtn.getRect(btn2DLayer);
				
				var isSLVisibleWidth:Boolean = isIntervalValue(seatLinkReal2DX,- slbrect.width,s3dw);
				var isSLVisibleHeight:Boolean = isIntervalValue(seatLinkReal2DY,- slbrect.height,s3dh);
				
				var isSLBV:Boolean = isBtnVisible(typeSL,this.cameraMural.rotationX,this.cameraMural.rotationY);
				if(isSLBV && isSLVisibleWidth && isSLVisibleHeight){
					seatLinkBtn.visible = true;
					seatLinkBtn.x = getIntervalValue(seatLinkReal2DX,- slbrect.width,s3dw);
					seatLinkBtn.y = getIntervalValue(seatLinkReal2DY,- slbrect.height,s3dh);
				}
				else {
					seatLinkBtn.visible  = false;
				}	
			}
			
			
			for(var i3:int =0;i3< btn3DWaitMovieV.length;i3++){
				var waitMoviePlane:Plane = btn3DWaitMovieV[i3];
				var waitMovieBtn:MovieClip = btn2DWaitMovieV[i3];
				
				if(waitMoviePlane != null && waitMovieBtn != null){
					waitMoviePlane.calculateScreenCoords(cameraPanorama);
					var waitMovieReal2DX:Number = waitMoviePlane.screen.x * s3dsclx + s3dw/2;
					var waitMovieReal2DY:Number = waitMoviePlane.screen.y * s3dsclx + s3dh/2;
					
					
					var wmbrect:Rectangle = waitMovieBtn.getRect(btn2DLayer);
					
					var isWMVisibleWidth:Boolean = isIntervalValue(waitMovieReal2DX,- wmbrect.width,s3dw);
					var isWMVisibleHeight:Boolean = isIntervalValue(waitMovieReal2DY,- wmbrect.height,s3dh);
					
					var typewm:int = int(i3 / (WAIT_MOVIE_NUM_X * waitMovieReal2DY));
					var isWMBV:Boolean = isBtnVisible(typewm,this.cameraMural.rotationX,this.cameraMural.rotationY);
					if(isWMBV && isWMVisibleWidth && isWMVisibleHeight){
						waitMovieBtn.visible = true;
						waitMovieBtn.x = getIntervalValue(waitMovieReal2DX,- wmbrect.width,s3dw);
						waitMovieBtn.y = getIntervalValue(waitMovieReal2DY,- wmbrect.height,s3dh);
					}
					else {
						waitMovieBtn.visible  = false;
					}	
				}
			}
			
		}
		
		/**
		 * 
		 * @param type
		 * @param rotationY
		 * @return 
		 * 
		 */		
		public function isBtnVisible(type:int,rotationX:Number,rotationY:Number):Boolean{
			var isBV:Boolean = false;
			var mrx:Number = rotationX % 360;
			var mry:Number = rotationY % 360;
			if(type == 0){
				isBV = isIntervalValue(mry,-90,90) || isIntervalValue(mry,270,360) || isIntervalValue(mry,-360,-270);
			}
			else if(type == 1){
				isBV = isIntervalValue(mry,0,180) || isIntervalValue(mry,-360,-180);
			}
			else if(type == 2){
				isBV = isIntervalValue(mry,90,270) || isIntervalValue(mry,-270,-90);
			}
			else if(type == 3){
				isBV = isIntervalValue(mry,180,360) || isIntervalValue(mry,-180,0);
			}
			else if(type == 5){
				isBV = isIntervalValue(mrx,0,180) || isIntervalValue(mrx,-360,-180);
			}
			else if(type == 4){
				isBV = isIntervalValue(mrx,180,360) || isIntervalValue(mrx,-180,0);
			}
			return isBV;
		}
		
		
		
		/**
		 * 
		 * @param value
		 * @param min
		 * @param max
		 * @return 
		 * 
		 */		
		public function isIntervalValue(value:Number,min:Number,max:Number):Boolean{
			if(value < min || value >max){
				return false;
			}
			return true;
		}
		
		/**
		 * 
		 * @param value
		 * @param min
		 * @param max
		 * @return 
		 * 
		 */		
		public function getIntervalValue(value:Number,min:Number,max:Number):Number{
			var v:Number = value;
			if(v < min){
				v = min;
			}
			else if(v >max){
				v = max;
			}
			return v;
		}
		
		
		/**
		 * 设置 3D摄像机旋转角度 
		 * @param rotationX
		 * @param rotationY
		 * 
		 */		
		public function setCameraRotation(rotationY:Number):void{
			autoMove = false;
			this.cameraPanorama.rotationY = rotationY;
			this.cameraMural.rotationY = rotationY;
			rendererAll();
		}
		
		/**
		 * 等待一段时间后，自动旋转场景，计数器加1 
		 * @return 
		 * 
		 */		
		private function addAutoMoveCount():Boolean{
			if(this.autoMoveCount < AUTO_MOVE_COUNT_MAX){
				this.autoMoveCount ++;
				return true;
			}
			else{
				return false;
			}
		}
		
		/**
		 * 鼠标滚轮事件，让摄像机视野放大缩小 
		 * @param event
		 * 
		 */		
		private function handlerMouseWheel(event:MouseEvent):void{
			var i:int = event.delta;
			zoom(i);
		}
		
		/**
		 * 摄像机视野放大缩小 
		 * @param i
		 * 
		 */		
		private function zoom(i:Number):void{
			cameraPanorama.zoom += i * 5;
			if(cameraPanorama.zoom  < 20){
				cameraPanorama.zoom  =20;
			}
			if(cameraPanorama.zoom  > 500){
				cameraPanorama.zoom  =500;
			}
			cameraMural.zoom = cameraPanorama.zoom;
			rendererAll();
		}
		
		/**
		 * 设置3D视窗尺寸，用于全屏与非全屏显示切换 
		 * @param scaleX
		 * @param scaleY
		 * @param width
		 * @param height
		 * 
		 */		
		public function setViewport3DSize(scaleX:Number,scaleY:Number,width:Number,height:Number):void{
			if(viewportPanorama != null && frame != null){
				
				//waitMovie.x = width / 2;
				//waitMovie.y = height / 2;
				
				this.viewportPanorama.viewportWidth = width;
				this.viewportPanorama.viewportHeight = height;
				this.viewportPanorama.scaleX = scaleX;
				this.viewportPanorama.scaleY = scaleY;
				
				this.viewportMural.viewportWidth = width;
				this.viewportMural.viewportHeight = height;
				this.viewportMural.scaleX = scaleX;
				this.viewportMural.scaleY = scaleY;
				
				frame.width = width * scaleX;
				frame.height = height * scaleY;
				
				btnMask.width = width * scaleX;
				btnMask.height = height * scaleY;
				
				rendererAll();
			}
		}
		
		public function rendererAll():void{
			if( scenePanorama != null 
				&& cameraPanorama != null
				&& viewportPanorama != null
				&& sceneMural != null
				&& cameraMural != null
				&& viewportMural != null
				&& rendererPanorama != null
				&& rendererMural != null){
				rendererPanorama.renderScene(scenePanorama,cameraPanorama,viewportPanorama);
				rendererMural.renderScene(sceneMural,cameraMural,viewportMural);
				refresh2DBtns();
			}
		}
		
		
		private function handlerLoadBallImgError(e:Event):void{
			trace("handlerLoadBallImgError");
			var material:BitmapFileMaterial = e.currentTarget as BitmapFileMaterial;
			material.removeEventListener(FileLoadEvent.LOAD_COMPLETE,handlerLoadBallImgCmp);
			material.removeEventListener(FileLoadEvent.LOAD_ERROR,handlerLoadBallImgError);
			material.bitmap = new BitmapData(1,1,false,0x000000);
			var fileType:String = String(materialFileTypeHV.findByName(material.name));
			cube.replaceMaterialByName(new ColorMaterial(0x000000,1,false),fileType);
		}
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerLoadBallImgCmp(e:Event):void{
			var material:BitmapFileMaterial = e.currentTarget as BitmapFileMaterial;
			material.removeEventListener(FileLoadEvent.LOAD_COMPLETE,handlerLoadBallImgCmp);
			material.removeEventListener(FileLoadEvent.LOAD_ERROR,handlerLoadBallImgError);
			materialUpdate(material);
		}
		
		/**
		 * 
		 * @param material
		 * 
		 */		
		private function materialUpdate(material:BitmapFileMaterial):void{
			
			var fileType:String = String(materialFileTypeHV.findByName(material.name));
			var typeInt:int = CubeFaceType.transTypeToInt(fileType);
			
			var bitmapData:BitmapData = new BitmapData(material.bitmap.width,material.bitmap.height);
			var matrix:Matrix = null;
			
			if(fileType == SeatDO.BALL){
				//当用一张平行柱面给球面做贴图时，因为在球里面看,需要把图水平翻转一下，才能正确显示。
				matrix = new Matrix(-1,0,0,1, material.bitmap.width,0);
			}
			else if(fileType == SeatDO.TOP){
				//当用正方体展现时，6张贴图用pt Gui 生成后，顶图需要旋转180度，才能正确显示。
				matrix = new Matrix(-1,0,0,-1,material.bitmap.width,material.bitmap.height);
			}
			else{
				matrix = new Matrix(1,0,0,1,0,0);
			}			
			
			bitmapData.draw( material.bitmap,matrix);
			if(fileType == SeatDO.BOTTOM || fileType == SeatDO.TOP){
				var logo:BitmapData = ImgCatch.imgHV.findByName("logo.png") as BitmapData;
				var logoRect:Rectangle = new Rectangle();
				logoRect.x = (bitmapData.width - logo.width) * 0.5;
				logoRect.y = (bitmapData.height - logo.height) * 0.5;
				var logoMatrix:Matrix = new Matrix(1,0,0,1,logoRect.x,logoRect.y);
				bitmapData.draw(logo,logoMatrix);
			}
			
			ImgCatch.imgHV.push(bitmapData,material.url);
			material.bitmap = bitmapData;
			seatDO.imageBitMapData.push(material.bitmap,fileType);
			
			if(material.bitmap.width > 1 && material.bitmap.height > 1){
				deleteFaceWaitMovies(typeInt);
			}
			//loadCount --;
			//if(loadCount == 0){
			//waitMovie.visible = false;
			//}
		}
		
		
		
		
		private function deleteFaceWaitMovies(typeInt:int):void{
			//每个面显示多少个等待动画
			var waitN:int = WAIT_MOVIE_NUM_X * WAIT_MOVIE_NUM_Y;
			//当前要删除的面
			var btnwaitIndex:int = typeInt * waitN;
			//删除每个面上的等待动画
			for(var i:int = btnwaitIndex ;i < btnwaitIndex + waitN;i++){
				if(i < btn2DWaitMovieV.length && i < btn3DWaitMovieV.length){
					var btn2dwait:MovieClip = btn2DWaitMovieV[i];
					if(btn2dwait != null){
						btn2DLayer.removeChild(btn2dwait);
						btn2DWaitMovieV[i] = null;
					}
					var btn3dwait:Plane = btn3DWaitMovieV[i];
					if(btn3dwait != null){
						sceneMural.removeChild(btn3dwait);
						btn3DWaitMovieV[i] = null;
					}		
				}
			}
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerMouseOver(e:Event):void{
			Mouse.cursor = MouseCursor.BUTTON;	
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerMouseOut(e:Event):void{
			Mouse.cursor = MouseCursor.AUTO;
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerMuralBtnClick(e:Event):void{
			var muralBtn:MovieClip = e.currentTarget as MovieClip;
			var i:int = muralBtn.muralsIndex;
			var murals:Vector.<MuralDO> = this.seatDO.murals;
			var mdo:MuralDO = murals[i];
			_currentMuralDO = mdo;
			this.dispatchEvent(new Event(MURAL_CLICK));
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerSeatLinkBtnClick(e:Event):void{
			var seatLinkBtn:MovieClip = e.currentTarget as MovieClip;
			var i:int = seatLinkBtn.seatLinksIndex;
			var seatLinks:Vector.<SeatLinkDO> = this.seatDO.seatLinks;
			var sdo:SeatLinkDO = seatLinks[i];
			_currentSeatLinkDO = sdo;
			this.dispatchEvent(new Event(SEAT_LINK_CLICK));
		}
		
		/**
		 * 当前组件被删除出场景时的事件，把注册的侦听器全部释放 
		 * @param e
		 * 
		 */		
		private function handlerRemoveThis(e:Event):void{
			menu.removeEventListener("left_DOWN",handlerMenuMouseEvent);
			menu.removeEventListener("right_DOWN",handlerMenuMouseEvent);
			menu.removeEventListener("up_DOWN",handlerMenuMouseEvent);
			menu.removeEventListener("down_DOWN",handlerMenuMouseEvent);
			menu.removeEventListener("def_DOWN",handlerMenuMouseEvent);
			menu.removeEventListener("zoomIn_DOWN",handlerMenuMouseEvent);
			menu.removeEventListener("zoomOut_DOWN",handlerMenuMouseEvent);
			
			menu.removeEventListener("left_UP",handlerMenuMouseUp);
			menu.removeEventListener("right_UP",handlerMenuMouseUp);
			menu.removeEventListener("up_UP",handlerMenuMouseUp);
			menu.removeEventListener("down_UP",handlerMenuMouseUp);
			menu.removeEventListener("def_UP",handlerMenuMouseUp);
			menu.removeEventListener("zoomIn_UP",handlerMenuMouseUp);
			menu.removeEventListener("zoomOut_UP",handlerMenuMouseUp);
			
			menu.removeEventListener("auto_DOWN",handlerMenuMouseAutoClick);
			
			this.removeEventListener(MouseEvent.MOUSE_WHEEL, handlerMouseWheel);
			this.removeEventListener(MouseEvent.MOUSE_DOWN,handlerMouseDown);
			this.removeEventListener(MouseEvent.MOUSE_UP,handlerMouseUp);
			this.removeEventListener(Event.ENTER_FRAME,handlerEnterFrame);
			if(rendererPanorama != null){
				try{
					rendererPanorama.destroy();
				}
				catch(e:Error){
					
				}
			}
			
			if(viewportPanorama != null){
				try{
					viewportPanorama.destroy();
				}
				catch(e:Error){
					
				}
			}
			
			if(rendererMural != null){
				try{
					rendererMural.destroy();
				}
				catch(e:Error){
					
				}
			}
			
			if(viewportMural != null){
				try{
					viewportMural.destroy();
				}
				catch(e:Error){
					
				}
			}
			
			if(cube != null){
				try{
					cube.destroy();
				}
				catch(e:Error){
				}
			}
		}
		
		/**
		 * 自动步进按钮点击事件 
		 * @param e
		 * 
		 */		
		private function handlerMenuMouseAutoClick(e:Event):void{
			currentMoveDirection = "";
			autoMove = menu.autoMove;
		}
		
		/**
		 * 控制按钮，点击事件 
		 * @param e
		 * 
		 */		
		private function handlerMenuMouseEvent(e:Event):void{
			
			trace("handlerMenuMouseEvent");
			isBtnDown = true;
			var p:Number = MOUSE_MIN_MOVE;
			if(e.type == "left_DOWN"){
				btnStepP.x = p;
				btnStepP.y = 0;
				zoomp = 0;
				currentMoveDirection = "left_DOWN";
				autoMove = menu.autoMove;
			}
			else if(e.type == "right_DOWN"){
				btnStepP.x = -p;
				btnStepP.y = 0;
				zoomp = 0;
				currentMoveDirection = "right_DOWN";
				autoMove = menu.autoMove;
			}
			else if(e.type == "up_DOWN"){
				btnStepP.x = 0;
				btnStepP.y = p;
				zoomp = 0;
				currentMoveDirection = "up_DOWN";
				autoMove = menu.autoMove;
			}
			else if(e.type == "down_DOWN"){
				btnStepP.x = 0;
				btnStepP.y = -p;
				zoomp = 0;
				currentMoveDirection = "down_DOWN";
				autoMove = menu.autoMove;
			}
			else if(e.type == "def_DOWN"){
				btnStepP.x = 0;
				btnStepP.y = 0;
				cameraPanorama.rotationX = 0;
				cameraPanorama.rotationY = 0;
				cameraPanorama.zoom = 40;
				
				cameraMural.rotationX = 0;
				cameraMural.rotationY = 0;
				cameraMural.zoom = 40;
				
				zoomp = 0;
				currentMoveDirection = "";
			}
			else if(e.type == "zoomIn_DOWN"){
				btnStepP.x = 0;
				btnStepP.y = 0;
				zoomp = 1;
				
			}
			else if(e.type == "zoomOut_DOWN"){
				btnStepP.x = 0;
				btnStepP.y = 0;
				zoomp = -1;
			}
		}
		
		/**
		 * 控制按钮鼠标弹起事件，标记按钮状态为没有按下 
		 * @param e
		 * 
		 */		
		private function handlerMenuMouseUp(e:Event):void{
			isBtnDown = false;
		}
		
		
		
		/**
		 * 鼠标按下事件，获得按下时坐标，改变鼠标显示样式 
		 * @param e
		 * 
		 */		
		private function handlerMouseDown(e:Event):void{
			mouseDownPlace = new Point(this.mouseX,this.mouseY);
			isMouseDown = true;
			Mouse.hide();
			downMouse.visible = true;
		}
		
		/**
		 * 鼠标弹起事件，获得按下时坐标，改变鼠标显示样式 
		 * @param e
		 * 
		 */	
		private function handlerMouseUp(e:Event):void{
			isMouseDown = false;
			Mouse.show();
			downMouse.visible = false;
			downMoveMouse.visible = false;
		}
		
		/**
		 * 3D场景帧刷新 
		 * @param e
		 * 
		 */		
		private function handlerEnterFrame(e:Event):void{
			
			if(isMouseDown || isBtnDown || autoMove){
				refreshWaitTimes = MAX_REFRESH_WAIT_TIMES;
			}
			
			if(sign && refreshWaitTimes > 0){
				
				sign = false;
				refreshWaitTimes --;
				
				var px:Number;
				var py:Number;
				
				if(isMouseDown){
					autoMove = false;
					var currenMousePlace:Point = new Point(this.mouseX,this.mouseY);
					px = mouseDownPlace.x - currenMousePlace.x;
					py = mouseDownPlace.y - currenMousePlace.y;
					this.autoMoveCount = 0;
					
					var mx:Number = this.mouseX;
					var my:Number = this.mouseY;
					
					var downXY:Number = 15;
					
					var maxX:Number = ( this.viewportPanorama.viewportWidth) * this.viewportPanorama.scaleX  - downXY
					if(mx < downXY){
						mx = downXY;
					}
					else if(mx > maxX){
						mx = maxX;
					}
					
					var maxY:Number = (this.viewportPanorama.viewportHeight ) * this.viewportPanorama.scaleY  - downXY;
					if(my < downXY){
						my = downXY;
					}
					else if(my > maxY){
						my = maxY;
					}
					
					downMouse.x = mx;
					downMouse.y = my;
					
					downMoveMouse.x = mx;
					downMoveMouse.y = my;
				}
				
				if(isBtnDown){
					px = btnStepP.x;
					py = btnStepP.y;
					this.autoMoveCount = 0;
				}
				
				/*
				if(AUTO_MOVE_COUNT_MAX == this.autoMoveCount){
				
				if(Math.abs(camera.rotationX) <= ROTATION_STEP){
				camera.rotationX = 0;
				}
				else if(camera.rotationX > 0){
				camera.rotationX -= ROTATION_STEP;
				}
				else if(camera.rotationX < 0){
				camera.rotationX += ROTATION_STEP;
				}
				
				camera.rotationY += ROTATION_STEP;
				this.cameraRotationY = camera.rotationY;
				this.dispatchEvent(new Event(CAMERA_ROTATION_EVENT));
				renderer.renderScene(scene,camera,viewport);
				}
				else if(autoMove){
				*/
				
				if(autoMove){
					if(currentMoveDirection == "left_DOWN"){
						cameraPanorama.rotationY -= AUTO_ROTATION_STEP;  
					}
					else if(currentMoveDirection == "right_DOWN"){
						cameraPanorama.rotationY += AUTO_ROTATION_STEP;
					}
					else if(currentMoveDirection == "up_DOWN"){
						cameraPanorama.rotationX -= AUTO_ROTATION_STEP; 
					}
					else if(currentMoveDirection == "down_DOWN"){
						cameraPanorama.rotationX += AUTO_ROTATION_STEP; 
					}
					if(cameraPanorama.rotationX > 90){
						cameraPanorama.rotationX = 90;
					}
					else if(cameraPanorama.rotationX < -90){
						cameraPanorama.rotationX = -90;
					}
					this.autoMoveCount = 0;
					this.cameraRotationY = cameraPanorama.rotationY;
					this.dispatchEvent(new Event(CAMERA_ROTATION_EVENT));
				}
				else if(isMouseDown || isBtnDown){
					
					var roteX:Number =0;
					var roteY:Number =0;
					var roteRate:Number = 0;
					
					var rpy:Number = 0
					if(py >= MOUSE_MIN_MOVE || py <= - MOUSE_MIN_MOVE){
						rpy = py /cameraPanorama.zoom;
						
						if(py >= MOUSE_MIN_MOVE){
							roteY = 1;
						}
						else if(py <= -MOUSE_MIN_MOVE){
							roteY = -1;
						}
					}
					if(rpy > 3){
						rpy = 3;
					}
					else if(rpy < -3){
						rpy = -3;
					}
					var ry:Number = cameraPanorama.rotationX - rpy;
					if(ry > 90){
						ry = 90;
					}
					else if(ry < -90){
						ry = -90;
					}
					cameraPanorama.rotationX = ry;
					
					var rpx:Number = 0;
					if(px >= MOUSE_MIN_MOVE || px <= - MOUSE_MIN_MOVE){
						rpx = px /cameraPanorama.zoom;
						
						if(px >= MOUSE_MIN_MOVE){
							roteX = 1;
						}
						else if(px <= -MOUSE_MIN_MOVE){
							roteX = -1;
						}
					}
					if(rpx > 3){
						rpx = 3;
					}
					else if(rpx < -3){
						rpx = -3;
					}
					var rx:Number = cameraPanorama.rotationY - rpx;
					if(rx > 360){
						rx -= 360;
					}
					else if(rx < -360){
						rx += 360;
					}
					cameraPanorama.rotationY = rx;
					this.cameraRotationY = rx;
					this.dispatchEvent(new Event(CAMERA_ROTATION_EVENT));
					
					if(isMouseDown){
						if(roteX == 0){
							if(roteY == 0){
								roteRate = 0;
							}
							else if(roteY == 1){
								roteRate = -90;
							}
							else if(roteY == -1){
								roteRate = 90;
							}
						}
						if(roteX == 1){
							if(roteY == 0){
								roteRate = 180;
							}
							else if(roteY == 1){
								roteRate = -135;
							}
							else if(roteY == -1){
								roteRate = 135;
							}
						}
						if(roteX == -1){
							if(roteY == 0){
								roteRate = 0;
							}
							else if(roteY == 1){
								roteRate = -45;
							}
							else if(roteY == -1){
								roteRate = 45;
							}
						}
						//trace(roteX,roteY);
						if(roteX != 0 || roteY != 0){
							//trace("downMoveMouse");
							this.downMouse.visible = false;
							this.downMoveMouse.visible = true;
							this.downMoveMouse.rotation = roteRate;
						}
						else{
							this.downMouse.visible = true;
							this.downMoveMouse.visible = false;
						}
					}
				}
				else {
					//var b:Boolean = addAutoMoveCount();
				}
				
				if(isBtnDown){
					if(zoomp != 0){
						zoom(zoomp);
					}
				}
				
				cameraMural.rotationX = cameraPanorama.rotationX;
				cameraMural.rotationY = cameraPanorama.rotationY;				
				rendererAll();		
				
				sign = true;
			}
		}
		
		
		
		public function get cameraRotationY():Number
		{
			return _cameraRotationY;
		}
		
		public function set cameraRotationY(value:Number):void
		{
			_cameraRotationY = value;
		}
		
		/**
		 * 当前点击的壁画 
		 */
		public function get currentMuralDO():MuralDO
		{
			return _currentMuralDO;
		}
		
		/**
		 * 当前点击的观察点链接 
		 */
		public function get currentSeatLinkDO():SeatLinkDO
		{
			return _currentSeatLinkDO;
		}		
		
		/**
		 * 3D展现对象数据
		 */
		public function get seatDO():SeatDO
		{
			return _seatDO;
		}
		
		/**
		 * 当前组件是否已经绘制完成 
		 */
		public function get isDraw():Boolean
		{
			return _isDraw;
		}
		
		
	}
}