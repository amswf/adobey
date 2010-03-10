package com.snsoft.map
{
	import com.snsoft.map.tree.TreeList;
	import com.snsoft.map.tree.TreeNodeButton;
	import com.snsoft.map.util.HashArray;
	
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
		
		private var _currentTreeNodeBtnName:String = null;
		
		//修改事件
		public static const SUBMIT_EVENT:String = "SUBMIT_EVENT";
		
		//选择图片事件
		public static const SELECT_EVENT:String = "SELECT_EVENT";
		
		//放大
		public static const ZOOM_IN_EVENT:String = "ZOOM_IN_EVENT";
		
		//缩小
		public static const ZOOM_OUT_EVENT:String = "ZOOM_OUT_EVENT";		
		
		//点击地图块按钮列表项
		public static const TREE_CLICK:String = "TREE_CLICK";
		
		private var file:File = new File();
		
		private var _mapFileMainDirectory:String = null;
		
		public function WorkSpaceAttribute()
		{
			super();
			this._mapImageUrlTextFiled = this.getChildByName("mapImageUrlTextFiled") as TextField;
			this._submitBtn = this.getChildByName("submitBtn") as Button;
			this._selectBtn = this.getChildByName("selectBtn") as Button;
			this._zoomInBtn = this.getChildByName("zoomInBtn") as Button;
			this._zoomOutBtn = this.getChildByName("zoomOutBtn") as Button;
			 
			this._treeListScrollPane = this.getChildByName("scrollPane") as ScrollPane;
			this._submitBtn.addEventListener(MouseEvent.CLICK,handlerSubmitMouseClick);
			this._selectBtn.addEventListener(MouseEvent.CLICK,handlerselectMouseClick);
			this._zoomInBtn.addEventListener(MouseEvent.CLICK,handlerZoomInMouseClick);
			this._zoomOutBtn.addEventListener(MouseEvent.CLICK,handlerZoomOutMouseClick);
		}
		
		/**
		 * 更新地图块按钮列表 
		 * @param mapAreas
		 * 
		 */		
		public function refreshMapAreaListBtn(mapAreas:HashArray):void{
			var list:TreeList = new TreeList();
			if(mapAreas != null){
				for (var i:int = 0; i<mapAreas.length; i++) {
					var ma:MapAreaDO = mapAreas.findByIndex(i) as MapAreaDO;
					var name:String = mapAreas.findName(i);
					var btn:TreeNodeButton = new TreeNodeButton(ma.areaName);
					list.put(name,btn);
				}
				list.addEventListener(TreeList.TREE_CLICK,handlerTreeListClick);
				this._treeListScrollPane.source = list;
				this._treeListScrollPane.drawNow();
			}
		}
		
		/**
		 * 事件 
		 * @param e
		 * 
		 */		
		private function handlerTreeListClick(e:Event):void{
			var tl:TreeList = e.currentTarget as TreeList;
			this._currentTreeNodeBtnName = tl.currentClickBtnName;
			this.dispatchEvent(new Event(TREE_CLICK));
		}
		
		/**
		 * 事件 
		 * @param e
		 * 
		 */
		private function handlerZoomInMouseClick(e:Event):void{
			this.dispatchEvent(new Event(ZOOM_IN_EVENT));
		}
		
		/**
		 * 事件 
		 * @param e
		 * 
		 */
		private function handlerZoomOutMouseClick(e:Event):void{
			this.dispatchEvent(new Event(ZOOM_OUT_EVENT));
		}
		
		/**
		 * 事件 
		 * @param e
		 * 
		 */
		private function handlerSubmitMouseClick(e:Event):void{
			this.dispatchEvent(new Event(SUBMIT_EVENT));
		}
		
		/**
		 * 事件 
		 * @param e
		 * 
		 */
		private function handlerselectMouseClick(e:Event):void{
			var imagesFilter:FileFilter = new FileFilter("图片","*.jpg;*.gif;*.png");
			var fa:Array = new Array();
			fa.push(imagesFilter);
			file.browseForOpen("打开图片",fa);
			file.addEventListener(Event.SELECT,handlerFileSelect);
		}
		
		/**
		 * 事件 
		 * @param e
		 * 
		 */
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
		
		public function get currentTreeNodeBtnName():String
		{
			return _currentTreeNodeBtnName;
		}

		public function get mapFileMainDirectory():String
		{
			return _mapFileMainDirectory;
		}

		
	}
}