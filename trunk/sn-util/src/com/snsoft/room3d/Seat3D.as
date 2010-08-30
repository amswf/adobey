package com.snsoft.room3d{
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	
	public class Seat3D extends UIComponent{
		
		 
		
		private static const AUTO_MOVE_COUNT_MAX:int = 150;
		
		private var menu:Menu;
		
		private var seatDO:SeatDO;
		
		private var _cameraRotationY:Number;
		
		private var seat3DWidth:Number;
		
		private var seat3DHeight:Number;
		
		public static const CAMERA_ROTATION_EVENT:String = "CAMERA_ROTATION_EVENT";
		
		public static const SEAT3D_CMP_EVENT:String = "SEAT3D_CMP_EVENT";
		
		public function Seat3D(menu:Menu,seatDO:SeatDO,seat3DWidth:Number,seat3DHeight:Number){
			this.menu = menu;
			this.seatDO = seatDO;
			this.seat3DWidth = seat3DWidth;
			this.seat3DHeight = seat3DHeight;
			super();
		}
		// ___________________________________________________________________ Static
		
		static public var SCREEN_WIDTH  :int = 1024;
		static public var SCREEN_HEIGHT :int = 768;
		
		// ___________________________________________________________________ 3D vars
		
		private var viewport   :Viewport3D;
		private var renderer  :BasicRenderEngine;
		private var scene     :Scene3D;
		private var camera    :Camera3D;
		private var cube      :Cube;
		
		private var mouseDownPlace:Point;
		
		private var isMouseDown:Boolean = false;
		
		private var isBtnDown:Boolean = false;
		
		private var btnStepP:Point = new Point();
		
		private var zoomp:Number = 0;
		
		
		
		private var autoMoveCount:int = AUTO_MOVE_COUNT_MAX;
		
		private var isDraw:Boolean = false;
		
		/**
		 * 
		 */			
		private static var defaultStyles:Object = {
			seatPointSkin:"SeatPoint_Skin"
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
		 * 
		 */		
		override protected function draw():void{
			trace("Seat3D draw");
			if(!isDraw){
				trace("Seat3D draw false");
				init3D();
				createCube();
				
				this.addEventListener( Event.ENTER_FRAME, loop );
				this.addEventListener(Event.REMOVED_FROM_STAGE,handlerRemoveThis);
			}
		}		
		
		// ___________________________________________________________________ Init3D
		
		private function init3D():void
		{
			// Create container sprite and center it in the stage
			viewport = new Viewport3D(seat3DWidth,seat3DHeight);
			viewport.x = 0;
			viewport.y = 0;
			addChild( viewport );
			
			
			
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
			
			renderer = new BasicRenderEngine();
			
			// Create scene
			scene = new Scene3D();
			
			// Create camera
			camera = new Camera3D();
		}
		
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
			
			this.removeEventListener(MouseEvent.MOUSE_WHEEL, handlerMouseWheel);
			this.removeEventListener(MouseEvent.MOUSE_DOWN,handlerMouseDown);
			this.removeEventListener(MouseEvent.MOUSE_UP,handlerMouseUp);
			this.removeEventListener(Event.ENTER_FRAME,handlerEnterFrame);
		}
		
		private function handlerMenuMouseEvent(e:Event):void{
			isBtnDown = true;
			var p:Number = 20;
			if(e.type == "left_DOWN"){
				btnStepP.x = p;
				btnStepP.y = 0;
				zoomp = 0;
			}
			else if(e.type == "right_DOWN"){
				btnStepP.x = -p;
				btnStepP.y = 0;
				zoomp = 0;
			}
			else if(e.type == "up_DOWN"){
				btnStepP.x = 0;
				btnStepP.y = p;
				zoomp = 0;
			}
			else if(e.type == "down_DOWN"){
				btnStepP.x = 0;
				btnStepP.y = -p;
				zoomp = 0;
			}
			else if(e.type == "def_DOWN"){
				btnStepP.x = 0;
				btnStepP.y = 0;
				camera.rotationX = 0;
				camera.rotationY = 0;
				camera.zoom = 40;
				zoomp = 0;
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
		
		private function handlerMenuMouseUp(e:Event):void{
			isBtnDown = false;
		}
		
		
		// ___________________________________________________________________ Create Cube
		
		private function createCube():void
		{
			// Attributes
			var size :Number = 1000;
			var quality :Number = 20;
			
			// Materials
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
			
			// Cube face settings
			// You can add or sustract faces to your selection. For examples: Cube.FRONT+Cube.BACK or Cube.ALL-Cube.Top.
			
			// On single sided materials, all faces will be visible from the inside.
			var insideFaces  :int = Cube.ALL;
			
			// Front and back cube faces will not be created.
			var excludeFaces :int = Cube.NONE;
			
			// Create the cube.
			cube = new Cube( materials, size, size, size, quality, quality, quality, insideFaces, excludeFaces );
			cube.z = -1000;
			
			scene.addChild( cube, "Cube" );
			
			this.addEventListener(MouseEvent.MOUSE_WHEEL, handlerMouseWheel);
			this.addEventListener(MouseEvent.MOUSE_DOWN,handlerMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP,handlerMouseUp);
			this.addEventListener(Event.ENTER_FRAME,handlerEnterFrame);
			this.dispatchEvent(new Event(SEAT3D_CMP_EVENT));
		}
		
		private function creatBitMap(seatDO:SeatDO,fileType:String):MaterialObject3D{
			
			var material:MaterialObject3D;
			if(seatDO != null && fileType != null && fileType.length > 0){
				
				var bitMapData:BitmapData = seatDO.imageBitMapData.findByName(fileType) as BitmapData;
				if(bitMapData == null){
					var url:String = seatDO.imageUrlHV.findByName(fileType) as String;
					material = new BitmapFileMaterial(url);
					material.addEventListener(FileLoadEvent.LOAD_COMPLETE,handlerLoadImgCmp);
					function handlerLoadImgCmp(e:Event):void{
						seatDO.imageBitMapData.push(material.bitmap,fileType);
					}
				}
				else {
					material = new BitmapMaterial(bitMapData);
				}
				
				
			}
			return material;
			
			
			
		}
		
		
		// ___________________________________________________________________ Loop
		
		private function loop(event:Event):void
		{
			renderer.renderScene(scene,camera,viewport);
		}
		
		
		private function update3D():void
		{
			cube.rotationY = viewport.mouseX / 2;
			cube.rotationX = viewport.mouseY / 2;
			
			// Render
			
		}
		
		private function handlerMouseDown(e:Event):void{
			mouseDownPlace = new Point(this.mouseX,this.mouseY);
			isMouseDown = true;
		}
		
		private function handlerMouseUp(e:Event):void{
			isMouseDown = false;
		}
		
		private function handlerEnterFrame(e:Event):void{
			var px:Number;
			var py:Number;
			if(isMouseDown){
				var currenMousePlace:Point = new Point(this.mouseX,this.mouseY);
				px = mouseDownPlace.x - currenMousePlace.x;
				py = mouseDownPlace.y - currenMousePlace.y;
				this.autoMoveCount = 0;
			}
			
			if(isBtnDown){
				px = btnStepP.x;
				py = btnStepP.y;
				this.autoMoveCount = 0;
			}
			
			if(AUTO_MOVE_COUNT_MAX == this.autoMoveCount){
				
				if(Math.abs(camera.rotationX) <= 0.1){
					camera.rotationX = 0;
				}
				else if(camera.rotationX > 0){
					camera.rotationX -= 0.1;
				}
				else if(camera.rotationX < 0){
					camera.rotationX += 0.1;
				}
				
				camera.rotationY += 0.1;
				this.cameraRotationY = camera.rotationY;
				this.dispatchEvent(new Event(CAMERA_ROTATION_EVENT));
				renderer.renderScene(scene,camera,viewport);
			}
			
			if(isMouseDown || isBtnDown){
				var ry:Number = camera.rotationX - int(py/20)* 50 /camera.zoom;
				if(ry > 90){
					ry = 90;
				}
				else if(ry < -90){
					ry = -90;
				}
				camera.rotationX = ry;
				
				var rx:Number = camera.rotationY - int(px/20) * 50 /camera.zoom;
				if(rx > 360){
					rx -= 360;
				}
				else if(rx < -360){
					rx += 360;
				}
				camera.rotationY = rx;
				this.cameraRotationY = rx;
				this.dispatchEvent(new Event(CAMERA_ROTATION_EVENT));
				renderer.renderScene(scene,camera,viewport);
			}
			else {
				var b:Boolean = addAutoMoveCount();
			}
			
			if(isBtnDown){
				if(zoomp != 0){
					zoom(zoomp);
				}
			}
		}
		
		/**
		 *  
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
		
		private function handlerMouseWheel(event:MouseEvent):void{
			var i:int = event.delta;
			zoom(i);
		}
		
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
		
		public function setViewport3DSize(scaleX:Number,scaleY:Number,width:Number,height:Number):void{
			
			this.viewport.viewportWidth = width;
			this.viewport.viewportHeight = height;
			this.viewport.scaleX = scaleX;
			this.viewport.scaleY = scaleY;
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