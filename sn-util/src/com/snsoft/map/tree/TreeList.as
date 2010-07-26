package com.snsoft.map.tree
{
	import com.snsoft.util.HashVector;
	import com.snsoft.map.util.MapUtil;
	
	import fl.core.UIComponent;
	
	import flash.events.Event;
	
	public class TreeList extends UIComponent
	{
		//树列表
		private var v:HashVector = new HashVector();
		
		private var _currentClickBtnName:String = null;
		
		private var btnHeight:Number = 25;
		
		public static const TREE_CLICK:String = "TREE_CLICK";
		
		public static const SUB_TREE_VIEW:String = "SUB_TREE_VIEW";
		
		public function TreeList()
		{
			super();
		}
		
		/**
		 * 初始化UI 
		 * 
		 */		
		override protected function configUI():void {
			super.configUI();
		}
		
		/**
		 * 画(更新)UI 
		 * 
		 */		
		override protected function draw():void{
			MapUtil.deleteAllChild(this);
			for(var i:int = 0;i<this.length;i++){
				var btn:TreeNodeButton = this.findByIndex(i) as TreeNodeButton;
				btn.y = btnHeight * i;
				this.addChild(btn);
			}
			this.height = btnHeight * this.length;
			super.draw();
		}
		
		/**
		 * 列表长度 
		 * @return 
		 * 
		 */		
		public function get length():int{
			return v.length;
		}
		
		/**
		 * 添加 
		 * @param tree
		 * 
		 */		
		public function put(name:String,btn:TreeNodeButton):void{
			this.v.push(btn,name);
			btn.name = name;
			btn.addEventListener(TreeNodeButton.TREE_CLICK,handlerMskMouseClick);
			this.drawNow();
		}
		
		/**
		 *  
		 * @param e
		 * 
		 */		
		private function handlerMskMouseClick(e:Event):void{
			var btn:TreeNodeButton = e.currentTarget as TreeNodeButton;
			this._currentClickBtnName = btn.name;
			this.dispatchEvent(new Event(TreeNodeButton.TREE_CLICK));
		}
		
		/**
		 * 删除 
		 * @param i
		 * 
		 */		
		public function removeByIndex(i:int):void{
			this.v.removeByIndex(i);
			this.drawNow();
		}
		
		/**
		 * 获得 
		 * @return 
		 * 
		 */		
		public function findByIndex(i:int):TreeNodeButton{
			return this.v.findByIndex(i) as TreeNodeButton;
		}

		public function get currentClickBtnName():String
		{
			return _currentClickBtnName;
		}

	}
}