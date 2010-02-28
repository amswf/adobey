package com.snsoft.map
{
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
		
		public static const SUBMIT_EVENT:String = "SUBMIT_EVENT";
		
		public static const SELECT_EVENT:String = "SELECT_EVENT";
		
		private var file:File = new File();
		
		public function WorkSpaceAttribute()
		{
			super();
			_mapImageUrlTextFiled = this.getChildByName("mapImageUrlTextFiled") as TextField;
			_submitBtn = this.getChildByName("submitBtn") as Button;
			_selectBtn = this.getChildByName("selectBtn") as Button;
			
			this._submitBtn.addEventListener(MouseEvent.CLICK,handlerSubmitMouseClick);
			this._selectBtn.addEventListener(MouseEvent.CLICK,handlerselectMouseClick);
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