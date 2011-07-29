package com.snsoft.map {
	import com.snsoft.util.HashVector;

	import fl.core.UIComponent;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class ToolsBar extends UIComponent {
		//工具按钮间隔	
		private var toolSpacePoint:Point = new Point(4, 4);

		//点击画线工具事件类型
		public static const TOOL_TYPE_LINE:String = "TOOL_TYPE_LINE";

		//点击画线工具事件类型
		public static const TOOL_TYPE_PATH:String = "TOOL_TYPE_PATH";

		//点击选择工具事件类型
		public static const TOOL_TYPE_SELECT:String = "TOOL_TYPE_SELECT";

		//点击选择工具事件类型
		public static const TOOL_TYPE_DRAG:String = "TOOL_TYPE_DRAG";

		//工具点击事件类型		
		public static const TOOL_CLICK:String = "TOOL_CLICK";

		private var _toolEventType:String = null;

		//工具按钮哈希表	
		private var toolBtnHashArray:HashVector = new HashVector();

		public function ToolsBar() {
			super();
			this.width = 30;
			this.height = 30;
			var lineBtn:ToolBtn = new ToolBtn("ToolLineDefaultSkin", "ToolLineOverSkin", "ToolLineDownSkin", TOOL_TYPE_LINE);
			lineBtn.refresh();
			this.addToolBtn(lineBtn);
			var selectBtn:ToolBtn = new ToolBtn("ToolSelectDefaultSkin", "ToolSelectOverSkin", "ToolSelectDownSkin", TOOL_TYPE_SELECT);
			selectBtn.refresh();
			this.addToolBtn(selectBtn);
			var dragBtn:ToolBtn = new ToolBtn("ToolDragDefaultSkin", "ToolDragOverSkin", "ToolDragDownSkin", TOOL_TYPE_DRAG);
			dragBtn.refresh();
			this.addToolBtn(dragBtn);

			var pathBtn:ToolBtn = new ToolBtn("ToolPathDefaultSkin", "ToolPathOverSkin", "ToolPathDownSkin", TOOL_TYPE_PATH);
			pathBtn.refresh();
			this.addToolBtn(pathBtn);
		}

		/**
		 * 添加工具
		 * @param btn 工具
		 *
		 */

		public function get toolEventType():String {
			return _toolEventType;
		}

		public function addToolBtn(toolBtn:ToolBtn):void {
			var btn:ToolBtn = toolBtn;
			btn.x = this.toolSpacePoint.x;
			btn.y = (this.toolSpacePoint.y + btn.height) * this.toolBtnHashArray.length;
			this.addChild(btn);
			this.toolBtnHashArray.push(btn, toolBtn.toolEventType);
			btn.addEventListener(MouseEvent.CLICK, handlerToolBtnClick);
		}

		private function handlerToolBtnClick(e:Event):void {
			var cbtn:ToolBtn = e.currentTarget as ToolBtn;
			var ha:HashVector = this.toolBtnHashArray;
			for (var i:int = 0; i < ha.length; i++) {
				var btn:ToolBtn = ha.findByIndex(i) as ToolBtn;
				if (btn != cbtn) {
					btn.putToDefaultSkin();
					btn.refresh();
				}
			}
			this._toolEventType = cbtn.toolEventType;
			this.dispatchEvent(new Event(TOOL_CLICK));
		}
	}
}
