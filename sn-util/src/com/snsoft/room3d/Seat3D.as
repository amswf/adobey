package com.snsoft.room3d{
	import com.snsoft.util.SkinsUtil;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Cube;
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
		
		private var sign:Boolean = true;
		
		private static const MAX_REFRESH_WAIT_TIMES:uint = 20;
		
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
		
		/**
		 * 3D展现对象数据
		 */		
		private var seatDO:SeatDO;
		
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
		 * 3D视窗 
		 */		
		private var viewport:Viewport3D;
		
		/**
		 * 3D渲染器
		 */		
		private var renderer:BasicRenderEngine;
		
		/**
		 * 3D场景 
		 */		
		private var scene:Scene3D;
		
		/**
		 * 摄像机 
		 */		
		private var camera:Camera3D;
		
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
		
		/**
		 * 当前组件是否已经绘制完成 
		 */		
		private var isDraw:Boolean = false;
		
		/**
		 * 显示边框 
		 */		
		private var frame:MovieClip;
		
		public function Seat3D(menu:Menu,seatDO:SeatDO,seat3DWidth:Number,seat3DHeight:Number){
			this.menu = menu;
			this.seatDO = seatDO;
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
			seat3DMouseDownSkin:"Seat3DMouse_downSkin"
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
		}
		
		/**
		 * 
		 * 绘制组件显示
		 */		
		override protected function draw():void{
			trace("Seat3D draw");
			if(!isDraw){
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
		 * 初始化3D显示对象 
		 * 
		 */		
		private function init3D():void
		{
			// Create container sprite and center it in the stage
			viewport = new Viewport3D(seat3DWidth,seat3DHeight);
			viewport.x = 0;
			viewport.y = 0;
			addChild( viewport );
			
			
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
			
			renderer = new BasicRenderEngine();
			
			// Create scene
			scene = new Scene3D();
			
			// Create camera
			camera = new Camera3D();
			
			this.addEventListener(Event.REMOVED_FROM_STAGE,handlerRemoveThis);
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
			if(renderer != null){
				renderer.destroy();
			}
			if(viewport != null){
				viewport.destroy();
			}
			if(cube != null){
				cube.destroy();
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
				camera.rotationX = 0;
				camera.rotationY = 0;
				camera.zoom = 40;
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
		 * 创建3D显示物体
		 * 
		 */		
		private function create3DDisplayObject():void
		{
			// Attributes
			var size :Number = 500;
			var quality :Number = 16;
			
			//cube
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
			cube = new Cube( materials, size, size, size, quality, quality, quality, insideFaces, excludeFaces );
			cube.z = -1000;
			
			scene.addChild( cube, "Cube" );
			
			//Sphere
			/*
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
		
		/**
		 * 创建贴图 
		 * @param seatDO
		 * @param fileType
		 * @return 
		 * 
		 */		
		private function creatBitMap(seatDO:SeatDO,fileType:String):MaterialObject3D{
			
			var material:MaterialObject3D;
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
						material.addEventListener(FileLoadEvent.LOAD_COMPLETE,handlerLoadBallImgCmp);
						
						function handlerLoadBallImgCmp(e:Event):void{
							material.removeEventListener(FileLoadEvent.LOAD_COMPLETE,handlerLoadBallImgCmp);
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
							
							ImgCatch.imgHV.push(bitmapData,burl);
							material.bitmap = bitmapData;
							seatDO.imageBitMapData.push(material.bitmap,fileType);
						}
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
			return material;
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
					
					var maxX:Number = ( this.viewport.viewportWidth) * this.viewport.scaleX  - downXY
					if(mx < downXY){
						mx = downXY;
					}
					else if(mx > maxX){
						mx = maxX;
					}
					
					var maxY:Number = (this.viewport.viewportHeight ) * this.viewport.scaleY  - downXY;
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
						camera.rotationY -= AUTO_ROTATION_STEP;  
					}
					else if(currentMoveDirection == "right_DOWN"){
						camera.rotationY += AUTO_ROTATION_STEP;
					}
					else if(currentMoveDirection == "up_DOWN"){
						camera.rotationX -= AUTO_ROTATION_STEP; 
					}
					else if(currentMoveDirection == "down_DOWN"){
						camera.rotationX += AUTO_ROTATION_STEP; 
					}
					if(camera.rotationX > 90){
						camera.rotationX = 90;
					}
					else if(camera.rotationX < -90){
						camera.rotationX = -90;
					}
					this.autoMoveCount = 0;
					this.cameraRotationY = camera.rotationY;
					this.dispatchEvent(new Event(CAMERA_ROTATION_EVENT));
				}
				else if(isMouseDown || isBtnDown){
					
					var roteX:Number =0;
					var roteY:Number =0;
					var roteRate:Number = 0;
					
					var rpy:Number = 0
					if(py >= MOUSE_MIN_MOVE || py <= - MOUSE_MIN_MOVE){
						rpy = py /camera.zoom;
						
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
					var ry:Number = camera.rotationX - rpy;
					if(ry > 90){
						ry = 90;
					}
					else if(ry < -90){
						ry = -90;
					}
					camera.rotationX = ry;
					
					var rpx:Number = 0;
					if(px >= MOUSE_MIN_MOVE || px <= - MOUSE_MIN_MOVE){
						rpx = px /camera.zoom;
						
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
					var rx:Number = camera.rotationY - rpx;
					if(rx > 360){
						rx -= 360;
					}
					else if(rx < -360){
						rx += 360;
					}
					camera.rotationY = rx;
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
				renderer.renderScene(scene,camera,viewport);
				sign = true;
			}
		}
		
		/**
		 * 设置 3D摄像机旋转角度 
		 * @param rotationX
		 * @param rotationY
		 * 
		 */		
		public function setCameraRotation(rotationY:Number):void{
			autoMove = false;
			this.camera.rotationY = rotationY;
			renderer.renderScene(scene,camera,viewport);
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
			camera.zoom += i * 5;
			if(camera.zoom  < 20){
				camera.zoom  =20;
			}
			if(camera.zoom  > 500){
				camera.zoom  =500;
			}
			renderer.renderScene(scene,camera,viewport);
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
			if(viewport != null && frame != null){
				this.viewport.viewportWidth = width;
				this.viewport.viewportHeight = height;
				
				frame.width = width * scaleX;
				frame.height = height * scaleY;
				
				this.viewport.scaleX = scaleX;
				this.viewport.scaleY = scaleY;
				
				renderer.renderScene(scene,camera,viewport);
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
		
	}
}