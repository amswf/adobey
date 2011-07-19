package com.snsoft.map
{
	import com.snsoft.map.tree.TreeList;
	import com.snsoft.map.tree.TreeNodeButton;
	import com.snsoft.util.HashVector;
	
	import fl.containers.ScrollPane;
	import fl.controls.Button;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.text.TextField;
	
	public class MapMainAttribute extends MovieClip
	{
		 
		
		private var _saveBtn:Button = null;
		
		private var _openBtn:Button = null;
		
		//保存
		public static const SAVE_EVENT:String = "SAVE_EVENT";
		
		//打开
		public static const OPEN_EVENT:String = "OPEN_EVENT";
		
		private var file:File = new File();
		
		private var _mapFileMainDirectory:String = null;
		
		public function MapMainAttribute()
		{
			super();
			 
			this._saveBtn = this.getChildByName("saveBtn") as Button;
			this._openBtn = this.getChildByName("openBtn") as Button;
			 
			this._saveBtn.addEventListener(MouseEvent.CLICK,handlerSaveMouseClick);
			this._openBtn.addEventListener(MouseEvent.CLICK,handlerOpenMouseClick);
		}
		
		 
		
		private function handlerOpenMouseClick(e:Event):void{
			var file:File = new File();
			file.browseForDirectory("请选择地图文件所在的目录");
			file.addEventListener(Event.SELECT,handlerOpenFileSelect);
		}
		
		public function selectSaveDirectory():void{
			var file:File = new File();
			file.browseForDirectory("请选择地图文件所在的目录");
			file.addEventListener(Event.SELECT,handlerSelectSaveDirectory);
		}
		
		private function handlerSelectSaveDirectory(e:Event):void{
			var file:File = e.currentTarget as File;
			this._mapFileMainDirectory = file.nativePath;
			this.dispatchEvent(new Event(SAVE_EVENT));
		}
		
		private function handlerOpenFileSelect(e:Event):void{
			var file:File = e.currentTarget as File;
			this._mapFileMainDirectory = file.nativePath;
			this.dispatchEvent(new Event(OPEN_EVENT));
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerSaveMouseClick(e:Event):void{
			this.dispatchEvent(new Event(SAVE_EVENT));
		}

		public function get mapFileMainDirectory():String
		{
			return _mapFileMainDirectory;
		}
	}
}