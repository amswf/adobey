package com.snsoft.sndoor{
	
	/**
	 * 
	 * @author Administrator
	 * 
	 */	
	public class MenuDO{
		
		/**
		 * 子列表显示类型  card
		 */		
		public static const TYPE_CARD:String = "card";
		
		/**
		 * 子列表显示类型  list
		 */		
		public static const TYPE_LIST:String = "list";
		
		/**
		 * 子列表显示类型  url
		 */		
		public static const TYPE_URL:String = "url";
		
		/**
		 * 名称 
		 */		
		private var _name:String;
		
		/**
		 * 中文标题 
		 */		
		private var _text:String;
		
		/**
		 * 子列表显示类型 
		 */		
		private var _type:String;
		
		/**
		 * 英文标题 
		 */		
		private var _eText:String;
		
		/**
		 * 图片 
		 */		
		private var _image:String;
		
		/**
		 * 说明文字 
		 */		
		private var _contents:String;
		
		/**
		 * 链接地址 
		 */
		private var _url:String;
		
		/**
		 * 按钮列表 
		 */		
		private var _childMenuDOs:Vector.<MenuDO> = new Vector.<MenuDO>();
		
		/**
		 * 构造方法 
		 * 
		 */		
		public function MenuDO(){
			
		}
		
		public function pushChildMenuDO(menuDO:MenuDO):void{
			_childMenuDOs.push(menuDO);
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text = value;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		public function get eText():String
		{
			return _eText;
		}

		public function set eText(value:String):void
		{
			_eText = value;
		}

		public function get image():String
		{
			return _image;
		}

		public function set image(value:String):void
		{
			_image = value;
		}

		public function get contents():String
		{
			return _contents;
		}

		public function set contents(value:String):void
		{
			_contents = value;
		}

		/**
		 * 子按钮列表 
		 */
		public function get childMenuDOs():Vector.<MenuDO>
		{
			return _childMenuDOs;
		}

		/**
		 * 链接地址 
		 */
		public function get url():String
		{
			return _url;
		}

		/**
		 * @private
		 */
		public function set url(value:String):void
		{
			_url = value;
		}


	}
}