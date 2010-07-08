package com.snsoft.tvc2.dataObject{
	import flash.media.Sound;
	
	/**
	 * 
	 * @author Administrator
	 * 
	 */	
	public class DataDO{
		
		private var _type:String = null;
		
		private var _data:Vector.<ListDO> = null;
		
		private var _xGraduationText:Vector.<ListDO> = null;
		
		private var _yGraduationText:Vector.<ListDO> = null;
		
		private var _broadcast:Vector.<ListDO> = null;
		
		private var _unitX:String;
		
		private var _unitY:String;
		
		private var _bizSoundList:Vector.<Vector.<Sound>> = null;
		
		private var _bizSoundTextList:Vector.<Vector.<String>> = null;
		
		public function DataDO()
		{
		}

		public function get data():Vector.<ListDO>
		{
			return _data;
		}

		public function set data(value:Vector.<ListDO>):void
		{
			_data = value;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		public function get xGraduationText():Vector.<ListDO>
		{
			return _xGraduationText;
		}

		public function set xGraduationText(value:Vector.<ListDO>):void
		{
			_xGraduationText = value;
		}

		public function get yGraduationText():Vector.<ListDO>
		{
			return _yGraduationText;
		}

		public function set yGraduationText(value:Vector.<ListDO>):void
		{
			_yGraduationText = value;
		}

		public function get broadcast():Vector.<ListDO>
		{
			return _broadcast;
		}

		public function set broadcast(value:Vector.<ListDO>):void
		{
			_broadcast = value;
		}

		public function get unitX():String
		{
			return _unitX;
		}

		public function set unitX(value:String):void
		{
			_unitX = value;
		}

		public function get unitY():String
		{
			return _unitY;
		}

		public function set unitY(value:String):void
		{
			_unitY = value;
		}

		public function get bizSoundList():Vector.<Vector.<Sound>>
		{
			return _bizSoundList;
		}

		public function set bizSoundList(value:Vector.<Vector.<Sound>>):void
		{
			_bizSoundList = value;
		}

		public function get bizSoundTextList():Vector.<Vector.<String>>
		{
			return _bizSoundTextList;
		}

		public function set bizSoundTextList(value:Vector.<Vector.<String>>):void
		{
			_bizSoundTextList = value;
		}

		 


	}
}