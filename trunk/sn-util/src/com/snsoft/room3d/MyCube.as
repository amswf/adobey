/*
*  PAPER    ON   ERVIS  NPAPER ISION  PE  IS ON  PERVI IO  APER  SI  PA
*  AP  VI  ONPA  RV  IO PA     SI  PA ER  SI NP PE     ON AP  VI ION AP
*  PERVI  ON  PE VISIO  APER   IONPA  RV  IO PA  RVIS  NP PE  IS ONPAPE
*  ER     NPAPER IS     PE     ON  PE  ISIO  AP     IO PA ER  SI NP PER
*  RV     PA  RV SI     ERVISI NP  ER   IO   PE VISIO  AP  VISI  PA  RV3D
*  ______________________________________________________________________
*  papervision3d.org + blog.papervision3d.org + osflash.org/papervision3d
*/

// _______________________________________________________________________ Cube

package com.snsoft.room3d
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.MovieAssetMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	
	public class MyCube extends Sprite
	{
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
		
		// ___________________________________________________________________ main
		
		public function MyCube()
		{
			init3D();
			
			createCube();
			
			this.addEventListener( Event.ENTER_FRAME, loop );
		}
		
		
		// ___________________________________________________________________ Init3D
		
		private function init3D():void
		{
			// Create container sprite and center it in the stage
			viewport = new Viewport3D(450,450);
			viewport.x = 170;
			viewport.y = 40;
			addChild( viewport );
			
			var menu:Menu = new Menu();
			menu.x = 630;
			menu.y = 10;
			addChild(menu);
			
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
					front:  creatBitMap("cube_2.jpg"),
					back:   creatBitMap("cube_4.jpg"),
					right:  creatBitMap("cube_3.jpg"),
					left:   creatBitMap("cube_1.jpg"),
					top:    creatBitMap("cube_5.jpg"),
					bottom: creatBitMap("cube_6.jpg")
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
		}
		
		private function creatBitMap(fileName:String):BitmapFileMaterial{
			var material:BitmapFileMaterial = new BitmapFileMaterial(fileName);
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
			}
			
			if(isBtnDown){
				px = btnStepP.x;
				py = btnStepP.y;
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
				renderer.renderScene(scene,camera,viewport);
			}
			
			if(isBtnDown){
				if(zoomp != 0){
					zoom(zoomp);
				}
			}
		}
		
		private function handlerMouseWheel(event:MouseEvent):void{
			trace(camera.zoom);
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
	}
}