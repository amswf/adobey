package com.snsoft.core
{
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	import fl.events.ComponentEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;

	public class SpriteDynamicList extends UIComponent
	{
		/**
		 * 动态显示列表项目列表 
		 */		
		private var _spriteArray:Array = new Array();
		
		/**
		 * 列表显示类型值，从上到下输出行 
		 */		
		private static var LIST_TYPE_ROW:String = "ROW";

		/**
		 * 列表显示类型值，从左到右输出列
		 */
		private static var LIST_TYPE_LIST:String = "LIST";
		
		/**
		 * 列表显示类型 ROW / LIST
		 */		
		private var _listType:String;

		/**
		 * 输出列表 X 方向间隔 
		 */	
		private var _spriteSpaseX:Number = 0;

		/**
		 * 输出列表 Y 方向间隔 
		 */
		private var _spriteSpaseY:Number = 0;
		
		
		
		/**
		 * 构造方法 
		 * 
		 */		
		public function SpriteDynamicList()
		{
			super();
			this.invalidate(InvalidationType.SIZE);
			this.addEventListener(ComponentEvent.RESIZE,handlerResize);
			this.addEventListener(Event.ENTER_FRAME,handlerEnterFrame);
		}
		
		/**
		 * 设置创建动态列表 
		 * @param spriteArray
		 * @param spriteSpaseX
		 * @param spriteSpaseY
		 * @param listType
		 * @return
		 * 
		 */		
		public function init(spriteArray:Array,spriteSpaseX:Number = 0,spriteSpaseY:Number = 0,listType:String = "ROW"){
			this.spriteArray = spriteArray;
			this.spriteSpaseX = spriteSpaseX;
			this.spriteSpaseY = spriteSpaseY;
			this.listType = listType;
		}
		
		/**
		 * 当前项目改变宽高事件 
		 * @param e
		 * 
		 */		
		private function handlerResize(e:Event):void{
			this.refeshList();
		}
		
		/**
		 * 当前项目进跳入帧事件 
		 * @param e
		 * 
		 */		
		private function handlerEnterFrame(e:Event):void{
			//删除监听器
			try{
				this.removeEventListener(Event.ENTER_FRAME,handlerEnterFrame);
			}
			catch(e:Error){
			}
			this.refeshList();
		}
		
		
		/**
		 * 刷新显示列表 
		 * @return 
		 * 
		 */		
		public function refeshList():void {

			var numX:Number = 0;
			var numY:Number = 0;
			
			//删除原有列表项目
			try {
				for (var j:int = 0; j<this.numChildren; j++) {
					var sprite:Sprite = this.getChildAt(j) as Sprite;
					if (sprite != null) {
							this.removeChild(sprite);
					}
				}
			} catch (e:Error) {
			}
			
			//更新的列表项目
			for (var i:int; i < this.spriteArray.length; i++) {
				var sp:Sprite = this.spriteArray[i] as Sprite;
				sp.x = (this.spriteSpaseX) * numX;
				sp.y = (this.spriteSpaseY) * numY;
				trace(numX);
				trace(numY);
				if (listType == LIST_TYPE_ROW) {  //如果按行输出
					numX++;
					if (this.spriteSpaseX * (numX + 1) > this.width) {
						numX = 0;
						numY++;
					}
				}
				if (listType == LIST_TYPE_LIST) {  //如果按列输出
					numY++;
					if (this.spriteSpaseY * (numY + 1) > this.height) {
						numY = 0;
						numX++;
					}
				}
				
				this.addChild(sp);
			}
		}
		
		
		/**
		 * 
		 * @param y
		 * 
		 */		
		public function set spriteArray(ary:Array):void{
			this._spriteArray = ary;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get spriteArray():Array{
			return this._spriteArray;
		}
		
		/**
		 * 
		 * @param y
		 * 
		 */		
		public function set spriteSpaseY(y:Number):void{
			this._spriteSpaseY = y;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get spriteSpaseY():Number{
			return this._spriteSpaseY;
		}
		
		/**
		 * 
		 * @param x
		 * 
		 */		
		public function set spriteSpaseX(x:Number):void{
			this._spriteSpaseX = x;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get spriteSpaseX():Number{
			return this._spriteSpaseX;
		}
		
		/**
		 * 
		 * @param type
		 * 
		 */		
		public function set listType(type:String):void{
			this._listType = type;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get listType():String{
			return this._listType;
		}
	}
}