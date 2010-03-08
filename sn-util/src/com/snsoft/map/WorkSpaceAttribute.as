package com.snsoft.map
{
	import com.snsoft.map.tree.TreeList;
	import com.snsoft.map.tree.TreeNodeButton;
	
	import fl.containers.ScrollPane;
	import fl.controls.Button;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.text.TextField;
	
	public class WorkSpaceAttribute extends MovieClip
	{
		//图片路径
		private var _imageUrl:String = null;
		
		//图片路径文本框
		private var _mapImageUrlTextFiled:TextField = null;
		
		//选择图片按钮
		private var _selectBtn:Button = null;
		
		//提交数据按钮
		private var _submitBtn:Button = null;
		
		//放大按钮
		private var _zoomInBtn:Button = null;
		
		//缩小按钮
		private var _zoomOutBtn:Button = null;
		
		private var _treeListScrollPane:ScrollPane = null;
		
		//修改事件
		public static const SUBMIT_EVENT:String = "SUBMIT_EVENT";
		
		//选择图片事件
		public static const SELECT_EVENT:String = "SELECT_EVENT";
		
		//放大
		public static const ZOOM_IN_EVENT:String = "ZOOM_IN_EVENT";
		
		//缩小
		public static const ZOOM_OUT_EVENT:String = "ZOOM_OUT_EVENT";
		
		private var file:File = new File();
		
		public function WorkSpaceAttribute()
		{
			super();
			this._mapImageUrlTextFiled = this.getChildByName("mapImageUrlTextFiled") as TextField;
			this._submitBtn = this.getChildByName("submitBtn") as Button;
			this._selectBtn = this.getChildByName("selectBtn") as Button;
			this._zoomInBtn = this.getChildByName("zoomInBtn") as Button;
			this._zoomOutBtn = this.getChildByName("zoomOutBtn") as Button;
			this._treeListScrollPane = this.getChildByName("scrollPane") as ScrollPane;
			var list:TreeList = new TreeList();
			for (var i:int = 0; i<10; i++) {
				var btn:TreeNodeButton = new TreeNodeButton("asdf");
				list.put("asdf",btn);
			}
			this._treeListScrollPane.source = list;
			this._submitBtn.addEventListener(MouseEvent.CLICK,handlerSubmitMouseClick);
			this._selectBtn.addEventListener(MouseEvent.CLICK,handlerselectMouseClick);
			this._zoomInBtn.addEventListener(MouseEvent.CLICK,handlerZoomInMouseClick);
			this._zoomOutBtn.addEventListener(MouseEvent.CLICK,handlerZoomOutMouseClick);
		}
		
		private function handlerZoomInMouseClick(e:Event):void{
			this.dispatchEvent(new Event(ZOOM_IN_EVENT));
		}
		
		private function handlerZoomOutMouseClick(e:Event):void{
			this.dispatchEvent(new Event(ZOOM_OUT_EVENT));
		}
		
		private function handlerSubmitMouseClick(e:Event):void{
			this.dispatchEvent(new Event(SUBMIT_EVENT));
		}
		
		private function handlerselectMouseClick(e:Event):void{
			var imagesFilter:FileFilter = new FileFilter("图片","*.jpg;*.gif;*.png");
			var fa:Array = new Array();
			fa.push(imagesFilter);
			file.browseForOpen("打开图片",fa);
			file.addEventListener(Event.SELECT,handlerFileSelect);
		}
		
		public function handlerFileSelect(e:Event):void{
			this._imageUrl = file.nativePath;
			this._mapImageUrlTextFiled.text = this._imageUrl;
		}

		public function get imageUrl():String
		{
			return _imageUrl;
		}

		public function set imageUrl(value:String):void
		{
			_imageUrl = value;
		}
	}
}