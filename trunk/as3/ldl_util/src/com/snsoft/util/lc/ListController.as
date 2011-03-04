package com.snsoft.util.lc{
	import flash.geom.Point;
	
	/**
	 * 列表显示控制器 
	 * @author Administrator
	 * 
	 */	
	public class ListController{
		
		/**
		 * 按行或按列显示
		 */		
		private var type:String;
		
		/**
		 * 最大行数 
		 */		
		private var maxTypeNumber:int;
		
		/**
		 * 行间隔
		 */		
		private var lineSpace:int;
		
		/**
		 * 列间隔
		 */		
		private var columnSpace:int;
		
		/**
		 * 当前行数 
		 */		
		private var currentLineNumber:int = 0;
		
		/**
		 *当前列数 
		 */		
		private var currentColumnNumber:int = 0;
		
		/**
		 * 列表显示控制器  
		 * @param type 按行或按列显示
		 * @param maxTypeNumber 最大行数或列数，按行显示为最大列数，按列显示为最大行数
		 * @param lineSpace 行间隔
		 * @param columnSpace 列间隔
		 * 
		 */		
		public function ListController(type:String = "list", maxTypeNumber:Number = 0, columnSpace:Number = 0, lineSpace:Number = 0){
			this.type = type;
			this.maxTypeNumber = maxTypeNumber;
			this.lineSpace = lineSpace;
			this.columnSpace = columnSpace;
		}
		
		/**
		 * 下一个显示项的坐标 
		 * @return 
		 * 
		 */		
		public function nextPlace():Point{
			var p:Point = new Point();
			trace(currentColumnNumber,currentLineNumber);
			if(this.type == ListControllerType.LIST){
				p.x = currentColumnNumber * columnSpace;
				p.y = currentLineNumber * lineSpace;
				currentColumnNumber ++;
				if(currentColumnNumber == maxTypeNumber){
					currentColumnNumber = 0;
					currentLineNumber ++;
				}
			}
			if(this.type == ListControllerType.COLUMN){
				p.x = currentColumnNumber * columnSpace;
				p.y = currentLineNumber * lineSpace;
				currentLineNumber ++;
				if(currentLineNumber == maxTypeNumber){
					currentLineNumber = 0;
					currentColumnNumber ++;
				}
			}
			return p;
		}
	}
}