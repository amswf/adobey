package com.snsoft.tsp3 {
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObjectContainer;
	import flash.display.NativeWindow;
	import flash.html.HTMLHost;
	import flash.html.HTMLLoader;
	import flash.html.HTMLWindowCreateOptions;

	public class MyHTMLHost extends HTMLHost {

		private var parent:DisplayObjectContainer;

		public function MyHTMLHost(parent:DisplayObjectContainer, defaultBehaviors:Boolean = true) {
			this.parent = parent;
			super(defaultBehaviors);
		}

		override public function createWindow(windowCreateOptions:HTMLWindowCreateOptions):HTMLLoader {
			trace("createWindow");
			windowCreateOptions.height = 0;
			windowCreateOptions.width = 0;
			windowCreateOptions.x = NativeWindow.systemMaxSize.x;
			windowCreateOptions.y = NativeWindow.systemMaxSize.y;
			var ldr:HTMLLoader = super.createWindow(windowCreateOptions);
			ldr.htmlHost = new MyHTMLHost(parent);
			NativeApplication.nativeApplication.openedWindows[1].close();
			parent.addChild(ldr);
			ldr.width = 800;
			ldr.height = 600;
			return ldr;
		}
	}
}
