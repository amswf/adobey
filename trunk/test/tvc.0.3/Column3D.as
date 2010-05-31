package  {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.core.geom.TriangleMesh3D;
	import org.papervision3d.core.geom.renderables.Triangle3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.math.NumberUV;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.*;
	import org.papervision3d.materials.special.*;
	import org.papervision3d.materials.utils.*;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	import flash.geom.Rectangle;
	
	public class Column3D extends MovieClip {


		private var container:Viewport3D = new Viewport3D(640,480,false,true,true,true);
		
		private var scs3d:Scene3D = new Scene3D();
		
		private var re:BasicRenderEngine = new BasicRenderEngine();
		
		private var cmr:Camera3D = new Camera3D();
		
		private var mc3d:DisplayObject3D = new DisplayObject3D();
		
		private var mouseCurentX:Number = 0;
		
		private var mouseCurentY:Number = 0;
		
		private var isMouseDown:Boolean = false;
		
		private var isMouseMove:Boolean = false;
		
		private var cube:Cube = null;
		
		public function Column3D()
		{
			//3d场景
			this.addChild(container);
			 
			//摄像机
			cmr.zoom = 62.3478;			 
			cmr.z = -5000;
			cmr.x = -2000;
			cmr.y = -2000;
			 
			
			cube = drawViewValueCube();
			cube.x = 0;
			cube.z = 0;
			cube.name = "cube";
			scs3d.addChild(cube);
			
			//显示3D图形
			re.renderScene(this.scs3d,this.cmr,this.container,true);
			
			var rect:Rectangle = container.getRect(container.parent);
			container.x = - rect.x;
			container.y = - rect.y;
			trace(container.x,container.y,container.height);
		}
		
		
		private function drawViewValueCube():Cube{
			var mtrlColor:ColorMaterial = new ColorMaterial(0x00ff00,1,true);
			var mtrlList:MaterialsList = new MaterialsList();
			mtrlList.addMaterial(mtrlColor,"front");
			mtrlList.addMaterial(mtrlColor,"back");
			mtrlList.addMaterial(new ColorMaterial(0x006600,1,true),"right");
			mtrlList.addMaterial(mtrlColor,"left");
			mtrlList.addMaterial(new ColorMaterial(0x00cc00,1,true),"top");
			mtrlList.addMaterial(mtrlColor,"bottom");
			var cube:Cube = new Cube(mtrlList,20,20,200,1,1,1,Cube.ALL);
			return cube;
		}
	}
	
}

 